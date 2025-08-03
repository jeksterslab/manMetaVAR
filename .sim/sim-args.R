# SIMULATION ARGUMENTS ---------------------------------------------------------
tasks <- 40L
reps <- 1000L
overwrite <- FALSE
seed <- NULL
# ------------------------------------------------------------------------------
output_root <- file.path(
  "/scratch",
  Sys.getenv("USER"),
  "manMetaVAR",
  ".sim"
)
project <- manMetaVAR::SimProj()
output_folder <- manMetaVAR:::.SimPath(
  root = output_root,
  project = project
)
# ------------------------------------------------------------------------------
