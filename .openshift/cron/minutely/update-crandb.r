#! /sandbox/r/bin/Rscript

## We need to create a function, because we want to use
## on.exit.

do <- function() {
  out_dir <- Sys.getenv("OPENSHIFT_REPO_DIR")
  pid_file <- file.path(out_dir, "update-crandb.pid")

  ## If the pid file exists, then we only try in every five
  ## minutes. In case the previous process got stuck
  minute <- as.numeric(format(Sys.time(), "%M"))
  if (file.exists(pid_file) && minute %% 5) { return() }

  ## OK, here we go, write pid file
  pid <- Sys.getpid()
  cat(pid, "\n", file = pid_file)

  ## Remove pid file, but only if it was written by us.
  ## Yes, this is a race condition, but it not critical if
  ## we remove someone else's pid
  clean_pid <- function() {
    if (scan(pid_file, quiet = TRUE)[1] == pid) {
      try(unlink(pid_file), silent = TRUE)
    }
  }
  on.exit(clean_pid(), add = TRUE)

  ## Load packages
  library(crandb)

  ## Set up config

  non_root <- list(list(uri = "https://db.r-pkg.org/", priority = 10))
  root <- list(list(uri = "https://db.r-pkg.org:6984/cran",
                    priority = 10))
  crandb:::couchdb_server(non_root)
  crandb:::couchdb_server(root, root = TRUE)
  options(repos = structure(c(CRAN = "http://cran.r-project.org")))

  ## Do the update, and log it
  data_dir <- Sys.getenv("OPENSHIFT_DATA_DIR")
  log_file <- file.path(data_dir, "update-crandb.log")
  cat(format(Sys.time()), " updating... ", file = log_file, append = TRUE)
  crandb:::crandb_update()
  cat("DONE\n", file = log_file, append = TRUE)

  ## Pushmon notification, that we are alive
  httr::GET("http://pshmn.com/eHGnGa")
}

do()
