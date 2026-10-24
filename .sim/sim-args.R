# SIMULATION ARGUMENTS ---------------------------------------------------------
tasks <- 36L
reps <- 1000L
overwrite <- FALSE
seed <- NULL
data <- TRUE
naive <- TRUE
metavar <- TRUE
mplus <- TRUE
metavar_normal <- TRUE
metavar_robust <- TRUE
# Summaries only: boundary LRT and Stage 1 calibration, and whether to
# rewrite existing summary files (does not touch the simulation fits).
lrt <- TRUE
calibration <- TRUE
sum_overwrite <- TRUE
chains <- 2L
iter <- 40000L
fscores <- NULL
plot <- FALSE
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
