#' Summarize Simulation Status Outcomes
#'
#' Aggregates replication-level status manifests into counts and rates by
#' output type and also constructs full-pipeline summaries for the two-stage
#' methods. The summary retains genuine estimation outcomes separately from
#' repair-required technical failures.
#'
#' The requested replication count is retained as `replications_requested`.
#' Counts include files present, attempt records, estimation attempts, readable
#' fits, converged fits, admissible fits, successful fits, and each failure
#' class. Rates are calculated relative to the requested rows represented in
#' the supplied status data.
#'
#' For MetaVAR and the uncertainty-uncorrected benchmark, full-pipeline success
#' requires both Stage 1 and Stage 2 to be successful. Pipeline failure classes
#' reflect failures from either required stage.
#'
#' @author Ivan Jacob Agaloos Pesigan
#'
#' @param status A combined simulation status manifest, typically returned by
#'   [`.SumStatusManifest()`].
#'
#' @return A data frame containing status counts and rates by method/stage and,
#'   when available, derived full-pipeline rows. Returns an empty data frame for
#'   `NULL` or empty input.
#'
#' @keywords manMetaVAR internal simulation summary diagnostics
#' @noRd
.SumStatusSummary <- function(status) {
  if (is.null(status) || nrow(status) < 1L) {
    return(data.frame())
  }
  if (!"check_error" %in% names(status)) {
    status$check_error <- status$failure_class == "check_error"
  }
  if (!"attempt_recorded" %in% names(status)) {
    status$attempt_recorded <- FALSE
  }
  if (!"estimation_attempted" %in% names(status)) {
    status$estimation_attempted <- status$exists
  }

  summarize_rows <- function(x,
                             output_type = x$output_type[1],
                             method = x$method[1],
                             stage = x$stage[1]) {
    requested <- nrow(x)
    data.frame(
      taskid = x$taskid[1],
      k = x$k[1],
      n = x$n[1],
      time = x$time[1],
      heterogeneity = x$heterogeneity[1],
      output_type = output_type,
      method = method,
      stage = stage,
      replications_requested = requested,
      files_present = sum(x$exists),
      attempt_records = sum(x$attempt_recorded),
      estimation_attempted = sum(x$estimation_attempted),
      readable = sum(x$readable),
      converged = sum(x$converged),
      admissible = sum(x$admissible),
      successful = sum(x$status == "ok"),
      missing_file = sum(x$failure_class == "missing_file"),
      unreadable_file = sum(x$failure_class == "unreadable_file"),
      infrastructure_error = sum(
        x$failure_class == "infrastructure_error"
      ),
      check_error = sum(x$failure_class == "check_error"),
      estimation_error = sum(x$failure_class == "estimation_error"),
      upstream_failure = sum(x$failure_class == "upstream_failure"),
      nonconvergence = sum(x$failure_class == "nonconvergence"),
      inadmissible = sum(x$failure_class == "inadmissible"),
      estimation_attempt_rate = mean(x$estimation_attempted),
      convergence_rate = mean(x$converged),
      admissible_rate = mean(x$admissible),
      success_rate = mean(x$status == "ok"),
      stringsAsFactors = FALSE
    )
  }

  groups <- split(
    x = status,
    f = status$output_type,
    drop = TRUE
  )
  out <- lapply(
    X = groups,
    FUN = summarize_rows
  )

  pipelines <- list(
    list(
      stage1 = "fit-dt-var-mx",
      stage2 = "fit-meta-var-mx",
      output_type = "pipeline-meta-var",
      method = "MetaVAR",
      stage = "Full pipeline"
    ),
    list(
      stage1 = "fit-dt-var-mx",
      stage2 = "fit-naive",
      output_type = "pipeline-naive",
      method = "Uncertainty-Uncorrected",
      stage = "Full pipeline"
    ),
    list(
      stage1 = "fit-dt-var-mx-k4",
      stage2 = "fit-meta-var-mx-k4",
      output_type = "pipeline-meta-var-k4",
      method = "MetaVAR",
      stage = "Full pipeline"
    )
  )

  for (pipeline in pipelines) {
    if (!all(c(pipeline$stage1, pipeline$stage2) %in% status$output_type)) {
      next
    }
    stage1 <- status[
      status$output_type == pipeline$stage1, ,
      drop = FALSE
    ]
    stage2 <- status[
      status$output_type == pipeline$stage2, ,
      drop = FALSE
    ]
    merged <- merge(
      x = stage1,
      y = stage2,
      by = c(
        "taskid",
        "repid",
        "k",
        "n",
        "time",
        "heterogeneity"
      ),
      suffixes = c(
        "_stage1",
        "_stage2"
      )
    )
    if (nrow(merged) < 1L) {
      next
    }
    pipeline_status <- data.frame(
      taskid = merged$taskid,
      repid = merged$repid,
      k = merged$k,
      n = merged$n,
      time = merged$time,
      heterogeneity = merged$heterogeneity,
      exists = merged$exists_stage1 & merged$exists_stage2,
      readable = merged$readable_stage1 & merged$readable_stage2,
      attempt_recorded = merged$attempt_recorded_stage1 |
        merged$attempt_recorded_stage2,
      estimation_attempted = merged$estimation_attempted_stage1 &
        merged$estimation_attempted_stage2,
      converged = merged$converged_stage1 & merged$converged_stage2,
      admissible = merged$admissible_stage1 & merged$admissible_stage2,
      stringsAsFactors = FALSE
    )
    failure_class <- rep(
      "ok",
      nrow(merged)
    )
    missing <- merged$failure_class_stage1 == "missing_file" |
      merged$failure_class_stage2 == "missing_file"
    unreadable <- !missing & (
      merged$failure_class_stage1 == "unreadable_file" |
        merged$failure_class_stage2 == "unreadable_file"
    )
    infrastructure_error <- !missing & !unreadable & (
      merged$failure_class_stage1 == "infrastructure_error" |
        merged$failure_class_stage2 == "infrastructure_error"
    )
    check_error <- !missing & !unreadable & !infrastructure_error & (
      merged$failure_class_stage1 == "check_error" |
        merged$failure_class_stage2 == "check_error"
    )
    estimation_error <- !missing & !unreadable &
      !infrastructure_error & !check_error & (
      merged$failure_class_stage1 == "estimation_error" |
        merged$failure_class_stage2 == "estimation_error"
    )
    upstream_failure <- !missing & !unreadable &
      !infrastructure_error & !check_error & !estimation_error & (
      merged$failure_class_stage1 == "upstream_failure" |
        merged$failure_class_stage2 == "upstream_failure"
    )
    nonconvergence <- !missing & !unreadable &
      !infrastructure_error & !check_error & !estimation_error &
      !upstream_failure & !pipeline_status$converged
    inadmissible <- !missing & !unreadable &
      !infrastructure_error & !check_error & !estimation_error &
      !upstream_failure & pipeline_status$converged &
      !pipeline_status$admissible
    failure_class[missing] <- "missing_file"
    failure_class[unreadable] <- "unreadable_file"
    failure_class[infrastructure_error] <- "infrastructure_error"
    failure_class[check_error] <- "check_error"
    failure_class[estimation_error] <- "estimation_error"
    failure_class[upstream_failure] <- "upstream_failure"
    failure_class[nonconvergence] <- "nonconvergence"
    failure_class[inadmissible] <- "inadmissible"
    pipeline_status$failure_class <- failure_class
    pipeline_status$status <- ifelse(
      failure_class == "ok",
      "ok",
      failure_class
    )
    pipeline_status$method <- pipeline$method
    pipeline_status$stage <- pipeline$stage
    pipeline_status$output_type <- pipeline$output_type
    pipeline_status$check_error <- failure_class == "check_error"

    out[[length(out) + 1L]] <- summarize_rows(
      x = pipeline_status,
      output_type = pipeline$output_type,
      method = pipeline$method,
      stage = pipeline$stage
    )
  }

  out <- do.call(
    what = rbind,
    args = out
  )
  rownames(out) <- NULL
  out
}
