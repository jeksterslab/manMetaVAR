#' Simulation Replication - FitMLVAR
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
SimFitMLVAR <- function(taskid,
                        repid,
                        output_folder,
                        seed,
                        suffix,
                        overwrite,
                        integrity) {
  # Do not include default arguments here.
  # Do not run on its own. Use the `Sim` function.
  fn_input <- SimFN(
    output_type = "data",
    output_folder = output_folder,
    suffix = suffix
  )
  fn_output <- SimFN(
    output_type = "fit-ml-var-mx",
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
          object = FitMLVAR(
            data = readRDS(fn_input)
          ),
          file = con
        )
        close(con)
        .SimChMod(fn_output)
      },
      error = function(cond) {
        message(paste("error:", "SimFitMLVAR"))
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
        message(paste("error:", "SimFitMLVAR"))
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
