#' Gate a Simulation Status Manifest
#'
#' Stop when a simulation status manifest contains failures that indicate
#' missing, unreadable, or otherwise technically invalid simulation artifacts.
#' Statistical estimation outcomes such as nonconvergence, inadmissibility,
#' estimation errors, and upstream estimation failures are retained as valid
#' simulation outcomes and do not trigger the gate.
#'
#' @author Ivan Jacob Agaloos Pesigan
#'
#' @param status A simulation status manifest returned by
#'   [`.CheckStatusManifest()`].
#'
#' @return `status`, invisibly, when no repair-required failures are present.
#'
#' @keywords manMetaVAR internal simulation check
#' @noRd
.CheckStatusGate <- function(status) {
  required_columns <- c(
    "taskid",
    "repid",
    "method",
    "output_type",
    "failure_class"
  )
  missing_columns <- setdiff(
    required_columns,
    names(status)
  )
  if (length(missing_columns) > 0L) {
    stop(
      paste0(
        "Simulation status manifest is missing required columns: ",
        paste(missing_columns, collapse = ", "),
        "."
      ),
      call. = FALSE
    )
  }

  repair_required <- is.na(status$failure_class) |
    status$failure_class %in% c(
      "missing_file",
      "unreadable_file",
      "infrastructure_error",
      "check_error"
    )

  if (any(repair_required)) {
    failed <- status[repair_required, , drop = FALSE]
    details <- apply(
      failed,
      MARGIN = 1L,
      FUN = function(x) {
        paste0(
          "taskid=", x[["taskid"]],
          ", repid=", x[["repid"]],
          ", method=", x[["method"]],
          ", output_type=", x[["output_type"]],
          ", failure_class=", x[["failure_class"]]
        )
      }
    )
    stop(
      paste0(
        "Simulation check found repair-required failures:\n",
        paste(details, collapse = "\n")
      ),
      call. = FALSE
    )
  }

  invisible(status)
}
