#' Check Replication - FitMetaVAR
#'
#' @details This function is executed via the `Check` function.
#'
#' @author Anonymous
#'
#' @return The output is saved as an external file in `output_folder`.
#'
#' @inheritParams Template
#'
#' @export
#' @keywords manMetaVAR check simulation
CheckFitMetaVAR <- function(taskid,
                            repid,
                            output_folder,
                            suffix) {
  # Do not include default arguments here.
  # Do not run on its own. Use the `Check` function.
  fn_input <- SimFN(
    output_type = "fit-meta-var-mx",
    output_folder = output_folder,
    suffix = suffix
  )
  tryCatch(
    {
      out <- metaDyn:::.CheckStatusCode(
        model = readRDS(fn_input)$output$output
      )
      if (out > 0) {
        message(paste("error:", "CheckFitMetaVAR"))
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
      message(paste("error:", "CheckFitMetaVAR"))
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
      message(paste("error:", "CheckFitMetaVAR"))
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
