#! /usr/bin/env Rscript

## We need to create a function, because we want to use
## on.exit.

do <- function() {

  ## Load packages
  library(methods)
  library(crandb)

  ## Set up config

  root <- list(uri = "https://crandb.r-pkg.org:2053/cran",
               priority = 10)
  crandb:::couchdb_server(root, root = TRUE)
  options(repos = structure(c(CRAN = "https://cran.r-project.org")))

  ## Do the update, and log it
  data_dir <- "."
  log_file <- file.path(data_dir, "update-crandb.log")
  cat(format(Sys.time()), " updating... ", file = log_file, append = TRUE)
  events <- crandb:::crandb_update()

  cat("new: ", file = log_file, append = TRUE)
  for (p in events$new) {
    cat(p, "", file = log_file, append = TRUE)
  }

  cat("updated: ", file = log_file, append = TRUE)
  for (p in events$updated) {
    cat(p, "", file = log_file, append = TRUE)
  }

  cat("archived: ", paste(collapse = " ", events$archived),
      file = log_file, append = TRUE)
  cat("DONE\n", file = log_file, append = TRUE)

  ## Pushmon notification, that we are alive
  httr::GET("http://pshmn.com/eHGnGa")
}

do()
