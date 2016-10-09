#! /sandbox/r/bin/Rscript

## It is better to create a function, so that you can use on.exit.

do <- function() {

  URL <- "http://cran.rstudio.com/src/contrib/Views.rds"
  con <- gzcon(url(URL))
  on.exit(close(con))

  views <- readRDS(con)
  for (v in views) {
    httr::GET(paste0("http://docs.r-pkg.org/api/build/task-view/", v$name))
  }
}

do()
