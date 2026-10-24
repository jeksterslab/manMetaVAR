#' Tolerance Decisions for Between-Person Variances and Covariances
#'
#' Classifies estimates and interval limits of between-person variances and
#' covariances against a tolerance \eqn{\delta} instead of exact zero.
#' Variances are compared one-sided with \eqn{\delta};
#' covariances two-sided with \eqn{[-\delta, \delta]}.
#'
#' @author Ivan Jacob Agaloos Pesigan
#'
#' @param est Numeric vector. Estimates.
#' @param ll Numeric vector. Lower interval limits.
#' @param ul Numeric vector. Upper interval limits.
#' @param variance Logical vector.
#'   `TRUE` for variances, `FALSE` for covariances.
#' @param delta Nonnegative numeric value. Tolerance.
#'
#' @return A data frame with logical columns
#'   `est_within` (estimate within the tolerance),
#'   `equivalent` (interval within the tolerance:
#'   practical homogeneity), and
#'   `exceed` (interval beyond the tolerance:
#'   heterogeneity beyond the tolerance).
#'
#' @examples
#' Tolerance(
#'   est = c(0.0002, 0.01),
#'   ll = c(0, 0.004),
#'   ul = c(0.0008, 0.02),
#'   variance = c(TRUE, TRUE),
#'   delta = 0.0009
#' )
#'
#' @keywords manMetaVAR summary simulation
#' @export
Tolerance <- function(est,
                      ll,
                      ul,
                      variance,
                      delta) {
  stopifnot(
    length(delta) == 1L,
    is.numeric(delta),
    delta >= 0
  )
  data.frame(
    est_within = ifelse(
      test = variance,
      yes = est <= delta,
      no = abs(est) <= delta
    ),
    equivalent = ifelse(
      test = variance,
      yes = ul <= delta,
      no = ll >= -delta & ul <= delta
    ),
    exceed = ifelse(
      test = variance,
      yes = ll > delta,
      no = ll > delta | ul < -delta
    )
  )
}
