#' Compact Bayesian Diagnostic Overview Across Simulation Conditions
#'
#' Summarize Mplus Bayesian diagnostic failures across all simulation task IDs
#' at the Innovation, fixed-effect, and random-effect block level. This compact
#' overview is intended for manuscript figures and reviewer-oriented prior
#' sensitivity analyses. Use [FigMplusDiagnosticsHeatmap()] for parameter-level
#' drill-down figures.
#'
#' @author Ivan Jacob Agaloos Pesigan
#'
#' @param diagnostics An all-task diagnostics object containing a `parameters`
#'   data frame, or the parameter-level data frame itself.
#' @param comparison Character string. Use `"levels"` to show diagnostic
#'   failure rates under each prior specification or `"difference"` to show
#'   paired user-prior minus default-prior differences.
#' @param diagnostic Diagnostic failure panels to display. Available values are
#'   `"Any diagnostic"`, `"R-hat"`, `"Bulk ESS"`, `"Tail ESS"`, and
#'   `"Relative MCSE"` when `relative_mcse = TRUE`.
#' @param unit Character string controlling the unit summarized within each
#'   design cell. `"replication"` classifies a replication as failed when any
#'   parameter in the selected parameter block fails. `"parameter"` averages
#'   failure indicators across parameter-replication pairs.
#' @param taskid Optional positive integer task IDs to include.
#' @param target Optional parameter blocks to include. Available values are
#'   `"Innovation"`, `"FE"`, and `"RE"`.
#' @param rhat_threshold Numeric R-hat threshold.
#' @param ess_threshold Numeric bulk and tail ESS threshold.
#' @param mcse_threshold Numeric MCSE threshold.
#' @param relative_mcse Logical. If `TRUE`, Monte Carlo standard errors are
#'   divided by the posterior standard deviation before classifying failures.
#' @param grey_scale Logical. If `TRUE`, use grey-scale fills.
#' @param values Logical. If `TRUE`, print values inside sufficiently large
#'   cells.
#' @param label_threshold Numeric value between zero and one. Labels with an
#'   absolute value smaller than this threshold are omitted. For level plots,
#'   the threshold applies directly to the failure rate.
#'
#' @return A `ggplot` object. Its `data` element contains the block-level
#'   summaries used in the figure.
#'
#' @details
#' The default `unit = "replication"` answers a reviewer-friendly question:
#' what proportion of simulation replications had at least one diagnostic
#' problem within each parameter block? For `comparison = "difference"`, the
#' function pairs prior specifications within task ID and replication before
#' calculating user-prior minus default-prior differences. Negative values
#' indicate fewer failures under user-specified priors.
#'
#' @examples
#' \dontrun{
#' data(diagnostics, package = "manMetaVAR")
#'
#' FigMplusDiagnosticsOverview(
#'   diagnostics = diagnostics,
#'   comparison = "levels"
#' )
#'
#' FigMplusDiagnosticsOverview(
#'   diagnostics = diagnostics,
#'   comparison = "difference",
#'   values = TRUE
#' )
#' }
#'
#' @family Figure Functions
#' @keywords manMetaVAR figure diagnostics simulation sensitivity
#' @export
FigMplusDiagnosticsOverview <- function(diagnostics,
                                        comparison = "difference",
                                        diagnostic = "Any diagnostic",
                                        unit = "replication",
                                        taskid = NULL,
                                        target = NULL,
                                        rhat_threshold = 1.01,
                                        ess_threshold = 400,
                                        mcse_threshold = 0.05,
                                        relative_mcse = TRUE,
                                        grey_scale = FALSE,
                                        values = FALSE,
                                        label_threshold = 0.05) {
  condition_label <- target_label <- fill_value <- NULL
  value_label <- text_colour <- heterogeneity_label <- diagnostic_panel <- NULL
  method <- NULL

  comparison <- match.arg(
    arg = comparison,
    choices = c("difference", "levels")
  )
  unit <- match.arg(
    arg = unit,
    choices = c("replication", "parameter")
  )

  .ValidateMplusDiagThreshold(
    x = rhat_threshold,
    name = "rhat_threshold",
    lower = 1
  )
  .ValidateMplusDiagThreshold(
    x = ess_threshold,
    name = "ess_threshold",
    lower = 0
  )
  .ValidateMplusDiagThreshold(
    x = mcse_threshold,
    name = "mcse_threshold",
    lower = 0
  )

  for (argument in c("relative_mcse", "grey_scale", "values")) {
    value <- get(argument)
    if (
      length(value) != 1L ||
        !is.logical(value) ||
        is.na(value)
    ) {
      stop(
        paste0("`", argument, "` should be `TRUE` or `FALSE`."),
        call. = FALSE
      )
    }
  }

  if (
    length(label_threshold) != 1L ||
      !is.numeric(label_threshold) ||
      !is.finite(label_threshold) ||
      label_threshold < 0 ||
      label_threshold > 1
  ) {
    stop(
      "`label_threshold` should be a finite number between zero and one.",
      call. = FALSE
    )
  }

  plot_data <- .BuildMplusDiagOverviewData(
    diagnostics = diagnostics,
    comparison = comparison,
    diagnostic = diagnostic,
    unit = unit,
    taskid = taskid,
    target = target,
    rhat_threshold = rhat_threshold,
    ess_threshold = ess_threshold,
    mcse_threshold = mcse_threshold,
    relative_mcse = relative_mcse,
    label_threshold = label_threshold
  )

  if (comparison == "levels") {
    if (grey_scale) {
      fill_scale <- ggplot2::scale_fill_gradient(
        low = "white",
        high = "grey20",
        limits = c(0, 1),
        breaks = c(0, 0.50, 1),
        labels = c("0%", "50%", "100%"),
        name = "Failure rate",
        na.value = "grey90",
        guide = ggplot2::guide_colorbar(
          title.position = "top",
          title.hjust = 0.5,
          label.position = "bottom",
          barwidth = grid::unit(7, "cm"),
          barheight = grid::unit(0.45, "cm")
        )
      )
    } else {
      fill_scale <- ggplot2::scale_fill_gradient(
        low = "white",
        high = "#B2182B",
        limits = c(0, 1),
        breaks = c(0, 0.50, 1),
        labels = c("0%", "50%", "100%"),
        name = "Failure rate",
        na.value = "grey90",
        guide = ggplot2::guide_colorbar(
          title.position = "top",
          title.hjust = 0.5,
          label.position = "bottom",
          barwidth = grid::unit(7, "cm"),
          barheight = grid::unit(0.45, "cm")
        )
      )
    }
  } else {
    if (grey_scale) {
      fill_scale <- ggplot2::scale_fill_gradient2(
        low = "grey25",
        mid = "white",
        high = "grey70",
        midpoint = 0,
        limits = c(-1, 1),
        breaks = c(-1, 0, 1),
        labels = c("-100 pp", "0 pp", "+100 pp"),
        name = "User - default",
        na.value = "grey90",
        guide = ggplot2::guide_colorbar(
          title.position = "top",
          title.hjust = 0.5,
          label.position = "bottom",
          barwidth = grid::unit(7, "cm"),
          barheight = grid::unit(0.45, "cm")
        )
      )
    } else {
      fill_scale <- ggplot2::scale_fill_gradient2(
        low = "#2166AC",
        mid = "white",
        high = "#B2182B",
        midpoint = 0,
        limits = c(-1, 1),
        breaks = c(-1, 0, 1),
        labels = c("-100 pp", "0 pp", "+100 pp"),
        name = "User - default",
        na.value = "grey90",
        guide = ggplot2::guide_colorbar(
          title.position = "top",
          title.hjust = 0.5,
          label.position = "bottom",
          barwidth = grid::unit(7, "cm"),
          barheight = grid::unit(0.45, "cm")
        )
      )
    }
  }

  overview_plot <- ggplot2::ggplot(
    data = plot_data,
    mapping = ggplot2::aes(
      x = condition_label,
      y = target_label,
      fill = fill_value
    )
  ) +
    ggplot2::geom_tile(
      color = "white",
      linewidth = 0.5
    )

  if (values) {
    overview_plot <- overview_plot +
      ggplot2::geom_text(
        mapping = ggplot2::aes(
          label = value_label,
          color = text_colour
        ),
        size = 3,
        show.legend = FALSE,
        na.rm = TRUE
      ) +
      ggplot2::scale_color_identity()
  }

  if (comparison == "levels") {
    overview_plot <- overview_plot +
      ggplot2::facet_grid(
        rows = ggplot2::vars(heterogeneity_label),
        cols = ggplot2::vars(diagnostic_panel, method)
      )
  } else {
    overview_plot <- overview_plot +
      ggplot2::facet_grid(
        rows = ggplot2::vars(heterogeneity_label),
        cols = ggplot2::vars(diagnostic_panel)
      )
  }

  unit_text <- if (unit == "replication") {
    "replications with at least one failed parameter"
  } else {
    "parameter-replication pairs that failed"
  }

  subtitle <- if (comparison == "difference") {
    paste0(
      "Cells show paired user-prior minus default-prior percentages of ",
      unit_text,
      ". Negative values favor user priors."
    )
  } else {
    paste0(
      "Cells show percentages of ",
      unit_text,
      " under each prior specification."
    )
  }

  caption <- paste0(
    "Failures use R-hat > ",
    format(rhat_threshold, trim = TRUE),
    ", ESS < ",
    format(ess_threshold, trim = TRUE),
    ", and ",
    if (relative_mcse) "relative " else "",
    "MCSE > ",
    format(mcse_threshold, trim = TRUE),
    ". Nonfinite diagnostics count as failures."
  )

  overview_plot +
    fill_scale +
    ggplot2::labs(
      title = if (comparison == "difference") {
        "Bayesian diagnostic sensitivity by parameter block"
      } else {
        "Bayesian diagnostic failure rates by parameter block"
      },
      subtitle = subtitle,
      caption = caption,
      x = NULL,
      y = NULL
    ) +
    .FigTheme(base_size = 11) +
    ggplot2::theme(
      axis.text.x = ggplot2::element_text(
        angle = 45,
        hjust = 1,
        vjust = 1
      ),
      panel.spacing = grid::unit(0.6, "lines"),
      legend.box = "vertical",
      legend.box.just = "center",
      legend.title = ggplot2::element_text(
        face = "bold",
        hjust = 0.5
      ),
      legend.text = ggplot2::element_text(size = 9)
    )
}

