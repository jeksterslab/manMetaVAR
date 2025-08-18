# SIMULATION ARGUMENTS ---------------------------------------------------------
tasks <- 9L
reps <- 500L
overwrite <- FALSE
seed <- NULL
n_chains <- 4
n_adapt <- 10000
n_iter <- 10000
thin <- 1
run_jags <- FALSE
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
