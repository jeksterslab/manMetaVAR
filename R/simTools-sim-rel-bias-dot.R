#' Relative Bias
#'
#' Calculates relative bias if parameter is not equal to zero.
#' Returns `NA_real_` otherwise because relative bias is undefined at zero.
#'
#' @author Ivan Jacob Agaloos Pesigan
#'
#' @return Returns a numeric vector.
#'
#' @param thetahat Numeric vector.
#'   Estimates.
#' @param theta Numeric vector.
#'   Parameters.
#'
#' @family Simulation Helper Functions
#' @keywords simTools internal
#' @noRd
.SimRelBias <- function(thetahat,
                        theta) {
  ifelse(
    test = theta == 0,
    yes = NA_real_,
    no = (thetahat - theta) / theta
  )
}
