#' DSEM Recovery Over All and Over Converged Replications
#'
#' Bias, root mean square error, and coverage of the DSEM estimates in each
#' simulation condition, computed over all replications and over the
#' replications in which every parameter meets the moderate posterior-quality
#' criterion (finite diagnostics, \eqn{\hat{R} \leq 1.05},
#' bulk and tail ESS \eqn{\geq 100}, each MCSE/SD \eqn{\leq .10}).
#' The kept replications are a selected subset.
#'
#' @author Ivan Jacob Agaloos Pesigan
#'
#' @docType data
#' @name dsem_converged
#' @usage data(dsem_converged)
#' @format A data frame with one row per task ID, prior, and parameter:
#'
#' \describe{
#'   \item{taskid}{Simulation task ID.}
#'   \item{method}{`"BMLVAR-Default"` or `"BMLVAR-Priors"`.}
#'   \item{n}{Number of persons.}
#'   \item{time}{Number of measurement occasions; `NA` denotes the unbalanced
#'     condition.}
#'   \item{heterogeneity}{Transition-parameter heterogeneity multiplier.}
#'   \item{replications}{Number of replications.}
#'   \item{replications_kept}{Number of replications meeting the moderate
#'     criterion.}
#'   \item{parnames}{Parameter name.}
#'   \item{parameter}{Calibrated population value.}
#'   \item{bias_all, rmse_all, coverage_all}{Bias, root mean square error,
#'     and coverage of the 95 percent credible interval over all replications.}
#'   \item{bias_kept, rmse_kept, coverage_kept}{The same over the kept
#'     replications; `NA` when none is kept.}
#' }
#'
#' @keywords data diagnostics
"dsem_converged"