.BuildMplusDiagOverviewData <- function(diagnostics,
                                        comparison,
                                        diagnostic,
                                        unit,
                                        taskid,
                                        target,
                                        rhat_threshold,
                                        ess_threshold,
                                        mcse_threshold,
                                        relative_mcse,
                                        label_threshold) {
  parameter_runs <- .MplusDiagnosticsHeatmapRows(diagnostics)
  parameter_runs <- .FilterMplusDiagHeatmapTask(
    x = parameter_runs,
    taskid = taskid
  )

  dictionary <- .MplusDiagHeatmapParmDict()
  location <- match(parameter_runs$parameter, dictionary$parameter)
  if (anyNA(location)) {
    stop(
      paste0(
        "Unknown Mplus diagnostic parameters were found: ",
        paste(
          unique(parameter_runs$parameter[is.na(location)]),
          collapse = ", "
        ),
        "."
      ),
      call. = FALSE
    )
  }
  parameter_runs$target <- dictionary$target[location]

  target_levels <- c("Innovation", "FE", "RE")
  if (!is.null(target)) {
    if (!is.character(target) || length(target) == 0L) {
      stop(
        "`target` should be `NULL` or contain parameter-block names.",
        call. = FALSE
      )
    }
    missing_target <- setdiff(target, target_levels)
    if (length(missing_target) > 0L) {
      stop(
        paste0(
          "Unknown parameter blocks were requested: ",
          paste(missing_target, collapse = ", "),
          ". Available blocks are: ",
          paste(target_levels, collapse = ", "),
          "."
        ),
        call. = FALSE
      )
    }
    parameter_runs <- parameter_runs[
      parameter_runs$target %in% target, ,
      drop = FALSE
    ]
    target_levels <- target
  }

  long <- .LongMplusDiagnosticsHeatmap(
    x = parameter_runs,
    metric_name = "failure_rate",
    rhat_threshold = rhat_threshold,
    ess_threshold = ess_threshold,
    mcse_threshold = mcse_threshold,
    relative_mcse = relative_mcse
  )
  long_location <- match(long$parameter, dictionary$parameter)
  long$target <- dictionary$target[long_location]

  available_diagnostics <- unique(long$diagnostic)
  if (is.null(diagnostic)) {
    diagnostic <- "Any diagnostic"
  }
  if (!is.character(diagnostic) || length(diagnostic) == 0L) {
    stop(
      "`diagnostic` should contain one or more diagnostic panel names.",
      call. = FALSE
    )
  }
  missing_diagnostic <- setdiff(diagnostic, available_diagnostics)
  if (length(missing_diagnostic) > 0L) {
    stop(
      paste0(
        "Unknown diagnostic panels were requested: ",
        paste(missing_diagnostic, collapse = ", "),
        ". Available panels are: ",
        paste(available_diagnostics, collapse = ", "),
        "."
      ),
      call. = FALSE
    )
  }
  long <- long[
    long$diagnostic %in% diagnostic, ,
    drop = FALSE
  ]

  if (unit == "replication") {
    long <- .CollapseMplusDiagOverviewRep(long)
  }

  if (comparison == "difference") {
    long <- .PairMplusDiagnosticsOverview(long, unit = unit)
  }

  summary_data <- .SummarizeMplusDiagOverview(
    x = long,
    comparison = comparison,
    unit = unit
  )
  summary_data <- .LabelMplusDiagOverview(
    x = summary_data,
    target_levels = target_levels,
    diagnostic_levels = diagnostic,
    comparison = comparison
  )

  summary_data$fill_value <- summary_data$value
  summary_data$value_label <- ifelse(
    is.finite(summary_data$value) &
      abs(summary_data$value) >= label_threshold,
    if (comparison == "difference") {
      sprintf("%+.0f pp", 100 * summary_data$value)
    } else {
      sprintf("%.0f%%", 100 * summary_data$value)
    },
    NA_character_
  )
  summary_data$text_colour <- ifelse(
    is.finite(summary_data$value) &
      (if (comparison == "difference") {
        abs(summary_data$value) >= 0.60
      } else {
        summary_data$value >= 0.60
      }),
    "white",
    "black"
  )
  summary_data
}

