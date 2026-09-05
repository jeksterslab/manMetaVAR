#' Check One Simulation-Output Status Row
#'
#' Classifies one expected simulation artifact for a single task, replication,
#' method, and stage. The function distinguishes successful fits and genuine
#' estimation outcomes from failures that indicate missing, unreadable, or
#' otherwise technically invalid simulation artifacts.
#'
#' A missing main fit file is reconciled with its simulation-attempt sidecar
#' when available. Recorded `estimation_error`, `upstream_failure`, and
#' `infrastructure_error` outcomes are therefore distinguished from an
#' unexplained `missing_file`. Readable fit objects are subsequently evaluated
#' for convergence and admissibility.
#'
#' @author Ivan Jacob Agaloos Pesigan
#'
#' @inheritParams Template
#' @param method Character string identifying the estimation method represented
#'   by the artifact.
#' @param stage Character string identifying the estimation stage.
#' @param k Positive integer giving the number of modeled variables.
#'
#' @return A one-row data frame containing artifact availability, attempt-record
#'   information, convergence and admissibility indicators, elapsed time, and
#'   the final `status` and `failure_class`. Failure classes include `ok`,
#'   `estimation_error`, `upstream_failure`, `nonconvergence`, `inadmissible`,
#'   `missing_file`, `unreadable_file`, `infrastructure_error`, and
#'   `check_error`.
#'
#' @keywords manMetaVAR internal simulation check
#' @noRd
.CheckStatusRow <- function(taskid,
                            repid,
                            output_folder,
                            suffix,
                            output_type,
                            method,
                            stage,
                            k) {
  param <- .TaskParameters(taskid = taskid)
  fn_input <- SimFN(
    output_type = output_type,
    output_folder = output_folder,
    suffix = suffix
  )
  fn_attempt <- .SimAttemptFN(fn_input)
  out <- data.frame(
    taskid = as.integer(taskid),
    repid = as.integer(repid),
    k = as.integer(k),
    n = param$n,
    time = param$time,
    heterogeneity = param$heterogeneity,
    output_type = output_type,
    method = method,
    stage = stage,
    exists = file.exists(fn_input),
    readable = FALSE,
    attempt_recorded = file.exists(fn_attempt),
    estimation_attempted = file.exists(fn_input),
    converged = FALSE,
    admissible = FALSE,
    summary_finite = FALSE,
    check_error = FALSE,
    status_code = NA_integer_,
    convergence_prop = NA_real_,
    elapsed_seconds = NA_real_,
    status = "missing_file",
    failure_class = "missing_file",
    message = NA_character_,
    checked_at = format(
      Sys.time(),
      tz = "UTC",
      usetz = TRUE
    ),
    stringsAsFactors = FALSE
  )
  if (!out$exists) {
    attempt <- .SimReadAttempt(fn_input)
    if (is.null(attempt)) {
      return(out)
    }
    out$attempt_recorded <- TRUE
    if (inherits(attempt, "error")) {
      out$status <- "infrastructure_error"
      out$failure_class <- "infrastructure_error"
      out$message <- paste0(
        "Simulation attempt record is unreadable: ",
        conditionMessage(attempt)
      )
      return(out)
    }
    failure_class <- as.character(attempt$failure_class)[1]
    if (!failure_class %in% c(
      "estimation_error",
      "upstream_failure",
      "infrastructure_error"
    )) {
      out$check_error <- TRUE
      out$status <- "check_error"
      out$failure_class <- "check_error"
      out$message <- paste0(
        "Unknown simulation attempt failure class: ",
        failure_class,
        "."
      )
      return(out)
    }
    out$estimation_attempted <- isTRUE(
      attempt$estimation_attempted
    )
    if (!is.null(attempt$elapsed_seconds)) {
      elapsed_seconds <- suppressWarnings(
        as.numeric(attempt$elapsed_seconds)[1]
      )
      if (is.finite(elapsed_seconds)) {
        out$elapsed_seconds <- elapsed_seconds
      }
    }
    out$status <- failure_class
    out$failure_class <- failure_class
    out$message <- as.character(attempt$message)[1]
    return(out)
  }
  object <- tryCatch(
    readRDS(fn_input),
    error = function(e) e
  )
  if (inherits(object, "error")) {
    out$status <- "unreadable_file"
    out$failure_class <- "unreadable_file"
    out$message <- conditionMessage(object)
    return(out)
  }
  out$readable <- TRUE
  out$elapsed_seconds <- .CheckElapsedSeconds(object)
  diagnostic <- tryCatch(
    {
      if (
        output_type %in% c(
          "fit-dt-var-mx",
          "fit-dt-var-mx-k4"
        )
      ) {
        convergence_prop <- converged(
          object$output,
          prop = TRUE
        )
        convergence_prop <- as.numeric(convergence_prop)[1]
        converged_fit <- is.finite(convergence_prop) &&
          convergence_prop >= 1
        list(
          converged = converged_fit,
          admissible = converged_fit,
          summary_finite = NA,
          check_error = FALSE,
          status_code = NA_integer_,
          convergence_prop = convergence_prop,
          message = if (converged_fit) {
            NA_character_
          } else {
            "At least one Stage 1 person-specific model did not converge."
          }
        )
      } else if (
        output_type %in% c(
          "fit-meta-var-mx",
          "fit-meta-var-mx-k4"
        )
      ) {
        status_code <- metaDyn:::.CheckStatusCode(
          model = object$output$output
        )
        converged_fit <- isTRUE(status_code == 0L)
        finite_summary <- if (converged_fit) {
          .CheckFiniteSummary(object)
        } else {
          list(
            ok = FALSE,
            message = paste0(
              "OpenMx/metaDyn status code = ",
              status_code,
              "."
            )
          )
        }
        list(
          converged = converged_fit,
          admissible = converged_fit && finite_summary$ok,
          summary_finite = finite_summary$ok,
          check_error = FALSE,
          status_code = as.integer(status_code),
          convergence_prop = NA_real_,
          message = finite_summary$message
        )
      } else if (output_type == "fit-naive") {
        status_code <- object$output$output$status$code
        converged_fit <- isTRUE(status_code == 0L)
        finite_summary <- if (converged_fit) {
          .CheckFiniteSummary(object)
        } else {
          list(
            ok = FALSE,
            message = paste0(
              "OpenMx status code = ",
              status_code,
              "."
            )
          )
        }
        list(
          converged = converged_fit,
          admissible = converged_fit && finite_summary$ok,
          summary_finite = finite_summary$ok,
          check_error = FALSE,
          status_code = as.integer(status_code),
          convergence_prop = NA_real_,
          message = finite_summary$message
        )
      } else if (
        output_type %in% c(
          "fit-mplus",
          "fit-mplus-priors",
          "fit-mplus-k4",
          "fit-mplus-k4-priors"
        )
      ) {
        normal_termination <- any(
          grepl(
            pattern = "THE MODEL ESTIMATION TERMINATED NORMALLY",
            x = object$output$output,
            fixed = TRUE
          )
        )
        finite_summary <- if (normal_termination) {
          .CheckFiniteSummary(object)
        } else {
          list(
            ok = FALSE,
            message = "Mplus did not report normal termination."
          )
        }
        list(
          converged = normal_termination,
          admissible = normal_termination && finite_summary$ok,
          summary_finite = finite_summary$ok,
          check_error = FALSE,
          status_code = NA_integer_,
          convergence_prop = NA_real_,
          message = finite_summary$message
        )
      } else {
        stop(
          paste0(
            "Unknown simulation output type: ",
            output_type,
            "."
          ),
          call. = FALSE
        )
      }
    },
    error = function(e) {
      list(
        converged = FALSE,
        admissible = FALSE,
        summary_finite = FALSE,
        check_error = TRUE,
        status_code = NA_integer_,
        convergence_prop = NA_real_,
        message = conditionMessage(e)
      )
    }
  )
  out$converged <- diagnostic$converged
  out$admissible <- diagnostic$admissible
  out$summary_finite <- diagnostic$summary_finite
  out$check_error <- isTRUE(diagnostic$check_error)
  out$status_code <- diagnostic$status_code
  out$convergence_prop <- diagnostic$convergence_prop
  out$message <- diagnostic$message
  if (out$check_error) {
    out$status <- "check_error"
    out$failure_class <- "check_error"
  } else if (out$converged && out$admissible) {
    out$status <- "ok"
    out$failure_class <- "ok"
  } else if (!out$converged) {
    out$status <- "nonconvergence"
    out$failure_class <- "nonconvergence"
  } else {
    out$status <- "inadmissible"
    out$failure_class <- "inadmissible"
  }
  out
}
