#' Boundary Likelihood Ratio Test in the Simulation
#'
#' Rejection rates of the MetaVAR boundary likelihood ratio test
#' ([LRTMetaVAR()]) of zero transition heterogeneity in each simulation
#' condition, at \eqn{\alpha = .05}, with the simulated chi-bar-square and
#' the naive chi-square references.
#' At zero heterogeneity, the rejection rates are Type I error rates;
#' otherwise, they are power.
#'
#' @author Ivan Jacob Agaloos Pesigan
#'
#' @docType data
#' @name lrt
#' @usage data(lrt)
#' @format A data frame with one row per task ID:
#'
#' \describe{
#'   \item{taskid}{Simulation task ID.}
#'   \item{replications}{Number of replications.}
#'   \item{replications_used}{Number of admissible MetaVAR replications.}
#'   \item{method}{`"MetaVAR"`.}
#'   \item{n}{Number of persons.}
#'   \item{time}{Number of measurement occasions; `NA` denotes the unbalanced
#'     condition.}
#'   \item{heterogeneity}{Transition-parameter heterogeneity multiplier.}
#'   \item{df}{Number of tested parameters.}
#'   \item{negative_stat}{Number of replications with a statistic below
#'     \eqn{-10^{-6}}.}
#'   \item{null_status_nonzero}{Number of replications whose null fit had a
#'     nonzero status code.}
#'   \item{reject_chibar}{Rejection rate with the chi-bar-square reference.}
#'   \item{reject_chisq}{Rejection rate with the chi-square reference.}
#'   \item{crit_chibar}{Median simulated 95th percentile of the
#'     chi-bar-square reference.}
#' }
#'
#' @keywords data results
"lrt"
