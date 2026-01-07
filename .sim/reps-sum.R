#!/usr/bin/env Rscript

# SIMULATION ARGUMENTS ---------------------------------------------------------
suppressMessages(
  suppressWarnings(
    library(OpenMx)
  )
)
suppressMessages(
  suppressWarnings(
    library(fitDTVARMxID)
  )
)
suppressMessages(
  suppressWarnings(
    library(metaVAR)
  )
)
suppressMessages(
  suppressWarnings(
    library(manMetaVAR)
  )
)
source(
  file.path(
    "/scratch",
    Sys.getenv("USER"),
    "manMetaVAR",
    ".sim",
    "sim-args.R"
  )
)
# ------------------------------------------------------------------------------
args <- commandArgs(trailingOnly = TRUE)
taskid <- as.integer(args[1])
Sum(
  taskid = taskid,
  reps = reps,
  output_folder = output_folder,
  overwrite = FALSE,
  integrity = TRUE,
  metavar_normal = TRUE,
  metavar_robust = TRUE,
  metavar_lb = TRUE,
  mlvar = TRUE,
  mplus = TRUE,
  ncores = parallel::detectCores()
)
