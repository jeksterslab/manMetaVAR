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
                mplus = FALSE) {
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
  SumFitMetaVARNormal(
    taskid = taskid,
    reps = reps,
    output_folder = output_folder,
    overwrite = overwrite,
    integrity = integrity
  )
  SumFitMetaVARLB(
    taskid = taskid,
    reps = reps,
    output_folder = output_folder,
    overwrite = overwrite,
    integrity = integrity
  )
  SumFitMLVAR(
    taskid = taskid,
    reps = reps,
    output_folder = output_folder,
    overwrite = overwrite,
    integrity = integrity
  )
  if (mplus) {
    SumFitMplus(
      taskid = taskid,
      reps = reps,
      output_folder = output_folder,
      overwrite = overwrite,
      integrity = integrity
    )
  }
}
