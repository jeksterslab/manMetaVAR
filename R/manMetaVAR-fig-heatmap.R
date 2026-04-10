#' Results Heatmap
#'
#' Plot results heatmap.
#'
#' @author Anonymous
#'
#' @param metric_name Character string.
#'   `"coverage"` for coverage probability,
#'   `"abs_rel_bias"` for absolute value of the relative bias,
#'   `"rmse"` for RMSE, and
#'   `"power"` for statistical power.
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
  condition_label <- parameter_label <- NULL
  value <- value_label <- text_colour <- NULL
  metric_data <- .BuildMetricHeatmapData(
    results = results,
    metric_name = metric_name
  )
  plot_data <- metric_data$data
  use_diverging_scale <- metric_name == "coverage"
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
    "coverage" = "Coverage heatmap by parameter, design cell, and method",
    "abs_rel_bias" = paste0(
      "Absolute value of the relative bias heatmap by parameter, ",
      "design cell, and method"
    ),
    "rmse" = "RMSE heatmap by parameter, design cell, and method",
    "power" = "Power heatmap by parameter, design cell, and method"
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
  heatmap_plot <- heatmap_plot +
    ggplot2::facet_grid(
      rows = ggplot2::vars(target),
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
  heatmap_plot
}

.BuildMetricHeatmapData <- function(results,
                                    metric_name) {
  results <- .FigPreprocess(
    results = results
  )
  plot_data <- results[
    c(
      "method",
      "target",
      "condition_label",
      "parameter_label",
      metric_name
    )
  ]
  names(plot_data)[
    names(plot_data) == metric_name
  ] <- "value"
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
  if (metric_name == "abs_rel_bias") {
    cap_value <- unname(
      stats::quantile(
        x = plot_data$value,
        probs = 0.95,
        na.rm = TRUE
      )
    )
    plot_data$value <- pmin(
      plot_data$value,
      cap_value
    )
    legend_title <- paste0(
      "|Relative bias|\n(clipped at ",
      round(
        x = cap_value,
        digits = 2
      ),
      ")"
    )
    subtitle <- paste0(
      "To keep the heatmap readable, ",
      "absolute value of the relative bias is clipped at the 95th percentile."
    )
    caption <- paste0(
      "Smaller values are better. ",
      "The heatmap shows magnitude only, not direction."
    )
  }
  if (metric_name == "rmse") {
    cap_value <- unname(
      stats::quantile(
        x = plot_data$value,
        probs = 0.95,
        na.rm = TRUE
      )
    )
    plot_data$value <- pmin(
      plot_data$value,
      cap_value
    )
    legend_title <- paste0(
      "RMSE\n(clipped at ",
      round(
        x = cap_value,
        digits = 3
      ),
      ")"
    )
    subtitle <- paste0(
      "To keep the heatmap readable, RMSE is clipped at the 95th percentile."
    )
    caption <- paste0(
      "Smaller values are better. ",
      "RMSE is on the original parameter scale, ",
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
