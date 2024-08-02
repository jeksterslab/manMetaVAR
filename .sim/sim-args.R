# SIMULATION ARGUMENTS ---------------------------------------------------------
tasks <- 160L
reps <- 1000L
overwrite <- FALSE
# ------------------------------------------------------------------------------
output_root <- "/scratch/ibp5092/manMetaVAR/.sim"
project <- manMetaVAR::SimProj()
output_folder <- manMetaVAR:::.SimPath(
  root = output_root,
  project = project
)
# ------------------------------------------------------------------------------
