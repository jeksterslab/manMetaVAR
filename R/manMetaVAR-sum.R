#' Summary
#'
#' @author Ivan Jacob Agaloos Pesigan
#'
#' @param mplus Logical.
#'   If `mplus = TRUE`, summarize the DSEM model.
#' @param metavar_normal Logical.
#'   If `metavar_normal = TRUE`, summarize metaVAR model using
#'   normal confidence intervals.
#' @param metavar_robust Logical.
#'   If `metavar_robust = TRUE`, summarize metaVAR model using
#'   robust (sandwich) confidence intervals.
#' @param naive Logical.
#'   If `naive = TRUE`, summarize naive estimates.
#'
#' @return The output is saved as an external file in `output_folder`.
#'
#' @inheritParams Template
#' @export
#' @keywords manMetaVAR summary simulation
Sum <- function(taskid,
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
  # methods and tasks are still attempted. Other errors are collected and
  # raised after all requested summaries for this task have been attempted.
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
      "Mplus default",
      SumFitMplus(
        taskid,
        reps,
        output_folder,
        overwrite,
        integrity,
        ncores
      )
    )
    attempt(
      "Mplus default diagnostics",
      SumFitMplusDiagnostics(
        taskid,
        reps,
        output_folder,
        overwrite,
        integrity,
        ncores
      )
    )
    attempt(
      "Mplus priors",
      SumFitMplusPriors(
        taskid,
        reps,
        output_folder,
        overwrite,
        integrity,
        ncores
      )
    )
    attempt(
      "Mplus priors diagnostics",
      SumFitMplusPriorsDiagnostics(
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
      "MetaVAR normal",
      SumFitMetaVARNormal(
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
      "MetaVAR robust",
      SumFitMetaVARRobust(
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
    attempt(
      "Naive",
      SumFitNaive(
        taskid,
        reps,
        output_folder,
        overwrite,
        integrity,
        ncores
      )
    )
  }
  attempt(
    "Simulation diagnostics",
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
      k4 = FALSE
    )
  )

  if (length(failures) > 0L) {
    stop(
      paste0(
        "One or more summaries failed for taskid = ",
        taskid,
        ":\n- ",
        paste(failures, collapse = "\n- ")
      ),
      call. = FALSE
    )
  }
  invisible(NULL)
}
