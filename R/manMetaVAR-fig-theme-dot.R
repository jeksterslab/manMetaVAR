.FigTheme <- function(base_size = 11) {
  ggplot2::theme_bw(base_size = base_size) +
    ggplot2::theme(
      panel.grid.major = ggplot2::element_blank(),
      panel.grid.minor = ggplot2::element_blank(),
      strip.background = ggplot2::element_rect(
        fill = "grey92"
      ),
      legend.position = "bottom",
      legend.title = ggplot2::element_text(
        face = "bold"
      ),
      axis.text.y = ggplot2::element_text(
        size = base_size - 3L
      ),
      axis.text.x = ggplot2::element_text(
        angle = 45,
        hjust = 1,
        size = base_size - 3L
      ),
      plot.title = ggplot2::element_text(
        face = "bold"
      ),
      plot.subtitle = ggplot2::element_text(
        size = base_size - 1L
      )
    )
}
