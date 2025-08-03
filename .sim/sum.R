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
    "sim-args.R"
  )
)
# ------------------------------------------------------------------------------

lapply(
  X = seq_len(tasks),
  FUN = Sum,
  reps = reps,
  output_folder = output_folder,
  overwrite = TRUE,
  integrity = TRUE,
  ncores = parallel::detectCores()
)
