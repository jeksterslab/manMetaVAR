#' Check Replication
#'
#' @author Anonymous
#'
#' @return The output is saved as an external file in `output_folder`.
#'
#' @inheritParams Template
#'
#' @export
#' @keywords manMetaVAR check simulation
Check <- function(taskid,
                  repid,
                  output_folder,
                  naive,
                  metavar,
                  mplus) {
  # Do not include default arguments here.
  # All arguments should be set in `sim/sim-args.R`.
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
  suffix <- .SimSuffix(
    taskid = taskid,
    repid = repid
  )
  if (mplus) {
    CheckFitMplus(
      taskid = taskid,
      repid = repid,
      output_folder = output_folder,
      suffix = suffix
    )
  }
  if (metavar) {
    CheckFitDTVAR(
      taskid = taskid,
      repid = repid,
      output_folder = output_folder,
      suffix = suffix
    )
    CheckFitMetaVAR(
      taskid = taskid,
      repid = repid,
      output_folder = output_folder,
      suffix = suffix
    )
  }
  if (naive) {
    CheckFitNaive(
      taskid = taskid,
      repid = repid,
      output_folder = output_folder,
      suffix = suffix
    )
  }
}
