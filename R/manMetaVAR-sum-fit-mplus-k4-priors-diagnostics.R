#' Summary (FitMplusK4 User-Prior Diagnostics)
#'
#' @details This function is executed via [SumK4()].
#'
#' @author Ivan Jacob Agaloos Pesigan
#'
#' @return The output is saved as an external file in `output_folder`.
#'
#' @inheritParams Template
#' @export
#' @keywords manMetaVAR summary diagnostics simulation
SumFitMplusK4PriorsDiagnostics <- function(taskid,
                                           reps,
                                           output_folder,
                                           overwrite,
                                           integrity,
                                           ncores) {
  .SumFitMplusDiagnostics(
    taskid = taskid,
    reps = reps,
    output_folder = output_folder,
    overwrite = overwrite,
    integrity = integrity,
    ncores = ncores,
    input_type = "fit-mplus-k4-priors-diagnostics",
    output_type = "summary-fit-mplus-k4-priors-diagnostics",
    default_priors = FALSE,
    diagnostics_class = "manmetavar.mplus.k4.diagnostics",
    fit_function = "FitMplusK4Diagnostics()",
    method = "BMLVAR",
    summary_class = "manmetavar.mplus.k4.diagnostics.summary",
    fit_input_type = "fit-mplus-k4-priors",
    diagnostics_function = FitMplusK4Diagnostics
  )
}
