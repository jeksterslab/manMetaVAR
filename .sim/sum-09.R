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
Sum(
  taskid = 9,
  reps = reps,
  output_folder = output_folder,
  overwrite = FALSE,
  integrity = TRUE,
  metavar = TRUE,
  mlvar = TRUE,
  mplus = TRUE,
  ncores = parallel::detectCores()
)
