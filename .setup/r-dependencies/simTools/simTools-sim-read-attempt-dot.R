#' Read Simulation Attempt Record
#'
#' Reads the sidecar attempt record associated with a simulation output file.
#' Returns `NULL` when no attempt record exists and returns the error condition
#' itself when the attempt record exists but cannot be read.
#'
#' Dependency: `.SimAttemptFN()`.
#'
#' @author Ivan Jacob Agaloos Pesigan
#'
#' @return Returns `NULL`, a simulation attempt record, or an error condition.
#'
#' @param fn Complete file name and path of the simulation output file.
#'
#' @family Simulation Helper Functions
#' @keywords simTools internal
#' @noRd
.SimReadAttempt <- function(fn) {
  fn_attempt <- .SimAttemptFN(fn)
  if (!file.exists(fn_attempt)) {
    return(NULL)
  }
  tryCatch(
    readRDS(fn_attempt),
    error = function(e) e
  )
}