.CollapseMplusDiagOverviewRep <- function(x) {
  group_names <- c(
    "taskid",
    "repid",
    "method",
    "default_priors",
    "target",
    "diagnostic"
  )
  metadata <- c(
    group_names,
    "n",
    "time",
    "heterogeneity"
  )
  group <- interaction(
    x[group_names],
    drop = TRUE,
    lex.order = TRUE
  )
  pieces <- split(x = x, f = group, drop = TRUE)
  out <- lapply(
    X = pieces,
    FUN = function(z) {
      data.frame(
        z[1, metadata, drop = FALSE],
        value = as.numeric(any(z$value > 0)),
        row.names = NULL,
        check.names = FALSE
      )
    }
  )
  out <- do.call(what = "rbind", args = out)
  rownames(out) <- NULL
  out
}

.PairMplusDiagnosticsOverview <- function(x, unit) {
  keys <- c("taskid", "repid", "target", "diagnostic")
  if (unit == "parameter") {
    keys <- c(keys, "parameter")
  }
  if (anyDuplicated(x[c(keys, "default_priors")])) {
    stop(
      "Diagnostic rows are duplicated within a prior condition.",
      call. = FALSE
    )
  }

  default <- x[x$default_priors, , drop = FALSE]
  priors <- x[!x$default_priors, , drop = FALSE]
  if (nrow(default) == 0L || nrow(priors) == 0L) {
    stop(
      paste0(
        "`comparison = \"difference\"` requires both default- and ",
        "user-prior diagnostics."
      ),
      call. = FALSE
    )
  }

  paired <- merge(
    x = default,
    y = priors,
    by = keys,
    suffixes = c("_default", "_priors"),
    all = FALSE,
    sort = FALSE
  )
  if (nrow(paired) == 0L) {
    stop(
      "No matched default- and user-prior diagnostic rows were found.",
      call. = FALSE
    )
  }

  pick <- function(name) {
    default_name <- paste0(name, "_default")
    priors_name <- paste0(name, "_priors")
    default_value <- paired[[default_name]]
    priors_value <- paired[[priors_name]]
    ifelse(is.na(default_value), priors_value, default_value)
  }

  out <- data.frame(
    taskid = paired$taskid,
    repid = paired$repid,
    method = "Priors - Default",
    default_priors = NA,
    n = pick("n"),
    time = pick("time"),
    heterogeneity = pick("heterogeneity"),
    target = paired$target,
    diagnostic = paired$diagnostic,
    value = paired$value_priors - paired$value_default,
    row.names = NULL,
    check.names = FALSE
  )
  if (unit == "parameter") {
    out$parameter <- paired$parameter
  }
  out
}

