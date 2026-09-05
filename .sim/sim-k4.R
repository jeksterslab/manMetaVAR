#!/usr/bin/env Rscript

# AVOID OVER SUBSCRIPTION ------------------------------------------------------
Sys.setenv(
  OMP_NUM_THREADS = "1",
  MKL_NUM_THREADS = "1",
  OPENBLAS_NUM_THREADS = "1"
)

# SIMULATION ARGUMENTS ---------------------------------------------------------
suppressMessages(
  suppressWarnings(
    library(OpenMx)
  )
)
suppressMessages(
  suppressWarnings(
    library(fitVARMxID)
  )
)
suppressMessages(
  suppressWarnings(
    library(metaDyn)
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
    "sim-k4-args.R"
  )
)
# ------------------------------------------------------------------------------

# RUN --------------------------------------------------------------------------
args <- commandArgs(trailingOnly = TRUE)
if (length(args) != 2L) {
  stop(
    "Expected exactly two arguments: repid and taskid.",
    call. = FALSE
  )
}
repid <- suppressWarnings(as.integer(args[1]))
taskid <- suppressWarnings(as.integer(args[2]))
if (
  is.na(repid) ||
    is.na(taskid) ||
    repid < 1L ||
    taskid < 1L
) {
  stop(
    "repid and taskid must be positive integers.",
    call. = FALSE
  )
}
SimK4(
  taskid = taskid,
  repid = repid,
  output_folder = output_folder,
  overwrite = overwrite,
  integrity = TRUE, # FALSE to prioritize speed, TRUE to prioritize output
  seed = seed,
  data = data,
  naive = naive,
  metavar = metavar,
  mplus = mplus,
  chains = chains,
  iter = iter,
  fscores = fscores,
  plot = plot
)
warnings()
# ------------------------------------------------------------------------------
