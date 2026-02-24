#' Summary
#'
#' @author Ivan Jacob Agaloos Pesigan
#'
#' @param mplus Logical.
#'   If `mplus = TRUE`, summarize the DSEM model.
#' @param metavar_normal Logical.
#'   If `metavar_normal = TRUE`, summarize metaVAR model using
#'   normal confidence intervals.
#' @param metavar_robust Logical.
#'   If `metavar_robust = TRUE`, summarize metaVAR model using
#'   robust (sandwich) confidence intervals.
#' @param naive Logical.
#'   If `naive = TRUE`, summarize naive estimates.
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
                metavar_normal,
                metavar_robust,
                naive,
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
  if (metavar_normal) {
    SumFitMetaVARNormal(
      taskid = taskid,
      reps = reps,
      output_folder = output_folder,
      overwrite = overwrite,
      integrity = integrity,
      ncores = ncores
    )
  }
  if (metavar_robust) {
    SumFitMetaVARRobust(
      taskid = taskid,
      reps = reps,
      output_folder = output_folder,
      overwrite = overwrite,
      integrity = integrity,
      ncores = ncores
    )
  }
  if (naive) {
    SumFitNaive(
      taskid = taskid,
      reps = reps,
      output_folder = output_folder,
      overwrite = overwrite,
      integrity = integrity,
      ncores = ncores
    )
  }
}
