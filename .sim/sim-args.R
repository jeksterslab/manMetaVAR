# SIMULATION ARGUMENTS ---------------------------------------------------------
tasks <- 27L
reps <- 1000L
overwrite <- FALSE
seed <- NULL
data <- FALSE
metavar <- FALSE
mlvar < FALSE
mplus <- FALSE
chains <- 2L
iter <- 60000L
fscores <- NULL
plot <- FALSE
default_priors <- FALSE
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
