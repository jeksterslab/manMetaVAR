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

lapply(
  X = 9, # seq_len(tasks),
  FUN = SumK4,
  reps = reps,
  output_folder = output_folder,
  overwrite = overwrite,
  integrity = TRUE,
  naive = naive,
  metavar_normal = metavar_normal,
  metavar_robust = metavar_robust,
  mplus = mplus,
  ncores = parallel::detectCores()
)
