#' Simulation Replication - FitMplus Diagnostics (User Defined Priors)
#'
#' @details This function is executed via the `Sim` function.
#'
#' @author Ivan Jacob Agaloos Pesigan
#'
#' @return The output is saved as an external file in `output_folder`.
#'
#' @inheritParams Template
#' @export
#' @keywords manMetaVAR fit diagnostics simulation
SimFitMplusPriorsDiagnostics <- function(taskid,
                                         repid,
                                         output_folder,
                                         seed,
                                         suffix,
                                         overwrite,
                                         integrity) {
  # Do not include default arguments here.
  # Do not run on its own. Use the `Sim` function.
  fn_input <- SimFN(
    output_type = "fit-mplus-priors",
    output_folder = output_folder,
    suffix = suffix
  )
  fn_output <- SimFN(
    output_type = "fit-mplus-priors-diagnostics",
    output_folder = output_folder,
    suffix = suffix
  )
  run <- .SimCheck(
    fn = fn_output,
    overwrite = overwrite,
    integrity = integrity
  )
  if (run) {
    if (file.exists(fn_output)) {
      unlink(fn_output)
    }
    input <- tryCatch(
      .SimReadUpstream(fn_input),
      simTools_upstream_failure = function(e) NULL,
      simTools_infrastructure_error = function(e) NULL
    )
    if (is.null(input)) {
      return(invisible(FALSE))
    }
    diagnostics <- FitMplusDiagnostics(
      object = input
    )
    if (isTRUE(diagnostics$run$default_priors)) {
      stop(
        "The user-prior diagnostics input was fit with Mplus default priors.",
        call. = FALSE
      )
    }
    saveRDS(
      object = diagnostics,
      file = fn_output,
      compress = "xz"
    )
    .SimChMod(fn_output)
  }
  invisible(TRUE)
}
