#' Check Replication - FitMetaVARK4
#'
#' @details This function is executed via the `CheckK4` function.
#'
#' @author Ivan Jacob Agaloos Pesigan
#'
#' @return The output is saved as an external file in `output_folder`.
#'
#' @inheritParams Template
#'
#' @export
#' @keywords manMetaVAR check simulation
CheckFitMetaVARK4 <- function(taskid,
                              repid,
                              output_folder,
                              suffix) {
  # Do not include default arguments here.
  # Do not run on its own. Use the `Check` function.
  fn_input <- SimFN(
    output_type = "fit-meta-var-mx-k4",
    output_folder = output_folder,
    suffix = suffix
  )
  tryCatch(
    {
      out <- metaDyn:::.CheckStatusCode(
        model = readRDS(fn_input)$output$output
      )
      if (out > 0) {
        message(paste("error:", "CheckFitMetaVARK4"))
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
            "\nStatus code:",
            out,
            "\n"
          )
        )
      }
    },
    error = function(cond) {
      message(paste("error:", "CheckFitMetaVARK4"))
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
      message(paste("error:", "CheckFitMetaVARK4"))
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
