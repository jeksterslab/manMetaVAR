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
parallel::mclapply(
  X = seq_len(tasks),
  FUN = Sum,
  reps = reps,
  output_folder = output_folder,
  overwrite = FALSE,
  integrity = TRUE,
  metavar = TRUE,
  mlvar = TRUE,
  mplus = TRUE,
  mc.cores = parallel::detectCores()
)
