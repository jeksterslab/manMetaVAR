#' Summary (FitMplus Diagnostics)
#'
#' @details This function is executed via the `Sum` function.
#'
#' @author Ivan Jacob Agaloos Pesigan
#'
#' @return The output is saved as an external file in `output_folder`.
#'
#' @inheritParams Template
#' @export
#' @keywords manMetaVAR summary diagnostics simulation
SumFitMplusDiagnostics <- function(taskid,
                                   reps,
                                   output_folder,
                                   overwrite,
                                   integrity,
                                   ncores) {
  # Do not include default arguments here.
  # Do not run on its own. Use the `Sum` function.
  .SumFitMplusDiagnostics(
    taskid = taskid,
    reps = reps,
    output_folder = output_folder,
    overwrite = overwrite,
    integrity = integrity,
    ncores = ncores,
    input_type = "fit-mplus-diagnostics",
    output_type = "summary-fit-mplus-diagnostics",
    default_priors = TRUE
  )
}
