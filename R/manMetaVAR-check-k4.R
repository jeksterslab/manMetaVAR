#' Check Replication
#'
#' @author Ivan Jacob Agaloos Pesigan
#'
#' @return The output is saved as an external file in `output_folder`.
#'
#' @inheritParams Template
#'
#' @export
#' @keywords manMetaVAR check simulation
CheckK4 <- function(taskid,
                    repid,
                    output_folder,
                    naive,
                    metavar,
                    mplus) {
  # Do not include default arguments here.
  # All arguments should be set in `sim/sim-k4-args.R`.
  # Add taskid to output_folder
  output_folder <- file.path(
    output_folder,
    paste0(
      SimProj(),
      "-",
      "k4",
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
    CheckFitMplusK4(
      taskid = taskid,
      repid = repid,
      output_folder = output_folder,
      suffix = suffix
    )
    CheckFitMplusK4Priors(
      taskid = taskid,
      repid = repid,
      output_folder = output_folder,
      suffix = suffix
    )
  }
  if (metavar || naive) {
    CheckFitDTVARK4(
      taskid = taskid,
      repid = repid,
      output_folder = output_folder,
      suffix = suffix
    )
  }
  if (metavar) {
    CheckFitMetaVARK4(
      taskid = taskid,
      repid = repid,
      output_folder = output_folder,
      suffix = suffix
    )
  }
  if (naive) {
    message(
      "No naive for k = 4."
    )
  }
  status <- .CheckStatusManifest(
    taskid = taskid,
    repid = repid,
    output_folder = output_folder,
    suffix = suffix,
    naive = naive,
    metavar = metavar,
    mplus = mplus,
    k4 = TRUE
  )
  .CheckStatusGate(status)
  invisible(status)
}
