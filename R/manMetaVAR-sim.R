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
Sim <- function(taskid,
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
  # All arguments should be set in `sim/sim-args.R`.
  .TaskParameters(taskid = taskid)
  output_folder <- file.path(
    output_folder,
    paste0(
      SimProj(),
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
    SimGenData(
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
    SimFitMplus(
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
    SimFitMplusDiagnostics(
      taskid = taskid,
      repid = repid,
      output_folder = output_folder,
      seed = seed,
      suffix = suffix,
      overwrite = overwrite,
      integrity = integrity
    )
    SimFitMplusPriors(
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
    SimFitMplusPriorsDiagnostics(
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
    SimFitDTVAR(
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
    SimFitMetaVAR(
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
    SimFitNaive(
      taskid = taskid,
      repid = repid,
      output_folder = output_folder,
      seed = seed,
      suffix = suffix,
      overwrite = overwrite,
      integrity = integrity
    )
  }
  invisible(NULL)
}
