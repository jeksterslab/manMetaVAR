#' Check Replication - FitDTVARK4
#'
#' @details This function is executed via the `CheckK4` function.
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
CheckFitDTVARK4 <- function(taskid,
                            repid,
                            output_folder,
                            suffix) {
  # Do not include default arguments here.
  # Do not run on its own. Use the `Check` function.
  fn_input <- SimFN(
    output_type = "fit-dt-var-mx-k4",
    output_folder = output_folder,
    suffix = suffix
  )
  tryCatch(
    {
      out <- converged(
        readRDS(fn_input)$output,
        prop = TRUE
      )
      if (out < 1) {
        message(paste("error:", "CheckFitDTVARK4"))
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
      message(paste("error:", "CheckFitDTVARK4"))
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
      message(paste("error:", "CheckFitDTVARK4"))
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
