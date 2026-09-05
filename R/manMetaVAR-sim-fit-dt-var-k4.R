#' Simulation Replication - FitDTVARK4
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
SimFitDTVARK4 <- function(taskid,
                          repid,
                          output_folder,
                          seed,
                          suffix,
                          overwrite,
                          integrity) {
  # Do not include default arguments here.
  # Do not run on its own. Use the `Sim` function.
  fn_input <- SimFN(
    output_type = "data-k4",
    output_folder = output_folder,
    suffix = suffix
  )
  fn_output <- SimFN(
    output_type = "fit-dt-var-mx-k4",
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
      object = FitDTVARK4(
        data = .SimReadUpstream(fn_input),
        ncores = NULL,
        seed = seed
      )
    )
  }
}
