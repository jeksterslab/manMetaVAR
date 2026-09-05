#' Population Parameters for the Four-Variable Summary
#'
#' @param heterogeneity Numeric scalar.
#' @param population_object Four-variable population data object.
#'
#' @return A named numeric vector containing the fixed effects and the
#'   diagonal random-effect variances estimated by the four-variable models.
#'
#' @keywords manMetaVAR summary simulation internal
#' @noRd
.SumPopulationParameterK4 <- function(heterogeneity,
                                      population_object = populationk4) {
  condition <- .SumPopulationCondition(
    heterogeneity = heterogeneity,
    population_object = population_object
  )
  fixed <- condition$ma_fixed
  random <- condition$ma_random
  if (
    !is.numeric(fixed) ||
      any(!is.finite(fixed)) ||
      !is.matrix(random) ||
      nrow(random) != length(fixed) ||
      ncol(random) != length(fixed) ||
      any(!is.finite(random))
  ) {
    stop(
      "The four-variable population condition is not well formed.",
      call. = FALSE
    )
  }
  p <- length(fixed)
  parameter <- c(
    fixed,
    diag(random)
  )
  names(parameter) <- c(
    paste0(
      "alpha[",
      seq_len(p),
      ",1]"
    ),
    paste0(
      "tau_sqr[",
      seq_len(p),
      ",",
      seq_len(p),
      "]"
    )
  )
  parameter
}
