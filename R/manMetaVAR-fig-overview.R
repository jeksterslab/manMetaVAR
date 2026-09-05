#' Results Overview
#'
#' Plot results overview.
#'
#' @author Ivan Jacob Agaloos Pesigan
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
  max_value <- min_value <- metric <- heterogeneity_label <- NULL
  method_colors <- c(
    "MetaVAR" = "#1B9E77",
    "BMLVAR-Default" = "#7570B3",
    "BMLVAR-Priors" = "#E7298A",
    "Uncorr" = "#D95F02"
  )
  overview_summary <- .BuildOverviewData(
    results = results
  )
  coverage_benchmarks <- expand.grid(
    target = c(
      "FE", # "Fixed effects",
      "RE" # "Random effects"
    ),
    heterogeneity_label = levels(
      overview_summary$heterogeneity_label
    ),
    benchmark = seq_len(3L),
    KEEP.OUT.ATTRS = FALSE,
    stringsAsFactors = FALSE
  )
  coverage_benchmarks$metric <- "Coverage"
  coverage_benchmarks$xintercept <- c(
    0.92,
    0.95,
    0.97
  )[coverage_benchmarks$benchmark]
  coverage_benchmarks$line_type <- c(
    "dashed",
    "solid",
    "dashed"
  )[coverage_benchmarks$benchmark]
  coverage_benchmarks$heterogeneity_label <- factor(
    coverage_benchmarks$heterogeneity_label,
    levels = levels(overview_summary$heterogeneity_label)
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
      rows = ggplot2::vars(
        heterogeneity_label,
        target
      ),
      cols = ggplot2::vars(metric),
      scales = "free_x"
    ) +
    ggplot2::scale_color_manual(
      values = method_colors
    ) +
    ggplot2::labs(
      title = paste0(
        "Overall method performance across simulation design cells ",
        "and heterogeneity conditions"
      ),
      subtitle = paste0(
        "Points are means across design cells; ",
        "horizontal lines show the min-max range. ",
        "Coverage panels include ",
        "nominal .95 and Bradley's liberal .92-.97 band."
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
    ) ~ method + target + heterogeneity_label + taskid,
    data = results,
    FUN = function(x) {
      if (all(is.na(x))) {
        NA_real_
      } else {
        mean(x, na.rm = TRUE)
      }
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
      "|Relative/absolute bias|",
      "RMSE",
      "Coverage",
      "Power"
    )
  )
  group <- interaction(
    overview_by_cell$method,
    overview_by_cell$target,
    overview_by_cell$heterogeneity_label,
    overview_by_cell$metric,
    drop = TRUE
  )
  split_data <- split(
    overview_by_cell,
    group,
    drop = TRUE
  )
  safe_summary <- function(x,
                           fun) {
    x <- x[is.finite(x)]
    if (length(x) == 0L) {
      NA_real_
    } else {
      fun(x)
    }
  }
  overview_summary <- do.call(
    what = "rbind",
    args = lapply(
      X = split_data,
      FUN = function(x) {
        data.frame(
          method = as.character(x$method[1]),
          target = as.character(x$target[1]),
          heterogeneity_label = as.character(
            x$heterogeneity_label[1]
          ),
          metric = as.character(x$metric[1]),
          mean_value = safe_summary(x$value, mean),
          min_value = safe_summary(x$value, min),
          max_value = safe_summary(x$value, max),
          stringsAsFactors = FALSE
        )
      }
    )
  )
  rownames(overview_summary) <- NULL
  overview_summary$method <- factor(
    overview_summary$method,
    levels = levels(overview_by_cell$method)
  )
  overview_summary$target <- factor(
    overview_summary$target,
    levels = levels(overview_by_cell$target)
  )
  overview_summary$heterogeneity_label <- factor(
    overview_summary$heterogeneity_label,
    levels = levels(overview_by_cell$heterogeneity_label)
  )
  overview_summary$metric <- factor(
    overview_summary$metric,
    levels = levels(overview_by_cell$metric)
  )
  overview_summary
}
