#' Simulation Replication - FitMetaVARMx
#'
#' @details This function is executed via the `Sim` function.
#'
#' @author Ivan Jacob Agaloos Pesigan
#'
#' @return The output is saved as an external file in `output_folder`.
#'
#' @inheritParams Template
#' @export
#' @keywords manMetaVAR fit simulation
SimFitMetaVARMx <- function(taskid,
                            repid,
                            output_folder,
                            seed,
                            suffix,
                            overwrite,
                            integrity) {
  # Do not include default arguments here.
  # Do not run on its own. Use the `Sim` function.
  fn_input <- SimFN(
    output_type = "fit-dt-var-mx",
    output_folder = output_folder,
    suffix = suffix
  )
  fn_output <- SimFN(
    output_type = "fit-meta-var-mx",
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
          object = FitMetaVARMx(
            fit = readRDS(fn_input)
          ),
          file = con
        )
        close(con)
        .SimChMod(fn_output)
      },
      error = function(cond) {
        message(paste("error:", "SimFitMetaVARMx"))
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
        message(paste("error:", "SimFitMetaVARMx"))
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
