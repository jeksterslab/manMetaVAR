#' Simulation Replication - FitMplus
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
SimFitMplus <- function(taskid,
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
    output_type = "fit-mplus",
    output_folder = output_folder,
    suffix = suffix
  )
  run <- .SimCheck(
    fn = fn_output,
    overwrite = overwrite,
    integrity = integrity
  )
  if (run) {
    tryCatch(
      {
        set.seed(seed)
        con <- file(fn_output)
        saveRDS(
          object = FitMplus(
            data = readRDS(fn_input),
            chains = chains,
            iter = iter,
            fscores = fscores,
            plot = plot,
            wd = output_folder,
            mplus_bin = "mplus",
            ncores = NULL,
            seed = seed
          ),
          file = con
        )
        close(con)
        .SimChMod(fn_output)
      },
      error = function(cond) {
        message(paste("error:", "SimFitMplus"))
        message("Here's the original error message:")
        message(conditionMessage(cond))
        cat(
          paste(
            "check",
            "taskid:",
            taskid,
            "repid:",
            repid,
            "\n"
          )
        )
      },
      warning = function(cond) {
        message(paste("error:", "SimFitMplus"))
        message("Here's the original warning message:")
        message(conditionMessage(cond))
        cat(
          paste(
            "check",
            "taskid:",
            taskid,
            "repid:",
            repid,
            "\n"
          )
        )
      }
    )
  }
}
