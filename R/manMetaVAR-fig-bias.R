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
                    bias = FALSE,
                    method = c(
                      "BMLVAR",
                      "MetaVAR",
                      "Naive"
                    ),
                    parameters = "both",
                    ylim = c(-0.15, 0.15),
                    x_lab_size = 6) {
  Method <- Parameters <- y <- NULL
  results <- results[which(results$method %in% method), ]
  results <- results[which(results$ci %in% c("Posterior", "Normal")), ]
  results$Method <- results$method
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
  results$time <- ifelse(
    test = is.na(results$time),
    yes = "Unbalanced",
    no = results$time
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
  results$t_label <- factor(
    results$t_label,
    levels = c(
      "T = 50",
      "T = 100",
      "T = 200",
      "T = Unbalanced"
    ),
    ordered = TRUE
  )
  if (bias) {
    results$y <- results$bias
    ylab <- "Bias"
  } else {
    results$y <- results$rel_bias
    ylab <- "Relative Bias"
  }
  # nolint start
  labels <- c(
    expression(alpha * phantom(".") * {}["" * 1 * "," * "" * 1]),
    expression(alpha * phantom(".") * {}["" * 2 * "," * "" * 1]),
    expression(alpha * phantom(".") * {}["" * 3 * "," * "" * 1]),
    expression(alpha * phantom(".") * {}["" * 4 * "," * "" * 1]),
    expression(alpha * phantom(".") * {}["" * 5 * "," * "" * 1]),
    expression(alpha * phantom(".") * {}["" * 6 * "," * "" * 1]),
    expression(tau^
      {
        phantom(".") *
          {} * "" * 2
      } * {}["" * 1 * "," * "" * 1]),
    expression(tau^
      {
        phantom(".") *
          {} * "" * 2
      } * {}["" * 2 * "," * "" * 1]),
    expression(tau^
      {
        phantom(".") *
          {} * "" * 2
      } * {}["" * 2 * "," * "" * 2]),
    expression(tau^
      {
        phantom(".") *
          {} * "" * 2
      } * {}["" * 3 * "," * "" * 3]),
    expression(tau^
      {
        phantom(".") *
          {} * "" * 2
      } * {}["" * 4 * "," * "" * 3]),
    expression(tau^
      {
        phantom(".") *
          {} * "" * 2
      } * {}["" * 5 * "," * "" * 3]),
    expression(tau^
      {
        phantom(".") *
          {} * "" * 2
      } * {}["" * 6 * "," * "" * 3]),
    expression(tau^
      {
        phantom(".") *
          {} * "" * 2
      } * {}["" * 4 * "," * "" * 4]),
    expression(tau^
      {
        phantom(".") *
          {} * "" * 2
      } * {}["" * 5 * "," * "" * 4]),
    expression(tau^
      {
        phantom(".") *
          {} * "" * 2
      } * {}["" * 6 * "," * "" * 4]),
    expression(tau^
      {
        phantom(".") *
          {} * "" * 2
      } * {}["" * 5 * "," * "" * 5]),
    expression(tau^
      {
        phantom(".") *
          {} * "" * 2
      } * {}["" * 6 * "," * "" * 5]),
    expression(tau^
      {
        phantom(".") *
          {} * "" * 2
      } * {}["" * 6 * "," * "" * 6])
  )
  # nolint end
  if (parameters == "fixed") {
    results <- results[which(results$par_idx %in% 1:6), ]
  }
  if (parameters == "random") {
    results <- results[which(results$par_idx %in% 7:19), ]
  }
  idx <- sort(unique(results$par_idx))
  results$Parameters <- match(results$par_idx, idx)
  breaks <- seq_along(idx)
  labels <- labels[idx]
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
      "Parameter"
    ) +
    ggplot2::ylab(
      ylab
    ) +
    ggplot2::coord_cartesian(
      ylim = ylim
    ) +
    ggplot2::scale_x_continuous(
      breaks = breaks,
      labels = labels
    ) +
    ggplot2::theme_bw() +
    ggplot2::theme(
      axis.text.x = ggplot2::element_text(
        angle = 270,
        vjust = 0.5,
        hjust = 0,
        size = x_lab_size
      )
    ) +
    ggplot2::scale_color_brewer(palette = "Set1") +
    ggplot2::scale_shape()
}
