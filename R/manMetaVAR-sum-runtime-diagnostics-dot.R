#' Summarize Simulation Runtime Diagnostics
#'
#' Constructs replication-level and aggregate runtime summaries from simulation
#' status manifests. Runtimes are reported separately for all recorded
#' estimation attempts and for successful fits.
#'
#' The `all_attempts` scope includes readable fits and recorded estimation
#' attempts with finite elapsed times, including attempts that ended in a
#' genuine estimation error. The `successful` scope includes only readable
#' artifacts with status `ok`. For two-stage methods, total runtime is the sum
#' of Stage 1 and Stage 2 elapsed times when both required components are
#' available within the corresponding scope.
#'
#' @author Ivan Jacob Agaloos Pesigan
#'
#' @param status A combined simulation status manifest containing
#'   `elapsed_seconds` and status information.
#' @param k4 Logical. If `TRUE`, summarize the four-variable feasibility
#'   simulation; otherwise summarize the two-variable simulation.
#'
#' @return A list with two data frames: `replications`, containing the
#'   replication-level runtime records, and `summary`, containing the number of
#'   contributing replications and the mean, standard deviation, median,
#'   quartiles, minimum, and maximum elapsed times by runtime component and
#'   scope. Empty data frames are returned when no usable runtime information is
#'   available.
#'
#' @keywords manMetaVAR internal simulation summary diagnostics runtime
#' @noRd
.SumRuntimeDiagnostics <- function(status,
                                   k4 = FALSE) {
  if (is.null(status) || nrow(status) < 1L) {
    return(
      list(
        replications = data.frame(),
        summary = data.frame()
      )
    )
  }

  runtime_for_scope <- function(scope,
                                successful_only) {
    keep <- is.finite(status$elapsed_seconds)
    if (successful_only) {
      keep <- keep & status$readable & status$status == "ok"
    } else {
      if (!"estimation_attempted" %in% names(status)) {
        status$estimation_attempted <- status$exists
      }
      keep <- keep & (status$readable | status$estimation_attempted)
    }
    runtime <- status[
      keep,
      c(
        "taskid",
        "repid",
        "k",
        "n",
        "time",
        "heterogeneity",
        "output_type",
        "method",
        "stage",
        "elapsed_seconds"
      ),
      drop = FALSE
    ]
    names(runtime)[names(runtime) == "method"] <- "runtime_component"
    runtime$scope <- scope
    runtime
  }

  add_total <- function(stage1_type,
                        stage2_type,
                        label,
                        scope,
                        successful_only) {
    if (!"estimation_attempted" %in% names(status)) {
      status$estimation_attempted <- status$exists
    }
    if (successful_only) {
      keep_stage1 <- status$output_type == stage1_type &
        status$readable &
        is.finite(status$elapsed_seconds) &
        status$status == "ok"
      keep_stage2 <- status$output_type == stage2_type &
        status$readable &
        is.finite(status$elapsed_seconds) &
        status$status == "ok"
    } else {
      keep_stage1 <- status$output_type == stage1_type &
        is.finite(status$elapsed_seconds) &
        (status$readable | status$estimation_attempted)
      keep_stage2 <- status$output_type == stage2_type &
        is.finite(status$elapsed_seconds) &
        (status$readable | status$estimation_attempted)
    }
    stage1 <- status[
      keep_stage1, ,
      drop = FALSE
    ]
    stage2 <- status[
      keep_stage2, ,
      drop = FALSE
    ]
    if (nrow(stage1) < 1L || nrow(stage2) < 1L) {
      return(data.frame())
    }
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
      return(data.frame())
    }
    data.frame(
      taskid = merged$taskid,
      repid = merged$repid,
      k = merged$k,
      n = merged$n,
      time = merged$time,
      heterogeneity = merged$heterogeneity,
      output_type = paste0(stage2_type, "-total"),
      runtime_component = label,
      stage = "Total",
      elapsed_seconds = merged$elapsed_seconds_stage1 +
        merged$elapsed_seconds_stage2,
      scope = scope,
      stringsAsFactors = FALSE
    )
  }

  stage1_type <- if (k4) {
    "fit-dt-var-mx-k4"
  } else {
    "fit-dt-var-mx"
  }
  meta_type <- if (k4) {
    "fit-meta-var-mx-k4"
  } else {
    "fit-meta-var-mx"
  }

  runtime <- list(
    runtime_for_scope(
      scope = "all_attempts",
      successful_only = FALSE
    ),
    runtime_for_scope(
      scope = "successful",
      successful_only = TRUE
    )
  )

  for (scope_specification in list(
    list(
      scope = "all_attempts",
      successful_only = FALSE
    ),
    list(
      scope = "successful",
      successful_only = TRUE
    )
  )) {
    runtime[[length(runtime) + 1L]] <- add_total(
      stage1_type = stage1_type,
      stage2_type = meta_type,
      label = "MetaVAR Total",
      scope = scope_specification$scope,
      successful_only = scope_specification$successful_only
    )
    if (!k4) {
      runtime[[length(runtime) + 1L]] <- add_total(
        stage1_type = stage1_type,
        stage2_type = "fit-naive",
        label = "Uncertainty-Uncorrected Total",
        scope = scope_specification$scope,
        successful_only = scope_specification$successful_only
      )
    }
  }

  runtime <- Filter(
    f = function(x) is.data.frame(x) && nrow(x) > 0L,
    x = runtime
  )
  if (length(runtime) < 1L) {
    return(
      list(
        replications = data.frame(),
        summary = data.frame()
      )
    )
  }
  runtime <- do.call(
    what = rbind,
    args = runtime
  )
  rownames(runtime) <- NULL

  groups <- split(
    x = runtime,
    f = interaction(
      runtime$scope,
      runtime$runtime_component,
      drop = TRUE,
      lex.order = TRUE
    )
  )
  summary <- do.call(
    what = rbind,
    args = lapply(
      X = groups,
      FUN = function(x) {
        data.frame(
          taskid = x$taskid[1],
          k = x$k[1],
          n = x$n[1],
          time = x$time[1],
          heterogeneity = x$heterogeneity[1],
          runtime_component = x$runtime_component[1],
          scope = x$scope[1],
          replications_used = nrow(x),
          mean_seconds = mean(x$elapsed_seconds),
          sd_seconds = if (nrow(x) > 1L) {
            stats::sd(x$elapsed_seconds)
          } else {
            NA_real_
          },
          median_seconds = stats::median(x$elapsed_seconds),
          q25_seconds = as.numeric(
            stats::quantile(
              x$elapsed_seconds,
              probs = 0.25,
              names = FALSE
            )
          ),
          q75_seconds = as.numeric(
            stats::quantile(
              x$elapsed_seconds,
              probs = 0.75,
              names = FALSE
            )
          ),
          min_seconds = min(x$elapsed_seconds),
          max_seconds = max(x$elapsed_seconds),
          stringsAsFactors = FALSE
        )
      }
    )
  )
  rownames(summary) <- NULL
  list(
    replications = runtime,
    summary = summary
  )
}
