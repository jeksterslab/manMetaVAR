#' Simulation Replication - FitMplusK4
#'
#' @details This function is executed via the `SimK4` function.
#'
#' @author Ivan Jacob Agaloos Pesigan
#'
#' @return The output is saved as an external file in `output_folder`.
#'
#' @inheritParams Template
#'
#' @importFrom stats coef vcov
#' @export
#' @keywords manMetaVAR fit simulation
SimFitMplusK4 <- function(taskid,
                          repid,
                          output_folder,
                          seed,
                          suffix,
                          overwrite,
                          integrity,
                          chains,
                          iter,
                          fscores,
                          plot) {
  # Do not include default arguments here.
  # Do not run on its own. Use the `Sim` function.
  fn_input <- SimFN(
    output_type = "data-k4",
    output_folder = output_folder,
    suffix = suffix
  )
  fn_output <- SimFN(
    output_type = "fit-mplus-k4",
    output_folder = output_folder,
    suffix = suffix
  )
  run <- .SimFitCheck(
    fn = fn_output,
    overwrite = overwrite,
    integrity = integrity
  )
  if (run) {
    set.seed(seed)
    .SimRunFit(
      fn = fn_output,
      object = {
        .SimRequireExecutable("mplus")
        FitMplusK4(
          data = .SimReadUpstream(fn_input),
          chains = chains,
          iter = iter,
          fscores = fscores,
          plot = plot,
          default_priors = TRUE,
          wd = output_folder,
          mplus_bin = "mplus",
          ncores = NULL,
          seed = seed
        )
      }
    )
  }
}
