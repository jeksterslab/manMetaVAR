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
  mean_value <- method <- min_value <- max_value <- NULL
  metric <- heterogeneity_label <- target <- xintercept <- NULL

  summary <- .BuildOverviewData(results)

  references <- expand.grid(
    target = levels(summary$target),
    heterogeneity_label = levels(summary$heterogeneity_label),
    metric = c(
      "Coverage",
      "Zero-target exclusion"
    ),
    stringsAsFactors = FALSE
  )

  references$xintercept <- ifelse(
    references$metric == "Coverage",
    .95,
    .05
  )

  ggplot2::ggplot(
    summary,
    ggplot2::aes(
      x = mean_value,
      y = method,
      color = method
    )
  ) +
    ggplot2::geom_vline(
      data = references,
      ggplot2::aes(
        xintercept = xintercept
      ),
      inherit.aes = FALSE,
      color = "grey55",
      linewidth = .4
    ) +
    ggplot2::geom_segment(
      ggplot2::aes(
        x = min_value,
        xend = max_value,
        yend = method
      ),
      linewidth = .8,
      alpha = .8,
      na.rm = TRUE
    ) +
    ggplot2::geom_point(
      size = 2.5,
      na.rm = TRUE
    ) +
    ggplot2::facet_grid(
      ggplot2::vars(
        heterogeneity_label,
        target
      ),
      ggplot2::vars(metric),
      drop = FALSE,
      labeller = ggplot2::labeller(
        target = c(
          "Fixed effects" = "Means",
          "Random variances" = "Variances",
          "Random covariances" = "Covariances"
        )
      )
    ) +
    ggplot2::scale_x_continuous(
      limits = c(0, 1),
      breaks = c(
        0,
        .5,
        1
      )
    ) +
    ggplot2::scale_color_manual(
      values = c(
        "MetaVAR" = "#1B9E77",
        "BMLVAR-Default" = "#7570B3",
        "BMLVAR-Priors" = "#E7298A",
        "Uncorr" = "#D95F02"
      ),
      labels = c(
        "MetaVAR",
        "Mplus DSEM: default",
        "Mplus DSEM: alternative",
        "Uncorr"
      )
    ) +
    ggplot2::scale_y_discrete(
      labels = c(
        "MetaVAR" = "MetaVAR",
        "BMLVAR-Default" = "DSEM default",
        "BMLVAR-Priors" = "DSEM alternative",
        "Uncorr" = "Uncorr"
      )
    ) +
    ggplot2::labs(
      title = paste(
        "Interval performance by target and transition",
        "heterogeneity"
      ),
      subtitle = paste(
        "Equal weight per parameter within each task;",
        "equal weight per task. Points: means;",
        "lines: task min-max."
      ),
      caption = paste(
        paste(
          "Primary conditional performance; counts and",
          "posterior quality are reported separately.\n"
        ),
        paste(
          "Missing panels have no eligible targets.",
          "Zero variance credible-interval exclusion is",
          "not a calibrated test.\n"
        ),
        paste(
          "Reference lines: .95 coverage and .05 zero",
          "exclusion; no benchmark for nonzero detection."
        )
      ),
      x = NULL,
      y = NULL,
      color = "Method"
    ) +
    .FigTheme(base_size = 11)
}

.BuildOverviewCellData <- function(results) {
  x <- .FigPreprocess(results)

  x$overview_target <- ifelse(
    grepl(
      "^alpha",
      x$parnames
    ),
    "Fixed effects",
    ifelse(
      grepl(
        "^tau_sqr\\[([0-9]+),\\1\\]$",
        x$parnames
      ),
      "Random variances",
      "Random covariances"
    )
  )

  groups <- split(
    x,
    interaction(
      x$method,
      x$overview_target,
      x$heterogeneity_label,
      x$taskid,
      drop = TRUE
    )
  )

  out <- lapply(
    groups,
    function(d) {
      do.call(
        rbind,
        lapply(
          c(
            "Coverage",
            "Nonzero detection",
            "Zero-target exclusion"
          ),
          function(metric) {
            eligible <- switch(metric,
              "Coverage" = rep(
                TRUE,
                nrow(d)
              ),
              "Nonzero detection" = d$parameter != 0,
              "Zero-target exclusion" = d$parameter == 0
            )

            values <- switch(metric,
              "Coverage" = d$coverage,
              "Nonzero detection" = d$power,
              "Zero-target exclusion" = d$type1_error
            )

            values <- values[
              eligible & is.finite(values)
            ]

            data.frame(
              method = as.character(
                d$method[1]
              ),
              target = d$overview_target[1],
              heterogeneity_label = as.character(
                d$heterogeneity_label[1]
              ),
              taskid = d$taskid[1],
              metric = metric,
              value = if (length(values)) {
                mean(values)
              } else {
                NA_real_
              },
              n_parameters = length(values),
              stringsAsFactors = FALSE
            )
          }
        )
      )
    }
  )

  out <- do.call(
    rbind,
    out
  )

  rownames(out) <- NULL

  out$method <- factor(
    out$method,
    levels = levels(x$method)
  )

  out$target <- factor(
    out$target,
    levels = c(
      "Fixed effects",
      "Random variances",
      "Random covariances"
    )
  )

  out$heterogeneity_label <- factor(
    out$heterogeneity_label,
    levels = levels(x$heterogeneity_label)
  )

  out$metric <- factor(
    out$metric,
    levels = c(
      "Coverage",
      "Nonzero detection",
      "Zero-target exclusion"
    )
  )

  out
}

.BuildOverviewData <- function(results) {
  cells <- .BuildOverviewCellData(results)

  groups <- split(
    cells,
    interaction(
      cells$method,
      cells$target,
      cells$heterogeneity_label,
      cells$metric,
      drop = TRUE
    )
  )

  out <- do.call(
    rbind,
    lapply(
      groups,
      function(d) {
        v <- d$value[
          is.finite(d$value)
        ]

        data.frame(
          method = as.character(
            d$method[1]
          ),
          target = as.character(
            d$target[1]
          ),
          heterogeneity_label = as.character(
            d$heterogeneity_label[1]
          ),
          metric = as.character(
            d$metric[1]
          ),
          mean_value = if (length(v)) {
            mean(v)
          } else {
            NA_real_
          },
          min_value = if (length(v)) {
            min(v)
          } else {
            NA_real_
          },
          max_value = if (length(v)) {
            max(v)
          } else {
            NA_real_
          },
          n_design_cells = length(v),
          n_parameter_cells = sum(
            d$n_parameters
          ),
          stringsAsFactors = FALSE
        )
      }
    )
  )

  rownames(out) <- NULL

  for (
    n in c(
      "method",
      "target",
      "heterogeneity_label",
      "metric"
    )
  ) {
    out[[n]] <- factor(
      out[[n]],
      levels = levels(cells[[n]])
    )
  }

  out
}
