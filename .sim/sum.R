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
    "sim-args.R"
  )
)
# ------------------------------------------------------------------------------
lapply(
  X = seq_len(tasks),
  FUN = Sum,
  reps = reps,
  output_folder = output_folder,
  overwrite = FALSE,
  integrity = TRUE,
  naive = TRUE,
  metavar_normal = TRUE,
  metavar_robust = TRUE,
  mplus = TRUE,
  ncores = parallel::detectCores()
)