.SummarizeMplusDiagOverview <- function(x,
                                        comparison,
                                        unit) {
  group_names <- c("taskid", "method", "target", "diagnostic")
  metadata <- c(
    "taskid",
    "method",
    "n",
    "time",
    "heterogeneity",
    "target",
    "diagnostic"
  )
  group <- interaction(
    x[group_names],
    drop = TRUE,
    lex.order = TRUE
  )
  pieces <- split(x = x, f = group, drop = TRUE)
  out <- lapply(
    X = pieces,
    FUN = function(z) {
      data.frame(
        z[1, metadata, drop = FALSE],
        value = mean(z$value),
        n_valid = length(z$value),
        comparison = comparison,
        unit = unit,
        row.names = NULL,
        check.names = FALSE
      )
    }
  )
  out <- do.call(what = "rbind", args = out)
  rownames(out) <- NULL
  out
}

.LabelMplusDiagOverview <- function(x,
                                    target_levels,
                                    diagnostic_levels,
                                    comparison) {
  condition_dictionary <- unique(
    x[c("taskid", "n", "time", "heterogeneity")]
  )
  condition_dictionary <- condition_dictionary[
    order(
      condition_dictionary$heterogeneity,
      condition_dictionary$taskid
    ), ,
    drop = FALSE
  ]
  if (anyDuplicated(condition_dictionary$taskid)) {
    stop(
      "Each task ID should identify one simulation design condition.",
      call. = FALSE
    )
  }

  condition_dictionary$condition_label <- ifelse(
    is.na(condition_dictionary$time),
    paste0("N = ", condition_dictionary$n, ", T = Unbalanced"),
    paste0(
      "N = ",
      condition_dictionary$n,
      ", T = ",
      as.integer(condition_dictionary$time)
    )
  )
  condition_dictionary$heterogeneity_label <- paste0(
    "Heterogeneity = ",
    format(
      condition_dictionary$heterogeneity,
      trim = TRUE,
      scientific = FALSE
    )
  )

  condition_location <- match(x$taskid, condition_dictionary$taskid)
  x$condition_label <- condition_dictionary$condition_label[condition_location]
  x$heterogeneity_label <- condition_dictionary$heterogeneity_label[
    condition_location
  ]

  target_labels <- c(
    Innovation = "Innovation covariance",
    FE = "Fixed effects",
    RE = "Random effects"
  )
  x$target_label <- target_labels[x$target]

  x$condition_label <- factor(
    x$condition_label,
    levels = unique(condition_dictionary$condition_label)
  )
  x$heterogeneity_label <- factor(
    x$heterogeneity_label,
    levels = unique(condition_dictionary$heterogeneity_label)
  )
  x$target_label <- factor(
    x$target_label,
    levels = rev(unname(target_labels[target_levels]))
  )
  x$diagnostic_panel <- factor(
    x$diagnostic,
    levels = diagnostic_levels
  )
  x$method <- factor(
    x$method,
    levels = if (comparison == "levels") {
      c("BMLVAR-Default", "BMLVAR-Priors")
    } else {
      "Priors - Default"
    }
  )
  x
}
