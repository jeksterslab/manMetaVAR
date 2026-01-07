# SIMULATION ARGUMENTS ---------------------------------------------------------
tasks <- 27L
reps <- 1000L
overwrite <- FALSE
seed <- NULL
data <- TRUE
metavar <- TRUE
metavar_normal <- TRUE
metavar_robust <- TRUE
metavar_lb <- TRUE
mlvar <- TRUE
mplus <- TRUE
chains <- 2L
iter <- 120000L
fscores <- NULL
plot <- FALSE
default_priors <- TRUE
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
