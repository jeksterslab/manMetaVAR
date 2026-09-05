#' Summarize Simulation Diagnostics
#'
#' Summarizes the machine-readable status manifests, boundary or near-zero
#' heterogeneity diagnostics, and runtime for a simulation task.
#'
#' @param variance_tol Numeric scalar. Variance estimates no greater than this
#'   value are classified as boundary estimates for ML-based methods and as
#'   near-zero estimates for Bayesian DSEM.
#' @param eigen_tol Numeric scalar. Estimated heterogeneity covariance matrices
#'   with minimum eigenvalues no greater than this value are classified as
#'   near singular.
#'
#' @inheritParams Template
#' @return The output is saved as an external file in `output_folder` and is
#'   returned invisibly.
#' @export
#' @keywords manMetaVAR summary simulation diagnostics
SumDiagnostics <- function(taskid,
                           reps,
                           output_folder,
                           overwrite,
                           integrity,
                           naive,
                           metavar,
                           mplus,
                           variance_tol = 1e-6,
                           eigen_tol = 1e-8) {
  .TaskParameters(taskid = taskid)
  reps <- .SumValidateReps(reps)
  output_folder <- file.path(
    output_folder,
    paste0(
      SimProj(),
      "-",
      sprintf("%05d", taskid)
    )
  )
  .SumDiagnosticsCore(
    taskid = taskid,
    reps = reps,
    output_folder = output_folder,
    overwrite = overwrite,
    integrity = integrity,
    naive = naive,
    metavar = metavar,
    mplus = mplus,
    variance_tol = variance_tol,
    eigen_tol = eigen_tol,
    k4 = FALSE
  )
}
