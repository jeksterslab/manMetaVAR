#' Read an Upstream Simulation Artifact
#'
#' Reads an upstream simulation artifact while distinguishing a recorded
#' upstream estimation failure from a missing or unreadable infrastructure
#' artifact.
#'
#' Dependencies: `.SimReadAttempt()` and `.SimStopFailure()`.
#'
#' @author Ivan Jacob Agaloos Pesigan
#'
#' @return Returns the object stored in `fn`.
#'
#' @param fn Complete file name and path of the upstream simulation file.
#' @param condition_class Character vector.
#'   Optional additional project-specific condition classes.
#'
#' @family Simulation Helper Functions
#' @keywords simTools internal
#' @noRd
.SimReadUpstream <- function(fn,
                             condition_class = character()) {
  if (!file.exists(fn)) {
    attempt <- .SimReadAttempt(fn)
    if (inherits(attempt, "error")) {
      .SimStopFailure(
        message = paste0(
          "Upstream simulation artifact is missing and its attempt record ",
          "is unreadable: ",
          conditionMessage(attempt)
        ),
        failure_class = "infrastructure_error",
        condition_class = condition_class
      )
    }
    if (!is.null(attempt)) {
      failure_class <- as.character(attempt$failure_class)[1]
      if (failure_class %in% c(
        "estimation_error",
        "upstream_failure"
      )) {
        .SimStopFailure(
          message = paste0(
            "Upstream simulation step failed (",
            failure_class,
            "): ",
            attempt$message
          ),
          failure_class = "upstream_failure",
          condition_class = condition_class
        )
      }
      .SimStopFailure(
        message = paste0(
          "Upstream simulation artifact is unavailable because of ",
          failure_class,
          ": ",
          attempt$message
        ),
        failure_class = "infrastructure_error",
        condition_class = condition_class
      )
    }
    .SimStopFailure(
      message = paste0(
        "Required upstream simulation artifact does not exist: '",
        fn,
        "'."
      ),
      failure_class = "infrastructure_error",
      condition_class = condition_class
    )
  }

  tryCatch(
    readRDS(fn),
    error = function(e) {
      .SimStopFailure(
        message = paste0(
          "Required upstream simulation artifact is unreadable: '",
          fn,
          "'. ",
          conditionMessage(e)
        ),
        failure_class = "infrastructure_error",
        condition_class = condition_class
      )
    }
  )
}
