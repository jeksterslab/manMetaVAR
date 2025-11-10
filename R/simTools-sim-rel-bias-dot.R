#' Relative Bias
#'
#' Calculates relative bias if parameter is not equal to zero.
#' Returns `-999.999` otherwise.
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
    yes = -999.999,
    no = (thetahat - theta) / theta
  )
}
