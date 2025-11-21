#' Plot Relative Bias
#'
#' Plot relative bias for the fixed and random effects.
#'
#' @author Ivan Jacob Agaloos Pesigan
#'
#' @inheritParams Template
#'
#' @examples
#' \dontrun{
#' data(results, package = "manMetaVAR")
#' FigBias(results)
#' }
#'
#' @family Figure Functions
#' @keywords manMetaVAR figure
#' @export
FigBias <- function(results,
                    bias = TRUE,
                    dynamics = 1,
                    method = c(
                      "MetaVAR",
                      "SeqVAR",
                      "BMLVAR"
                    ),
                    zero = FALSE,
                    ylim = c(-0.15, 0.15)) {
  Method <- Parameters <- y <- NULL
  stopifnot(
    dynamics %in% 1:3
  )
  results <- results[which(results$dynamics == dynamics), ]
  results <- results[which(results$method %in% method), ]
  if (zero) {
    results <- results[which(abs(results$parameter) > 0), ]
  }
  # remove lb
  results <- results[which(results$ci != "LB"), ]
  results$Method <- results$method
  results$Parameters <- results$par_idx
  results$n_label <- paste0(
    "N = ",
    results$n
  )
  results$n_label <- factor(
    results$n_label,
    levels = c(
      paste0(
        "N = ",
        sort(unique(results$n))
      )
    )
  )
  results$t_label <- paste0(
    "T = ",
    results$time
  )
  results$t_label <- factor(
    results$t_label,
    levels = c(
      paste0(
        "T = ",
        sort(unique(results$time))
      )
    )
  )
  if (bias) {
    results$y <- results$bias
    ylab <- "Bias"
  } else {
    results$y <- results$rel_bias
    ylab <- "Relative Bias"
  }
  ggplot2::ggplot(
    data = results,
    ggplot2::aes(
      x = Parameters,
      y = y,
      shape = Method,
      color = Method,
      group = Method,
      linetype = Method
    )
  ) +
    ggplot2::geom_hline(
      yintercept = 0.0,
      alpha = 0.5
    ) +
    ggplot2::geom_hline(
      yintercept = 0.10,
      alpha = 0.5
    ) +
    ggplot2::geom_hline(
      yintercept = -0.10,
      alpha = 0.5
    ) +
    ggplot2::annotate(
      geom = "rect",
      fill = "grey",
      alpha = 0.50,
      xmin = -Inf,
      xmax = Inf,
      ymin = -0.10,
      ymax = 0.10
    ) +
    ggplot2::geom_point(
      na.rm = TRUE
    ) +
    ggplot2::geom_line(
      na.rm = TRUE
    ) +
    ggplot2::facet_grid(
      n_label ~ t_label
    ) +
    ggplot2::xlab(
      "Parameter No."
    ) +
    ggplot2::ylab(
      ylab
    ) +
    ggplot2::coord_cartesian(
      ylim = ylim
    ) +
    ggplot2::scale_x_continuous(
      breaks = sort(unique(results$par_idx))
    ) +
    ggplot2::theme_bw() +
    ggplot2::scale_color_brewer(palette = "Set1") +
    ggplot2::scale_shape()
}
