# SIMULATION ARGUMENTS ---------------------------------------------------------
tasks <- 40L
reps <- 1000L
overwrite <- FALSE
seed <- NULL
n_chains <- 4
n_adapt <- 1000
n_iter <- 10000
thin <- 1
ess_crit <- 1000
max_iter <- 1000
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
