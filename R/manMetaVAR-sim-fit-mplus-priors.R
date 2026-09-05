#' Simulation Replication - FitMplus (User Defined Priors)
#'
#' @details This function is executed via the `Sim` function.
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
SimFitMplusPriors <- function(taskid,
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
    output_type = "data",
    output_folder = output_folder,
    suffix = suffix
  )
  fn_output <- SimFN(
    output_type = "fit-mplus-priors",
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
        FitMplus(
          data = .SimReadUpstream(fn_input),
          chains = chains,
          iter = iter,
          fscores = fscores,
          plot = plot,
          default_priors = FALSE,
          wd = output_folder,
          mplus_bin = "mplus",
          ncores = NULL,
          seed = seed
        )
      }
    )
  }
}
