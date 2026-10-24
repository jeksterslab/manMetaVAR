#' Tolerance Rates for Transition Heterogeneity
#'
#' Proportions of replications in which the estimate or interval of a
#' between-person variance or covariance of the transition parameters falls
#' within or beyond a tolerance \eqn{\delta}, computed with [SumTolerance()]
#' from the replication-level simulation summaries.
#'
#' @author Ivan Jacob Agaloos Pesigan
#'
#' @docType data
#' @name tolerance_rates
#' @usage data(tolerance_rates)
#' @format A data frame with one row per design condition, method, interval
#'   type, parameter, and tolerance:
#'
#' \describe{
#'   \item{taskid}{Simulation task ID.}
#'   \item{replications}{Number of replications.}
#'   \item{replications_used}{Number of admissible replications.}
#'   \item{method}{Estimation method, labeled as in [results].}
#'   \item{ci}{Confidence or credible interval method.}
#'   \item{n}{Number of persons.}
#'   \item{time}{Number of measurement occasions; `NA` denotes the unbalanced
#'     condition.}
#'   \item{heterogeneity}{Transition-parameter heterogeneity multiplier: 0, 1,
#'     or 2.}
#'   \item{parnames}{Parameter name.}
#'   \item{parameter}{Population value.}
#'   \item{type}{`"variance"` or `"covariance"`.}
#'   \item{delta}{Tolerance.}
#'   \item{est_within}{Proportion of estimates within the tolerance.}
#'   \item{equivalent}{Proportion of intervals within the tolerance
#'     (practical homogeneity).}
#'   \item{exceed}{Proportion of intervals beyond the tolerance
#'     (heterogeneity beyond the tolerance).}
#' }
#'
#' @keywords data results
"tolerance_rates"
