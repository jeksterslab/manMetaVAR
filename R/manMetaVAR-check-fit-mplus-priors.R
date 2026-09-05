#' Check Replication - FitMplus (User Defined Priors)
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
CheckFitMplusPriors <- function(taskid,
                                repid,
                                output_folder,
                                suffix) {
  # Do not include default arguments here.
  # Do not run on its own. Use the `Check` function.
  fn_input <- SimFN(
    output_type = "fit-mplus-priors",
    output_folder = output_folder,
    suffix = suffix
  )
  tryCatch(
    {
      out <- grep(
        pattern = "THE MODEL ESTIMATION TERMINATED NORMALLY",
        x = readRDS(fn_input)$output$output,
        value = TRUE
      )
      if (length(out) == 0L) {
        message(paste("error:", "CheckFitMplusPriors"))
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
          "\nEstimation error\n"
        )
      }
    },
    error = function(cond) {
      message(paste("error:", "CheckFitMplusPriors"))
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
      message(paste("error:", "CheckFitMplusPriors"))
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
