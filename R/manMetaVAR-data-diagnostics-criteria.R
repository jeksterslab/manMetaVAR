#' DSEM Posterior-Quality Failure Rates Under Three Criteria
#'
#' Proportions of DSEM replications that fail the posterior-quality criteria,
#' by parameter group and prior, computed with [TabMplusDiagSensitivity()]
#' under strict (\eqn{\hat{R} \leq 1.01}, ESS \eqn{\geq 400},
#' MCSE/SD \eqn{\leq .05}), moderate (\eqn{\hat{R} \leq 1.05},
#' ESS \eqn{\geq 100}, MCSE/SD \eqn{\leq .10}), and lenient
#' (\eqn{\hat{R} \leq 1.10}, ESS \eqn{\geq 100}) criteria.
#'
#' @author Ivan Jacob Agaloos Pesigan
#'
#' @docType data
#' @name diagnostics_criteria
#' @usage data(diagnostics_criteria)
#' @format A data frame with one row per design condition and criterion:
#'
#' \describe{
#'   \item{taskid}{Simulation task ID.}
#'   \item{case_label}{Design-condition label.}
#'   \item{n}{Number of persons.}
#'   \item{time}{Number of measurement occasions; `NA` denotes the unbalanced
#'     condition.}
#'   \item{heterogeneity}{Transition-parameter heterogeneity multiplier.}
#'   \item{Innovation covariance | Default, Innovation covariance | User,
#'     Fixed effects | Default, Fixed effects | User,
#'     Random effects | Default, Random effects | User}{Proportion of
#'     replications failing the criterion, by parameter group and prior.}
#'   \item{criterion}{`"strict"`, `"moderate"`, or `"lenient"`.}
#'   \item{rhat_threshold, ess_threshold, mcse_threshold}{Thresholds of the
#'     criterion.}
#' }
#'
#' @keywords data diagnostics
"diagnostics_criteria"
