#' Write Simulation Attempt Record
#'
#' Writes a simulation attempt record to a sidecar file using an atomic
#' temporary-file-and-rename workflow.
#'
#' Dependencies: `.SimAttemptFN()` and `.SimChMod()`.
#'
#' @author Ivan Jacob Agaloos Pesigan
#'
#' @return Invisibly returns the attempt record.
#'
#' @param fn Complete file name and path of the simulation output file.
#' @param failure_class Character string.
#'   Simulation failure class.
#' @param message Character string.
#'   Failure message.
#' @param condition_class Character vector.
#'   Condition classes associated with the failure.
#' @param estimation_attempted Logical.
#'   Whether estimation was attempted.
#' @param elapsed_seconds Numeric.
#'   Elapsed estimation time in seconds.
#'
#' @family Simulation Helper Functions
#' @keywords simTools internal
#' @noRd
.SimWriteAttempt <- function(fn,
                             failure_class,
                             message,
                             condition_class = NA_character_,
                             estimation_attempted = FALSE,
                             elapsed_seconds = NA_real_) {
  fn_attempt <- .SimAttemptFN(fn)
  record <- list(
    failure_class = as.character(failure_class)[1],
    message = as.character(message)[1],
    condition_class = as.character(condition_class),
    estimation_attempted = isTRUE(estimation_attempted),
    elapsed_seconds = as.numeric(elapsed_seconds)[1],
    recorded_at = format(
      Sys.time(),
      tz = "UTC",
      usetz = TRUE
    )
  )
  fn_tmp <- tempfile(
    pattern = paste0(
      ".",
      basename(fn_attempt),
      "-"
    ),
    tmpdir = dirname(fn_attempt)
  )
  on.exit(
    unlink(fn_tmp),
    add = TRUE
  )
  saveRDS(
    object = record,
    file = fn_tmp,
    compress = FALSE
  )
  if (file.exists(fn_attempt)) {
    unlink(fn_attempt)
  }
  renamed <- file.rename(
    from = fn_tmp,
    to = fn_attempt
  )
  if (!isTRUE(renamed)) {
    stop(
      paste0(
        "Could not persist simulation attempt record to '",
        fn_attempt,
        "'."
      ),
      call. = FALSE
    )
  }
  .SimChMod(fn_attempt)
  invisible(record)
}
