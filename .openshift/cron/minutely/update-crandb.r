#! /sandbox/r/bin/Rscript

out_dir <- Sys.getenv("OPENSHIFT_REPO_DIR")
cat(Sys.time(), "\n", file=file.path(out_dir, "rout.txt"))

