#' Simulation Attempt File Name
#'
#' Generates the file name used to store a simulation attempt record.
#'
#' @author Ivan Jacob Agaloos Pesigan
#'
#' @return Returns a character string.
#'
#' @param fn Complete file name and path of the simulation output file.
#'
#' @family Simulation Helper Functions
#' @keywords simTools internal
#' @noRd
.SimAttemptFN <- function(fn) {
  paste0(fn, ".attempt")
}
