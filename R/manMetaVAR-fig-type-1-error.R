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
                          )) {
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
    ggplot2::scale_x_continuous(
      breaks = sort(unique(results$par_idx))
    ) +
    ggplot2::theme_bw() +
    ggplot2::scale_color_brewer(palette = "Set1") +
    ggplot2::scale_shape()
}
