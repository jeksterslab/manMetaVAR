#!/usr/bin/env Rscript

# SIMULATION ARGUMENTS ---------------------------------------------------------
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
CompressK4(
  taskid = taskid,
  repid = repid,
  output_folder = output_folder
)
warnings()
# ------------------------------------------------------------------------------
