# AVOID OVER SUBSCRIPTION ------------------------------------------------------
Sys.setenv(
  OMP_NUM_THREADS = "1",
  MKL_NUM_THREADS = "1",
  OPENBLAS_NUM_THREADS = "1"
)

# PACKAGES --------------------------------------------------------------------
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

# SIMULATION ARGUMENTS ---------------------------------------------------------
source(
  file.path(
    "/scratch",
    Sys.getenv("USER"),
    "manMetaVAR",
    ".sim",
    "sim-args.R"
  )
)

# DIAGNOSTIC ARGUMENTS ---------------------------------------------------------
.env_flag <- function(name,
                      default = FALSE) {
  value <- Sys.getenv(
    name,
    unset = if (default) "1" else "0"
  )
  tolower(value) %in% c(
    "1",
    "true",
    "yes",
    "y"
  )
}

.env_numeric <- function(name,
                         default) {
  value <- suppressWarnings(
    as.numeric(
      Sys.getenv(
        name,
        unset = as.character(default)
      )
    )
  )
  if (length(value) != 1L || !is.finite(value)) {
    stop(
      paste0(
        name,
        " must be a finite numeric value."
      ),
      call. = FALSE
    )
  }
  value
}

overwrite_diagnostics <- overwrite ||
  .env_flag("OVERWRITE_DIAGNOSTICS")
variance_tol <- .env_numeric(
  "VARIANCE_TOL",
  1e-6
)
eigen_tol <- .env_numeric(
  "EIGEN_TOL",
  1e-8
)

# SUMMARIZE DIAGNOSTICS --------------------------------------------------------
lapply(
  X = seq_len(tasks),
  FUN = SumDiagnostics,
  reps = reps,
  output_folder = output_folder,
  overwrite = overwrite_diagnostics,
  integrity = TRUE,
  naive = naive,
  metavar = metavar,
  mplus = mplus,
  variance_tol = variance_tol,
  eigen_tol = eigen_tol
)
