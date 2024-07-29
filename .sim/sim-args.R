# SIMULATION ARGUMENTS ---------------------------------------------------------
tasks <- 10L
reps <- 1000L
overwrite <- FALSE
R <- 20000L
delta_t <- 1:30
# ------------------------------------------------------------------------------
output_root <- "/scratch/ibp5092/manMetaVAR/.sim"
project <- manMetaVAR::SimProj()
output_folder <- manMetaVAR:::.SimPath(
  root = output_root,
  project = project
)
# ------------------------------------------------------------------------------
