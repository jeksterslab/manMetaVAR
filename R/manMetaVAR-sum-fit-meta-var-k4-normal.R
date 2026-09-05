#' Summary: Normal Theory (FitMetaVARK4)
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
SumFitMetaVARK4Normal <- function(taskid,
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
    input_type = "fit-meta-var-mx-k4",
    output_type = "summary-fit-meta-var-mx-k4-normal",
    method = "MetaVAR",
    ci = "Normal",
    mplus = FALSE,
    robust = FALSE
  )
}
