#' Calibrated Four-Variable Population Parameters
#'
#' Population moments implied by the stationary transition-matrix generator
#' for the four-variable VAR(1) simulation condition. The moments of the set
#' points are analytical. The moments of the transition matrices are calculated
#' by Monte Carlo integration over the stationary region for each nonzero
#' heterogeneity condition.
#'
#' @author Ivan Jacob Agaloos Pesigan
#'
#' @docType data
#' @name populationk4
#' @usage data(populationk4)
#' @format A list with two elements:
#'
#' \describe{
#'   \item{conditions}{
#'     Named list indexed by heterogeneity. Each element contains the calibrated
#'     means and covariance matrices, a named population parameter vector, and
#'     Monte Carlo calibration information for the four-variable model.
#'   }
#'   \item{calibration}{
#'     Metadata describing the generator, package version, random seed,
#'     population size, batch size, stationarity margin, and generation time.
#'   }
#' }
#'
#' @keywords data parameters
"populationk4"
