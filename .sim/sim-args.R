# SIMULATION ARGUMENTS ---------------------------------------------------------
tasks <- 9L
reps <- 500L
overwrite <- FALSE
seed <- NULL
n_chains <- 4
n_adapt <- 1000
n_iter <- 1000
thin <- 1
ess_crit <- 200
max_iter <- 1000
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
