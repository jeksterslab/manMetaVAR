#' Summary for the Four-Variable Simulation
#'
#' @author Ivan Jacob Agaloos Pesigan
#'
#' @param mplus Logical. If `TRUE`, summarize the default- and user-prior
#'   four-variable DSEM fits and their diagnostics.
#' @param metavar_normal Logical. If `TRUE`, summarize the four-variable
#'   metaVAR fits using normal confidence intervals.
#' @param metavar_robust Logical. If `TRUE`, summarize the four-variable
#'   metaVAR fits using robust confidence intervals.
#' @param naive Logical. Retained for consistency with [SimK4()]. The
#'   four-variable simulation does not currently fit a naive model.
#'
#' @return The output is saved as external files in `output_folder`.
#'
#' @inheritParams Template
#' @export
#' @keywords manMetaVAR summary simulation
SumK4 <- function(taskid,
                  reps,
                  output_folder,
                  overwrite,
                  integrity,
                  naive,
                  metavar_normal,
                  metavar_robust,
                  mplus,
                  ncores) {
  .TaskParameters(taskid = taskid)
  reps <- .SumValidateReps(reps)
  output_folder <- file.path(
    output_folder,
    paste0(
      SimProj(),
      "-",
      "k4",
      "-",
      sprintf("%05d", taskid)
    )
  )
  if (!file.exists(output_folder)) {
    dir.create(
      path = output_folder,
      showWarnings = FALSE,
      recursive = TRUE
    )
    .SimChMod(output_folder)
  }
  # A method can legitimately have too few admissible replications during a
  # pilot run. Record that condition as a warning so that the remaining
  # methods and diagnostics are still attempted. Other errors are collected
  # and raised after all requested summaries for this task have been attempted.
  failures <- character(0L)
  insufficient_prefix <-
    "At least two admissible replications are required for "

  attempt <- function(label, expr) {
    tryCatch(
      {
        force(expr)
        invisible(TRUE)
      },
      error = function(e) {
        msg <- conditionMessage(e)
        if (startsWith(msg, insufficient_prefix)) {
          warning(
            paste0(
              label,
              " could not be summarized for taskid = ",
              taskid,
              ": ",
              msg
            ),
            call. = FALSE
          )
          return(invisible(FALSE))
        }
        failures <<- c(
          failures,
          paste0(label, ": ", msg)
        )
        warning(
          paste0(
            label,
            " failed for taskid = ",
            taskid,
            ": ",
            msg
          ),
          call. = FALSE
        )
        invisible(FALSE)
      }
    )
  }

  if (mplus) {
    attempt(
      "Mplus k = 4 default",
      SumFitMplusK4(
        taskid,
        reps,
        output_folder,
        overwrite,
        integrity,
        ncores
      )
    )
    attempt(
      "Mplus k = 4 default diagnostics",
      SumFitMplusK4Diagnostics(
        taskid,
        reps,
        output_folder,
        overwrite,
        integrity,
        ncores
      )
    )
    attempt(
      "Mplus k = 4 priors",
      SumFitMplusK4Priors(
        taskid,
        reps,
        output_folder,
        overwrite,
        integrity,
        ncores
      )
    )
    attempt(
      "Mplus k = 4 priors diagnostics",
      SumFitMplusK4PriorsDiagnostics(
        taskid,
        reps,
        output_folder,
        overwrite,
        integrity,
        ncores
      )
    )
  }
  if (metavar_normal) {
    attempt(
      "MetaVAR k = 4 normal",
      SumFitMetaVARK4Normal(
        taskid,
        reps,
        output_folder,
        overwrite,
        integrity,
        ncores
      )
    )
  }
  if (metavar_robust) {
    attempt(
      "MetaVAR k = 4 robust",
      SumFitMetaVARK4Robust(
        taskid,
        reps,
        output_folder,
        overwrite,
        integrity,
        ncores
      )
    )
  }
  if (naive) {
    message("No naive summary for k = 4.")
  }
  attempt(
    "Simulation diagnostics k = 4",
    .SumDiagnosticsCore(
      taskid = taskid,
      reps = reps,
      output_folder = output_folder,
      overwrite = overwrite,
      integrity = integrity,
      naive = naive,
      metavar = metavar_normal || metavar_robust,
      mplus = mplus,
      variance_tol = 1e-6,
      eigen_tol = 1e-8,
      k4 = TRUE
    )
  )

  if (length(failures) > 0L) {
    stop(
      paste0(
        "One or more k = 4 summaries failed for taskid = ",
        taskid,
        ":\n- ",
        paste(failures, collapse = "\n- ")
      ),
      call. = FALSE
    )
  }
  invisible(NULL)
}
