#' Require an Executable for a Simulation Step
#'
#' Checks whether an executable is available on `PATH` and signals a generic
#' simulation infrastructure failure when it is unavailable.
#'
#' Dependency: `.SimStopFailure()`.
#'
#' @author Ivan Jacob Agaloos Pesigan
#'
#' @return Invisibly returns the executable path.
#'
#' @param command Character string.
#'   Name of the required executable.
#' @param condition_class Character vector.
#'   Optional additional project-specific condition classes.
#'
#' @family Simulation Helper Functions
#' @keywords simTools internal
#' @noRd
.SimRequireExecutable <- function(command,
                                  condition_class = character()) {
  path <- Sys.which(command)
  if (length(path) != 1L || !nzchar(path)) {
    .SimStopFailure(
      message = paste0(
        "Required executable is not available on PATH: '",
        command,
        "'."
      ),
      failure_class = "infrastructure_error",
      condition_class = condition_class
    )
  }
  invisible(path)
}
