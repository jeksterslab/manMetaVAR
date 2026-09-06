#' Classify a Simulation Failure Condition
#'
#' Maps a condition to the simulation failure classes used by the fit-attempt
#' workflow and indicates whether estimation was attempted.
#'
#' @author Ivan Jacob Agaloos Pesigan
#'
#' @return Returns a list with elements `failure_class` and
#'   `estimation_attempted`.
#'
#' @param condition A condition object.
#'
#' @family Simulation Helper Functions
#' @keywords simTools internal
#' @noRd
.SimClassifyFailure <- function(condition) {
  if (inherits(condition, "simTools_upstream_failure")) {
    return(
      list(
        failure_class = "upstream_failure",
        estimation_attempted = FALSE
      )
    )
  }
  if (inherits(condition, "simTools_infrastructure_error")) {
    return(
      list(
        failure_class = "infrastructure_error",
        estimation_attempted = FALSE
      )
    )
  }
  list(
    failure_class = "estimation_error",
    estimation_attempted = TRUE
  )
}
