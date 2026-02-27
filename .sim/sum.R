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
    "sim-args.R"
  )
)
# ------------------------------------------------------------------------------
lapply(
  X = seq_len(tasks),
  FUN = Sum,
  reps = reps,
  output_folder = output_folder,
  overwrite = overwrite,
  integrity = integrity,
  naive = naive,
  metavar_normal = metavar_normal,
  metavar_robust = metavar_robust,
  mplus = mplus,
  ncores = parallel::detectCores()
)
