#' Sanity Check to Determine Decision to Run Simulation Fit
#'
#' Extends `.SimCheck()` by honoring a recorded genuine estimation failure.
#' A recorded `estimation_error` is treated as a completed simulation outcome
#' when `overwrite = FALSE`, whereas other missing or failed artifacts remain
#' eligible to be rerun.
#'
#' Dependencies: `.SimCheck()` and `.SimReadAttempt()`.
#'
#' @author Ivan Jacob Agaloos Pesigan
#'
#' @return Returns logical.
#'
#' @param fn Complete file name and path of the simulation output file.
#' @param overwrite Logical.
#'   If `overwrite = TRUE`, return `TRUE`.
#' @param integrity Logical.
#'   If `integrity = TRUE`, check the integrity of an existing simulation
#'   output file when `overwrite = FALSE`.
#'
#' @family Simulation Helper Functions
#' @keywords simTools internal
#' @noRd
.SimFitCheck <- function(fn,
                         overwrite,
                         integrity) {
  if (overwrite) {
    return(TRUE)
  }
  if (file.exists(fn)) {
    return(
      .SimCheck(
        fn = fn,
        overwrite = FALSE,
        integrity = integrity
      )
    )
  }

  attempt <- .SimReadAttempt(fn)
  if (is.null(attempt)) {
    return(TRUE)
  }
  if (inherits(attempt, "error")) {
    return(TRUE)
  }
  failure_class <- as.character(attempt$failure_class)[1]
  if (identical(
    failure_class,
    "estimation_error"
  )) {
    return(FALSE)
  }
  TRUE
}
