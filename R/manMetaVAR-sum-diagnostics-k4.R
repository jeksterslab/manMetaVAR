#' Summarize Four-Variable Simulation Diagnostics
#'
#' @rdname SumDiagnostics
#' @export
#' @keywords manMetaVAR summary simulation diagnostics
SumDiagnosticsK4 <- function(taskid,
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
      "-k4-",
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
    k4 = TRUE
  )
}
