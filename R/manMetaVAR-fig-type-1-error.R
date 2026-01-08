#' Plot Type 1 Error Rates
#'
#' Plot type 1 error rates for zero random effects.
#'
#' @author Ivan Jacob Agaloos Pesigan
#'
#' @inheritParams Template
#'
#' @examples
#' \dontrun{
#' data(results, package = "manMetaVAR")
#' FigType1Error(results)
#' }
#'
#' @family Figure Functions
#' @keywords manMetaVAR figure
#' @export
FigType1Error <- function(results,
                          dynamics = 1,
                          method = c(
                            "MetaVAR",
                            "SeqVAR",
                            "BMLVAR"
                          ),
                          parameters = "both",
                          ylim = c(0.00, 0.25),
                          x_lab_size = 7.5) {
  Method <- Parameters <- theta_hit <- NULL
  stopifnot(
    dynamics %in% 1:3
  )
  results <- results[which(results$dynamics == dynamics), ]
  results <- results[which(results$method %in% method), ]
  results <- results[which(results$parameter == 0), ]
  results$Method <- results$method
  results$Method <- paste0(
    results$Method,
    " (",
    results$ci,
    ")"
  )
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
      } * {}["" * 3 * "," * "" * 1]),
    expression(tau^
      {
        phantom(".") *
          {} * "" * 2
      } * {}["" * 4 * "," * "" * 1]),
    expression(tau^
      {
        phantom(".") *
          {} * "" * 2
      } * {}["" * 5 * "," * "" * 1]),
    expression(tau^
      {
        phantom(".") *
          {} * "" * 2
      } * {}["" * 6 * "," * "" * 1]),
    expression(tau^
      {
        phantom(".") *
          {} * "" * 2
      } * {}["" * 2 * "," * "" * 2]),
    expression(tau^
      {
        phantom(".") *
          {} * "" * 2
      } * {}["" * 3 * "," * "" * 2]),
    expression(tau^
      {
        phantom(".") *
          {} * "" * 2
      } * {}["" * 4 * "," * "" * 2]),
    expression(tau^
      {
        phantom(".") *
          {} * "" * 2
      } * {}["" * 5 * "," * "" * 2]),
    expression(tau^
      {
        phantom(".") *
          {} * "" * 2
      } * {}["" * 6 * "," * "" * 2]),
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
    results <- results[which(results$par_idx %in% 7:27), ]
  }
  idx <- sort(unique(results$par_idx))
  results$Parameters <- match(results$par_idx, idx)
  breaks <- seq_along(idx)
  labels <- labels[idx]
  ggplot2::ggplot(
    data = results,
    ggplot2::aes(
      x = Parameters,
      y = 1 - theta_hit,
      shape = Method,
      color = Method,
      group = Method,
      linetype = Method
    )
  ) +
    ggplot2::geom_hline(
      yintercept = 1 - 0.95,
      alpha = 0.5
    ) +
    ggplot2::geom_hline(
      yintercept = 1 - 0.925,
      alpha = 0.5
    ) +
    ggplot2::geom_hline(
      yintercept = 1 - 0.975,
      alpha = 0.5
    ) +
    ggplot2::annotate(
      geom = "rect",
      fill = "grey",
      alpha = 0.50,
      xmin = -Inf,
      xmax = Inf,
      ymin = 1 - 0.975,
      ymax = 1 - 0.925
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
      "Type 1 Error Rate"
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
