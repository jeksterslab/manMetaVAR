#' Summary
#'
#' @author Ivan Jacob Agaloos Pesigan
#'
#' @return The output is saved as an external file in `output_folder`.
#'
#' @inheritParams Template
#' @export
#' @keywords manMetaVAR summary simulation
Sum <- function(taskid,
                reps,
                output_folder,
                overwrite,
                integrity,
                metavar,
                mlvar,
                mplus,
                ncores) {
  # Do not include default arguments here.
  # All arguments should be set in `.sim/sim-args.R.R`.
  # Add taskid to output_folder
  output_folder <- file.path(
    output_folder,
    paste0(
      SimProj(),
      "-",
      sprintf(
        "%05d",
        taskid
      )
    )
  )
  if (!file.exists(output_folder)) {
    dir.create(
      path = output_folder,
      showWarnings = FALSE,
      recursive = TRUE
    )
    .SimChMod(output_folder)
  }
  if (mplus) {
    SumFitMplus(
      taskid = taskid,
      reps = reps,
      output_folder = output_folder,
      overwrite = overwrite,
      integrity = integrity,
      ncores = ncores
    )
  }
  if (metavar) {
    SumFitMetaVARNormal(
      taskid = taskid,
      reps = reps,
      output_folder = output_folder,
      overwrite = overwrite,
      integrity = integrity,
      ncores = ncores
    )
    SumFitMetaVARLB(
      taskid = taskid,
      reps = reps,
      output_folder = output_folder,
      overwrite = overwrite,
      integrity = integrity,
      ncores = ncores
    )
  }
  if (mlvar) {
    SumFitMLVAR(
      taskid = taskid,
      reps = reps,
      output_folder = output_folder,
      overwrite = overwrite,
      integrity = integrity,
      ncores = ncores
    )
  }
}
