#' Results Overview
#'
#' Plot results overview.
#'
#' @author Anonymous
#'
#' @inheritParams Template
#'
#' @examples
#' \dontrun{
#' data(results, package = "manMetaVAR")
#' FigOverview(results)
#' }
#'
#' @family Figure Functions
#' @keywords manMetaVAR figure
#' @export
FigOverview <- function(results) {
  method <- target <- NULL
  line_type <- xintercept <- mean_value <- NULL
  max_value <- min_value <- metric <- NULL
  method_colors <- c(
    "MetaVAR" = "#1B9E77",
    "BMLVAR" = "#7570B3",
    "Uncorr" = "#D95F02"
  )
  overview_summary <- .BuildOverviewData(
    results = results
  )
  coverage_benchmarks <- data.frame(
    target = rep(
      c(
        "Fixed effects",
        "Random effects"
      ),
      each = 3L
    ),
    metric = rep(
      "Coverage",
      times = 6L
    ),
    xintercept = rep(
      c(
        0.92,
        0.95,
        0.97
      ),
      times = 2L
    ),
    line_type = rep(
      c(
        "dashed",
        "solid",
        "dashed"
      ),
      times = 2L
    ),
    stringsAsFactors = FALSE
  )
  overview_plot <- ggplot2::ggplot(
    data = overview_summary,
    mapping = ggplot2::aes(
      x = mean_value,
      y = method,
      color = method
    )
  ) +
    ggplot2::geom_vline(
      data = coverage_benchmarks,
      mapping = ggplot2::aes(
        xintercept = xintercept,
        linetype = line_type
      ),
      inherit.aes = FALSE,
      color = "grey55",
      linewidth = 0.4,
      show.legend = FALSE
    ) +
    ggplot2::geom_segment(
      mapping = ggplot2::aes(
        x = min_value,
        xend = max_value,
        y = method,
        yend = method
      ),
      linewidth = 0.8,
      alpha = 0.8
    ) +
    ggplot2::geom_point(size = 2.6) +
    ggplot2::facet_grid(
      rows = ggplot2::vars(target),
      cols = ggplot2::vars(metric),
      scales = "free_x"
    ) +
    ggplot2::scale_color_manual(
      values = method_colors
    ) +
    ggplot2::labs(
      title = "Overall method performance across simulation design cells",
      subtitle = paste0(
        "Points are means across design cells; ",
        "horizontal lines show the min-max range. ",
        "Coverage panels include ",
        "nominal .95 and Bradley's liberal .92-.97 band. "
      ),
      x = NULL,
      y = NULL,
      color = "Method"
    ) +
    .FigTheme(base_size = 11)
  overview_plot
}

.BuildOverviewData <- function(results) {
  results <- .FigPreprocess(
    results = results
  )
  overview_by_cell <- stats::aggregate(
    cbind(
      abs_rel_bias,
      rmse,
      coverage,
      power
    ) ~ method + target + taskid,
    data = results,
    FUN = function(x) {
      mean(x, na.rm = TRUE)
    }
  )
  overview_by_cell <- stats::reshape(
    overview_by_cell,
    varying = c(
      "abs_rel_bias",
      "rmse",
      "coverage",
      "power"
    ),
    v.names = "value",
    timevar = "metric",
    times = c(
      "abs_rel_bias",
      "rmse",
      "coverage",
      "power"
    ),
    direction = "long"
  )
  rownames(overview_by_cell) <- NULL
  overview_by_cell$metric <- factor(
    overview_by_cell$metric,
    levels = c(
      "abs_rel_bias",
      "rmse",
      "coverage",
      "power"
    ),
    labels = c(
      "|Relative bias|",
      "RMSE",
      "Coverage",
      "Power"
    )
  )
  split_data <- split(
    overview_by_cell$value,
    list(
      overview_by_cell$method,
      overview_by_cell$target,
      overview_by_cell$metric
    ),
    drop = TRUE
  )
  split_names <- strsplit(names(split_data), "\\.")
  split_names <- do.call(rbind, split_names)
  overview_summary <- data.frame(
    method = split_names[, 1],
    target = split_names[, 2],
    metric = split_names[, 3],
    mean_value = sapply(
      X = split_data,
      FUN = function(x) {
        mean(x, na.rm = TRUE)
      }
    ),
    min_value = sapply(
      X = split_data,
      FUN = function(x) {
        min(x, na.rm = TRUE)
      }
    ),
    max_value = sapply(
      X = split_data,
      FUN = function(x) {
        max(x, na.rm = TRUE)
      }
    ),
    row.names = NULL
  )
  overview_summary$metric <- factor(
    overview_summary$metric,
    levels = levels(
      overview_by_cell$metric
    )
  )
  overview_summary
}
