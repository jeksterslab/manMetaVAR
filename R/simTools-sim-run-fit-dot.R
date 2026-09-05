#' Run and Persist a Simulation Fit
#'
#' Evaluates a simulation fitting expression and distinguishes genuine
#' estimation failures from upstream and infrastructure failures. Successful
#' fits are written using a temporary-file-and-rename workflow so a failed
#' estimation cannot leave a partial simulation artifact at `fn`.
#'
#' Dependencies: `.SimAttemptFN()`, `.SimClassifyFailure()`,
#' `.SimWriteAttempt()`, and `.SimChMod()`.
#'
#' @author Ivan Jacob Agaloos Pesigan
#'
#' @return Invisibly returns `TRUE` when a fit is successfully persisted and
#'   `FALSE` when an attempt record is written instead.
#'
#' @param fn Complete file name and path of the simulation output file.
#' @param object Expression yielding the fitted simulation object.
#'
#' @family Simulation Helper Functions
#' @keywords simTools internal
#' @noRd
.SimRunFit <- function(fn,
                       object) {
  fn_attempt <- .SimAttemptFN(fn)

  if (file.exists(fn)) {
    unlink(fn)
  }
  if (file.exists(fn_attempt)) {
    unlink(fn_attempt)
  }

  started_at <- proc.time()[["elapsed"]]
  evaluated <- tryCatch(
    list(
      ok = TRUE,
      object = force(object)
    ),
    error = function(e) {
      list(
        ok = FALSE,
        error = e
      )
    }
  )
  elapsed_seconds <- proc.time()[["elapsed"]] - started_at

  if (!evaluated$ok) {
    error <- evaluated$error
    classification <- .SimClassifyFailure(error)
    .SimWriteAttempt(
      fn = fn,
      failure_class = classification$failure_class,
      message = conditionMessage(error),
      condition_class = class(error),
      estimation_attempted = classification$estimation_attempted,
      elapsed_seconds = if (classification$estimation_attempted) {
        elapsed_seconds
      } else {
        NA_real_
      }
    )
    message(
      paste0(
        basename(fn),
        ": ",
        classification$failure_class,
        " - ",
        conditionMessage(error)
      )
    )
    return(invisible(FALSE))
  }

  fn_tmp <- tempfile(
    pattern = paste0(
      ".",
      basename(fn),
      "-"
    ),
    tmpdir = dirname(fn)
  )
  on.exit(
    unlink(fn_tmp),
    add = TRUE
  )

  save_error <- tryCatch(
    {
      saveRDS(
        object = evaluated$object,
        file = fn_tmp,
        compress = FALSE
      )
      NULL
    },
    error = function(e) e
  )
  if (inherits(save_error, "error")) {
    .SimWriteAttempt(
      fn = fn,
      failure_class = "infrastructure_error",
      message = paste0(
        "Estimation completed, but the simulation fit could not be saved: ",
        conditionMessage(save_error)
      ),
      condition_class = class(save_error),
      estimation_attempted = TRUE,
      elapsed_seconds = elapsed_seconds
    )
    return(invisible(FALSE))
  }

  renamed <- file.rename(
    from = fn_tmp,
    to = fn
  )
  if (!isTRUE(renamed)) {
    .SimWriteAttempt(
      fn = fn,
      failure_class = "infrastructure_error",
      message = paste0(
        "Estimation completed, but the temporary fit could not be moved to '",
        fn,
        "'."
      ),
      condition_class = "file.rename",
      estimation_attempted = TRUE,
      elapsed_seconds = elapsed_seconds
    )
    return(invisible(FALSE))
  }

  .SimChMod(fn)
  invisible(TRUE)
}
