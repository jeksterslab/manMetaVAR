#' Summary (FitMplusK4 with User-Defined Priors)
#'
#' @details This function is executed via [SumK4()].
#'
#' @author Ivan Jacob Agaloos Pesigan
#'
#' @return The output is saved as an external file in `output_folder`.
#'
#' @inheritParams Template
#' @export
#' @keywords manMetaVAR summary simulation
SumFitMplusK4Priors <- function(taskid,
                                reps,
                                output_folder,
                                overwrite,
                                integrity,
                                ncores) {
  .SumFitK4(
    taskid = taskid,
    reps = reps,
    output_folder = output_folder,
    overwrite = overwrite,
    integrity = integrity,
    ncores = ncores,
    input_type = "fit-mplus-k4-priors",
    output_type = "summary-fit-mplus-k4-priors",
    method = "BMLVAR-Priors",
    ci = "Posterior",
    mplus = TRUE
  )
}
