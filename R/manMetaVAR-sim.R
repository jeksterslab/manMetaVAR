#' Simulation Replication
#'
#' @author Ivan Jacob Agaloos Pesigan
#'
#' @return The output is saved as an external file in `output_folder`.
#'
#' @inheritParams Template
#' @export
#' @keywords manMetaVAR simulation
Sim <- function(taskid,
                repid,
                output_folder,
                overwrite,
                integrity,
                seed,
                n_chains,
                n_adapt,
                n_iter,
                thin,
                ess_crit,
                max_iter,
                run_jags) {
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
  SimGenData(
    taskid = taskid,
    repid = repid,
    output_folder = output_folder,
    seed = seed,
    suffix = suffix,
    overwrite = overwrite,
    integrity = integrity
  )
  try(
    SimFitDTVAR(
      taskid = taskid,
      repid = repid,
      output_folder = output_folder,
      seed = seed,
      suffix = suffix,
      overwrite = overwrite,
      integrity = integrity
    )
  )
  try(
    SimFitMetaVAR(
      taskid = taskid,
      repid = repid,
      output_folder = output_folder,
      seed = seed,
      suffix = suffix,
      overwrite = overwrite,
      integrity = integrity
    )
  )
  try(
    SimFitMLVAR(
      taskid = taskid,
      repid = repid,
      output_folder = output_folder,
      seed = seed,
      suffix = suffix,
      overwrite = overwrite,
      integrity = integrity
    )
  )
  if (run_jags) {
    try(
      SimFitJAGS(
        taskid = taskid,
        repid = repid,
        output_folder = output_folder,
        seed = seed,
        suffix = suffix,
        overwrite = overwrite,
        integrity = integrity,
        n_chains = n_chains,
        n_adapt = n_adapt,
        n_iter = n_iter,
        thin = thin,
        ess_crit = ess_crit,
        max_iter = max_iter
      )
    )
  }
}
