#' Stop with a Simulation Failure Condition
#'
#' Creates and signals a project-agnostic simulation failure condition.
#' The condition inherits from `simTools_failure` and from a class generated
#' from `failure_class`, for example, `simTools_infrastructure_error`.
#' Projects may supply additional condition classes using `condition_class`.
#'
#' @author Ivan Jacob Agaloos Pesigan
#'
#' @return Does not return because a condition is signaled.
#'
#' @param message Character string.
#'   Error message.
#' @param failure_class Character string.
#'   Simulation failure class without the `simTools_` prefix.
#' @param condition_class Character vector.
#'   Optional additional project-specific condition classes.
#'
#' @family Simulation Helper Functions
#' @keywords simTools internal
#' @noRd
.SimStopFailure <- function(message,
                            failure_class,
                            condition_class = character()) {
  failure_class <- as.character(failure_class)[1]
  if (is.na(failure_class) || !nzchar(failure_class)) {
    stop(
      "`failure_class` must be a non-empty character string.",
      call. = FALSE
    )
  }

  condition_class <- as.character(condition_class)
  condition_class <- condition_class[
    !is.na(condition_class) & nzchar(condition_class)
  ]

  condition <- simpleError(message)
  class(condition) <- unique(c(
    condition_class,
    paste0("simTools_", failure_class),
    "simTools_failure",
    base::class(condition)
  ))
  stop(condition)
}
