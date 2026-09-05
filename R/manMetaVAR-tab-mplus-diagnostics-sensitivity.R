#' Bayesian Diagnostic Failure-Rate Sensitivity Table
#'
#' Create a simulation-case-level table of Bayesian Mplus diagnostic failure
#' rates. Unlike the overview figure, the function retains one row for every
#' simulation task ID and does not average across simulation cases.
#'
#' @author Ivan Jacob Agaloos Pesigan
#'
#' @param diagnostics An all-task diagnostics object containing a `parameters`
#'   data frame, or the parameter-level data frame itself.
#' @param comparison Character string. `"difference"` returns paired
#'   user-prior minus default-prior failure-rate differences. `"levels"`
#'   returns the two prior-specific failure rates. `"all"` returns the default
#'   rate, user-prior rate, and paired difference.
#' @param diagnostic One or more diagnostic panels. Available values are
#'   `"Any diagnostic"`, `"R-hat"`, `"Bulk ESS"`, `"Tail ESS"`, and
#'   `"Relative MCSE"` when `relative_mcse = TRUE`.
#' @param unit Character string controlling the unit classified as failed.
#'   `"replication"` classifies a replication as failed when any parameter in
#'   the selected block fails. `"parameter"` averages failures over
#'   parameter-replication pairs.
#' @param taskid Optional positive integer task IDs to include.
#' @param target Optional parameter blocks to include. Available values are
#'   `"Innovation"`, `"FE"`, and `"RE"`.
#' @param rhat_threshold Numeric R-hat threshold.
#' @param ess_threshold Numeric bulk and tail effective sample size threshold.
#' @param mcse_threshold Numeric Monte Carlo standard error threshold.
#' @param relative_mcse Logical. If `TRUE`, Monte Carlo standard errors are
#'   divided by the posterior standard deviation before classifying failures.
#' @param output Character string. `"data.frame"` returns a wide data frame
#'   with simulation-design columns, `"matrix"` returns only the numeric
#'   case-by-summary matrix, and `"long"` returns one row per task, block,
#'   diagnostic, and prior comparison.
#' @param scale Character string. `"proportion"` returns values on the 0-to-1
#'   scale. `"percent"` multiplies prior-specific failure rates by 100 and
#'   expresses differences in percentage points.
#' @param digits Nonnegative integer used to round the returned values.
#'
#' @return A data frame or numeric matrix. For `output = "matrix"`, simulation
#'   design information is stored in the `"case_data"` attribute.
#'
#' @details
#' Failure rates are computed separately within each task ID. For
#' `comparison = "difference"`, replications are paired before calculating
#' the user-prior minus default-prior difference. Negative differences favor
#' the user-specified priors.
#'
#' The default `unit = "replication"` answers the question: within a given
#' simulation case, what percentage of replications had at least one failed
#' parameter in the selected parameter block?
#'
#' @examples
#' \dontrun{
#' data(diagnostics, package = "manMetaVAR")
#'
#' # Compact sensitivity matrix: one row per simulation case
#' TabMplusDiagSensitivity(
#'   diagnostics = diagnostics,
#'   comparison = "difference",
#'   output = "matrix"
#' )
#'
#' # Default, user-prior, and difference columns
#' TabMplusDiagSensitivity(
#'   diagnostics = diagnostics,
#'   comparison = "all",
#'   output = "data.frame"
#' )
#'
#' # Diagnostic-specific table
#' TabMplusDiagSensitivity(
#'   diagnostics = diagnostics,
#'   comparison = "difference",
#'   diagnostic = c("R-hat", "Bulk ESS", "Tail ESS", "Relative MCSE")
#' )
#' }
#'
#' @keywords manMetaVAR table diagnostics simulation sensitivity
#' @export
TabMplusDiagSensitivity <- function(
  diagnostics,
  comparison = "difference",
  diagnostic = "Any diagnostic",
  unit = "replication",
  taskid = NULL,
  target = NULL,
  rhat_threshold = 1.01,
  ess_threshold = 400,
  mcse_threshold = 0.05,
  relative_mcse = TRUE,
  output = "data.frame",
  scale = "percent",
  digits = 0L
) {
  comparison <- match.arg(
    arg = comparison,
    choices = c("difference", "levels", "all")
  )
  unit <- match.arg(
    arg = unit,
    choices = c("replication", "parameter")
  )
  output <- match.arg(
    arg = output,
    choices = c("data.frame", "matrix", "long")
  )
  scale <- match.arg(
    arg = scale,
    choices = c("percent", "proportion")
  )

  if (is.null(diagnostic)) {
    diagnostic <- "Any diagnostic"
  }

  if (
    length(digits) != 1L ||
      !is.numeric(digits) ||
      !is.finite(digits) ||
      digits < 0 ||
      digits != floor(digits)
  ) {
    stop(
      "`digits` should be a single nonnegative integer.",
      call. = FALSE
    )
  }
  digits <- as.integer(digits)

  if (
    !exists(
      ".BuildMplusDiagOverviewData",
      mode = "function",
      inherits = TRUE
    )
  ) {
    stop(
      paste0(
        "`TabMplusDiagSensitivity()` requires the diagnostic overview ",
        "helpers supplied with `FigMplusDiagnosticsOverview()`."
      ),
      call. = FALSE
    )
  }

  build_data <- function(current_comparison) {
    .BuildMplusDiagOverviewData(
      diagnostics = diagnostics,
      comparison = current_comparison,
      diagnostic = diagnostic,
      unit = unit,
      taskid = taskid,
      target = target,
      rhat_threshold = rhat_threshold,
      ess_threshold = ess_threshold,
      mcse_threshold = mcse_threshold,
      relative_mcse = relative_mcse,
      label_threshold = 0
    )
  }

  if (comparison == "all") {
    levels_data <- build_data("levels")
    difference_data <- build_data("difference")

    levels_data$statistic <- ifelse(
      as.character(levels_data$method) == "BMLVAR-Default",
      "Default",
      "User"
    )
    difference_data$statistic <- "Difference"

    common <- intersect(
      names(levels_data),
      names(difference_data)
    )
    table_data <- rbind(
      levels_data[common],
      difference_data[common]
    )
    table_data$statistic <- c(
      levels_data$statistic,
      difference_data$statistic
    )
  } else {
    table_data <- build_data(comparison)
    if (comparison == "levels") {
      table_data$statistic <- ifelse(
        as.character(table_data$method) == "BMLVAR-Default",
        "Default",
        "User"
      )
    } else {
      table_data$statistic <- "Difference"
    }
  }

  table_data$target_label <- as.character(table_data$target_label)
  table_data$diagnostic <- as.character(table_data$diagnostic)
  table_data$statistic <- as.character(table_data$statistic)

  statistic_levels <- switch(comparison,
    difference = "Difference",
    levels = c("Default", "User"),
    all = c("Default", "User", "Difference")
  )
  target_levels <- c(
    "Innovation covariance",
    "Fixed effects",
    "Random effects"
  )
  target_levels <- target_levels[
    target_levels %in% unique(table_data$target_label)
  ]
  diagnostic_levels <- diagnostic[
    diagnostic %in% unique(table_data$diagnostic)
  ]

  order_index <- order(
    table_data$taskid,
    match(table_data$diagnostic, diagnostic_levels),
    match(table_data$target_label, target_levels),
    match(table_data$statistic, statistic_levels)
  )
  table_data <- table_data[order_index, , drop = FALSE]

  multiplier <- if (scale == "percent") 100 else 1
  table_data$value <- round(
    multiplier * table_data$value,
    digits = digits
  )

  table_data$case_label <- .MplusDiagSensitivityLabel(
    taskid = table_data$taskid,
    heterogeneity = table_data$heterogeneity,
    n = table_data$n,
    time = table_data$time
  )

  if (output == "long") {
    out <- table_data[
      c(
        "taskid",
        "case_label",
        "n",
        "time",
        "heterogeneity",
        "target",
        "target_label",
        "diagnostic",
        "statistic",
        "value",
        "n_valid",
        "unit"
      )
    ]
    names(out)[names(out) == "value"] <- if (scale == "percent") {
      "failure_rate_percent"
    } else {
      "failure_rate"
    }
    attr(out, "scale") <- scale
    attr(out, "difference_definition") <- "User - Default"
    rownames(out) <- NULL
    return(out)
  }

  include_diagnostic <- length(diagnostic_levels) > 1L
  include_statistic <- comparison != "difference"

  table_data$column_label <- vapply(
    seq_len(nrow(table_data)),
    FUN.VALUE = character(1),
    FUN = function(i) {
      pieces <- character(0)
      if (include_diagnostic) {
        pieces <- c(pieces, table_data$diagnostic[i])
      }
      pieces <- c(pieces, table_data$target_label[i])
      if (include_statistic) {
        pieces <- c(pieces, table_data$statistic[i])
      }
      paste(pieces, collapse = " | ")
    }
  )

  duplicate_key <- table_data[c("taskid", "column_label")]
  if (anyDuplicated(duplicate_key)) {
    stop(
      paste(
        "The requested diagnostics do not identify a unique value for each",
        "simulation case and table column."
      ),
      call. = FALSE
    )
  }

  case_data <- unique(
    table_data[
      c(
        "taskid",
        "case_label",
        "n",
        "time",
        "heterogeneity"
      )
    ]
  )
  case_data <- case_data[
    order(case_data$taskid), ,
    drop = FALSE
  ]
  rownames(case_data) <- NULL

  column_order <- unique(table_data$column_label)
  value_matrix <- matrix(
    NA_real_,
    nrow = nrow(case_data),
    ncol = length(column_order),
    dimnames = list(
      case_data$case_label,
      column_order
    )
  )

  row_location <- match(table_data$taskid, case_data$taskid)
  column_location <- match(
    table_data$column_label,
    column_order
  )
  value_matrix[cbind(row_location, column_location)] <- table_data$value

  attr(value_matrix, "case_data") <- case_data
  attr(value_matrix, "scale") <- scale
  attr(value_matrix, "difference_definition") <- "User - Default"
  attr(value_matrix, "unit") <- unit
  attr(value_matrix, "thresholds") <- list(
    rhat = rhat_threshold,
    ess = ess_threshold,
    mcse = mcse_threshold,
    relative_mcse = relative_mcse
  )

  if (output == "matrix") {
    return(value_matrix)
  }

  out <- data.frame(
    case_data,
    value_matrix,
    check.names = FALSE,
    row.names = NULL
  )
  attr(out, "scale") <- scale
  attr(out, "difference_definition") <- "User - Default"
  attr(out, "unit") <- unit
  attr(out, "thresholds") <- attr(value_matrix, "thresholds")
  out
}

.MplusDiagSensitivityLabel <- function(taskid,
                                       heterogeneity,
                                       n,
                                       time) {
  time_label <- ifelse(
    is.na(time),
    "Unbalanced",
    format(time, trim = TRUE, scientific = FALSE)
  )
  paste0(
    "Task ",
    sprintf("%05d", as.integer(taskid)),
    ": Het = ",
    format(heterogeneity, trim = TRUE, scientific = FALSE),
    "; N = ",
    format(n, trim = TRUE, scientific = FALSE),
    "; T = ",
    time_label
  )
}
