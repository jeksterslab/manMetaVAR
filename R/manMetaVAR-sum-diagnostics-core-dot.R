.SumDiagnosticsCore <- function(taskid,
                                reps,
                                output_folder,
                                overwrite,
                                integrity,
                                naive,
                                metavar,
                                mplus,
                                variance_tol,
                                eigen_tol,
                                k4 = FALSE) {
  if (!dir.exists(output_folder)) {
    stop(
      paste0(
        "Simulation output folder does not exist: ",
        output_folder,
        "."
      ),
      call. = FALSE
    )
  }
  fn_output <- SimFN(
    output_type = if (k4) {
      "summary-diagnostics-k4"
    } else {
      "summary-diagnostics"
    },
    output_folder = output_folder,
    suffix = paste0(
      sprintf("%05d", taskid),
      "-",
      sprintf("%05d", reps),
      ".Rds"
    )
  )
  run <- .SimCheck(
    fn = fn_output,
    overwrite = overwrite,
    integrity = integrity
  )
  if (!run) {
    return(invisible(NULL))
  }
  status <- .SumStatusManifest(
    taskid = taskid,
    reps = reps,
    output_folder = output_folder,
    k4 = k4
  )
  if (is.null(status)) {
    stop(
      paste0(
        "No simulation status manifests were found for taskid = ",
        taskid,
        ". Run Check/CheckK4 before SumDiagnostics."
      ),
      call. = FALSE
    )
  }
  status_summary <- .SumStatusSummary(status)
  boundary <- .SumBoundaryDiagnostics(
    taskid = taskid,
    reps = reps,
    output_folder = output_folder,
    naive = naive,
    metavar = metavar,
    mplus = mplus,
    variance_tol = variance_tol,
    eigen_tol = eigen_tol,
    k4 = k4
  )
  runtime <- .SumRuntimeDiagnostics(
    status = status,
    k4 = k4
  )
  output <- list(
    thresholds = list(
      variance_tol = variance_tol,
      eigen_tol = eigen_tol
    ),
    status = status,
    status_summary = status_summary,
    boundary = boundary,
    runtime = runtime
  )
  saveRDS(
    object = output,
    file = fn_output,
    compress = "xz"
  )
  .SimChMod(fn_output)
  invisible(output)
}
