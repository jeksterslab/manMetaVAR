#' Check Replication - FitNaive
#'
#' @details This function is executed via the `Check` function.
#'
#' @author Ivan Jacob Agaloos Pesigan
#'
#' @return The output is saved as an external file in `output_folder`.
#'
#' @inheritParams Template
#'
#' @importFrom stats coef vcov
#' @export
#' @keywords manMetaVAR check simulation
CheckFitNaive <- function(taskid,
                          repid,
                          output_folder,
                          suffix) {
  # Do not include default arguments here.
  # Do not run on its own. Use the `Check` function.
  fn_input <- SimFN(
    output_type = "fit-dt-var-mx",
    output_folder = output_folder,
    suffix = suffix
  )
  tryCatch(
    {
      out <- lavaan::lavInspect(
        object = readRDS(fn_input)$output,
        what = "converged"
      )
      if (isFALSE(out)) {
        message(paste("error:", "CheckFitNaive"))
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
        cat(
          paste(
            "\nConvergence",
            out,
            "\n"
          )
        )
      }
    },
    error = function(cond) {
      message(paste("error:", "CheckFitNaive"))
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
      message(paste("error:", "CheckFitNaive"))
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
