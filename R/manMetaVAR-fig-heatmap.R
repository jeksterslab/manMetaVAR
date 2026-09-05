#' Results Heatmap
#'
#' Plot results heatmap.
#'
#' @author Ivan Jacob Agaloos Pesigan
#'
#' @param metric_name Character string.
#'   `"coverage"` for coverage probability,
#'   `"abs_rel_bias"` for absolute value of the relative bias,
#'   `"rmse"` for RMSE,
#'   `"power"` for statistical power, and
#'   `"type1_error"` for the Type I error rate.
#' @param grey_scale Logical.
#'   If `TRUE`,
#'   use a grey-scale fill suitable for black-and-white printing.
#' @param values Logical.
#'   If `TRUE`,
#'   display values inside tiles.
#' @inheritParams Template
#'
#' @examples
#' \dontrun{
#' data(results, package = "manMetaVAR")
#' FigMetricHeatmap(
#'   results = results,
#'   metric_name = "coverage"
#' )
#' }
#'
#' @family Figure Functions
#' @keywords manMetaVAR figure
#' @export
FigMetricHeatmap <- function(results,
                             metric_name,
                             grey_scale = FALSE,
                             values = FALSE) {
  method <- target <- NULL
  condition_label <- parameter_label <- heterogeneity_label <- NULL
  value <- value_label <- text_colour <- NULL
  metric_data <- .BuildMetricHeatmapData(
    results = results,
    metric_name = metric_name
  )
  plot_data <- metric_data$data
  use_diverging_scale <- metric_name %in% c(
    "coverage",
    "type1_error"
  )
  if (grey_scale) {
    if (use_diverging_scale) {
      fill_scale <- ggplot2::scale_fill_gradient2(
        low = "grey25",
        mid = "white",
        high = "grey70",
        midpoint = 0,
        name = metric_data$legend_title
      )
    } else {
      fill_scale <- ggplot2::scale_fill_gradient(
        low = "white",
        high = "grey20",
        name = metric_data$legend_title
      )
    }
  } else {
    if (use_diverging_scale) {
      fill_scale <- ggplot2::scale_fill_gradient2(
        low = "#B2182B",
        mid = "white",
        high = "#2166AC",
        midpoint = 0,
        name = metric_data$legend_title
      )
    } else {
      fill_scale <- ggplot2::scale_fill_gradient(
        low = "white",
        high = "#08519C",
        name = metric_data$legend_title
      )
    }
  }
  title_lookup <- c(
    "coverage" = paste0(
      "Coverage heatmap by parameter, ",
      "design cell, and method"
    ),
    "abs_rel_bias" = paste0(
      "Bias-magnitude heatmap by parameter, ",
      "design cell, and method"
    ),
    "rmse" = paste0(
      "RMSE heatmap by parameter, ",
      "design cell, and method"
    ),
    "power" = paste0(
      "Power heatmap by parameter, ",
      "design cell, and method"
    ),
    "type1_error" = paste0(
      "Type I error heatmap by parameter, ",
      "design cell, and method"
    )
  )
  heatmap_plot <- ggplot2::ggplot(
    data = plot_data,
    mapping = ggplot2::aes(
      x = condition_label,
      y = parameter_label,
      fill = value
    )
  ) +
    ggplot2::geom_tile(
      color = "white",
      linewidth = 0.25
    )
  if (values) {
    heatmap_plot <- heatmap_plot +
      ggplot2::geom_text(
        mapping = ggplot2::aes(
          label = value_label,
          color = text_colour
        ),
        size = 2.1,
        show.legend = FALSE,
        na.rm = TRUE
      ) +
      ggplot2::scale_color_identity()
  }
  heatmap_plot +
    ggplot2::facet_grid(
      rows = ggplot2::vars(
        heterogeneity_label,
        target
      ),
      cols = ggplot2::vars(method),
      scales = "free_y",
      space = "free_y"
    ) +
    fill_scale +
    ggplot2::labs(
      title = unname(title_lookup[[metric_name]]),
      subtitle = metric_data$subtitle,
      caption = metric_data$caption,
      x = NULL,
      y = NULL
    ) +
    .FigTheme(base_size = 10)
}

.BuildMetricHeatmapData <- function(results,
                                    metric_name) {
  allowed <- c(
    "coverage",
    "abs_rel_bias",
    "rmse",
    "power",
    "type1_error"
  )
  if (
    length(metric_name) != 1L ||
      is.na(metric_name) ||
      !metric_name %in% allowed
  ) {
    stop(
      paste0(
        "`metric_name` should be one of: ",
        paste(allowed, collapse = ", "),
        "."
      ),
      call. = FALSE
    )
  }
  results <- .FigPreprocess(results)
  if (!metric_name %in% names(results)) {
    stop(
      paste0(
        "`results` does not contain `",
        metric_name,
        "`."
      ),
      call. = FALSE
    )
  }
  plot_data <- results[
    c(
      "method",
      "target",
      "heterogeneity_label",
      "condition_label",
      "parameter_label",
      metric_name
    )
  ]
  names(plot_data)[names(plot_data) == metric_name] <- "value"
  legend_title <- metric_name
  subtitle <- NULL
  caption <- NULL
  if (metric_name == "coverage") {
    plot_data$value <- plot_data$value - 0.95
    legend_title <- "Coverage - 0.95"
    subtitle <- paste0(
      "Negative values indicate undercoverage; ",
      "zero indicates nominal coverage."
    )
  }
  if (metric_name == "type1_error") {
    plot_data$value <- plot_data$value - 0.05
    legend_title <- "Type I error - 0.05"
    subtitle <- paste0(
      "Negative values indicate conservative tests; ",
      "zero indicates the nominal .05 rate."
    )
    caption <- paste0(
      "Type I error is defined only for parameters whose calibrated ",
      "population value is exactly zero."
    )
  }
  if (metric_name == "abs_rel_bias") {
    cap_value <- unname(
      stats::quantile(
        plot_data$value,
        probs = 0.95,
        na.rm = TRUE
      )
    )
    plot_data$value <- pmin(plot_data$value, cap_value)
    legend_title <- paste0(
      "|Relative/absolute bias|\n(clipped at ",
      round(cap_value, digits = 2),
      ")"
    )
    subtitle <- paste0(
      "To keep the heatmap readable, ",
      "the bias magnitude is clipped at the 95th percentile."
    )
    caption <- paste0(
      "For nonzero parameters, cells show absolute relative bias; ",
      "for zero parameters, cells show absolute bias. ",
      "The heatmap shows magnitude only, not direction."
    )
  }
  if (metric_name == "rmse") {
    cap_value <- unname(
      stats::quantile(
        plot_data$value,
        probs = 0.95,
        na.rm = TRUE
      )
    )
    plot_data$value <- pmin(plot_data$value, cap_value)
    legend_title <- paste0(
      "RMSE\n(clipped at ",
      round(cap_value, digits = 3),
      ")"
    )
    subtitle <- paste0(
      "To keep the heatmap readable, ",
      "RMSE is clipped at the 95th percentile."
    )
    caption <- paste0(
      "Smaller values are better. RMSE is on the original parameter scale, ",
      "so comparisons are most meaningful within parameter."
    )
  }
  list(
    data = plot_data,
    legend_title = legend_title,
    subtitle = subtitle,
    caption = caption
  )
}
