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

# RUN --------------------------------------------------------------------------
args <- commandArgs(trailingOnly = TRUE)
repid <- as.integer(args[1])
taskid <- as.integer(args[2])
tryCatch(
  {
    # setTimeLimit(elapsed = 1 * 60 * 60)
    Sim(
      taskid = taskid,
      repid = repid,
      output_folder = output_folder,
      overwrite = overwrite,
      integrity = TRUE, # FALSE to prioritize speed, TRUE to prioritize output
      seed = seed,
      data = data,
      metavar = metavar,
      mlvar = mlvar,
      mplus = mplus,
      chains = chains,
      iter = iter,
      fscores = fscores,
      plot = plot,
      default_priors = default_priors
    )
    # setTimeLimit(elapsed = Inf)
  },
  error = function(e) {
    cat(
      paste(
        "check",
        "taskid:",
        taskid,
        "repid:",
        repid,
        "\n"
      )
    )
  },
  warning = function(w) {
    cat(
      paste(
        "check",
        "taskid:",
        taskid,
        "repid:",
        repid,
        "\n"
      )
    )
  }
)
warnings()
# ------------------------------------------------------------------------------
