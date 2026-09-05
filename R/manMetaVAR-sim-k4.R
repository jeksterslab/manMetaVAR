#' Simulation Replication
#'
#' @author Ivan Jacob Agaloos Pesigan
#'
#' @return The output is saved as an external file in `output_folder`.
#'
#' @inheritParams Template
#' @param data Logical. Simulate data.
#'
#' @export
#' @keywords manMetaVAR simulation
SimK4 <- function(taskid,
                  repid,
                  output_folder,
                  overwrite,
                  integrity,
                  seed,
                  data,
                  naive,
                  metavar,
                  mplus,
                  chains,
                  iter,
                  fscores,
                  plot) {
  # Do not include default arguments here.
  # All arguments should be set in `sim/sim-k4-args.R`.
  .TaskParameters(taskid = taskid)
  output_folder <- file.path(
    output_folder,
    paste0(
      SimProj(),
      "-",
      "k4",
      "-",
      sprintf("%05d", taskid)
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
  if (is.null(seed)) {
    seed <- .SimSeed(
      taskid = taskid,
      repid = repid
    )
  }
  suffix <- .SimSuffix(
    taskid = taskid,
    repid = repid
  )
  if (data) {
    SimGenDataK4(
      taskid = taskid,
      repid = repid,
      output_folder = output_folder,
      seed = seed,
      suffix = suffix,
      overwrite = overwrite,
      integrity = integrity
    )
  }
  if (mplus) {
    SimFitMplusK4(
      taskid = taskid,
      repid = repid,
      output_folder = output_folder,
      seed = seed,
      suffix = suffix,
      overwrite = overwrite,
      integrity = integrity,
      chains = chains,
      iter = iter,
      fscores = fscores,
      plot = plot
    )
    SimFitMplusK4Diagnostics(
      taskid = taskid,
      repid = repid,
      output_folder = output_folder,
      seed = seed,
      suffix = suffix,
      overwrite = overwrite,
      integrity = integrity
    )
    SimFitMplusK4Priors(
      taskid = taskid,
      repid = repid,
      output_folder = output_folder,
      seed = seed,
      suffix = suffix,
      overwrite = overwrite,
      integrity = integrity,
      chains = chains,
      iter = iter,
      fscores = fscores,
      plot = plot
    )
    SimFitMplusK4PriorDiag(
      taskid = taskid,
      repid = repid,
      output_folder = output_folder,
      seed = seed,
      suffix = suffix,
      overwrite = overwrite,
      integrity = integrity
    )
  }
  if (metavar || naive) {
    SimFitDTVARK4(
      taskid = taskid,
      repid = repid,
      output_folder = output_folder,
      seed = seed,
      suffix = suffix,
      overwrite = overwrite,
      integrity = integrity
    )
  }
  if (metavar) {
    SimFitMetaVARK4(
      taskid = taskid,
      repid = repid,
      output_folder = output_folder,
      seed = seed,
      suffix = suffix,
      overwrite = overwrite,
      integrity = integrity
    )
  }
  if (naive) {
    message(
      "No naive for k = 4."
    )
  }
  invisible(NULL)
}
