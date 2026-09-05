#' Simulation Results (k = 4)
#'
#' @author Ivan Jacob Agaloos Pesigan
#'
#' @docType data
#' @name resultsk4
#' @usage data(resultsk4)
#' @format A data frame with one row per design condition, method, interval
#'   type, and parameter:
#'
#' \describe{
#'   \item{taskid}{Simulation task ID.}
#'   \item{replications}{Number of replications.}
#'   \item{replications_used}{Number of admissible replications contributing to
#'     the summary.}
#'   \item{success_rate}{Proportion of requested replications that were
#'     admissible and contributed to the summary.}
#'   \item{parnames}{Parameter name.}
#'   \item{parameter}{Calibrated population parameter value. For transition
#'     parameters under stability rejection, this is the realized truncated
#'     population value rather than the nominal untruncated value.}
#'   \item{method}{Estimation method: MetaVAR, BMLVAR with default priors,
#'     BMLVAR with user-defined priors, or the uncertainty-uncorrected method.}
#'   \item{n}{Number of persons.}
#'   \item{time}{Number of measurement occasions; `NA` denotes the unbalanced
#'     condition.}
#'   \item{heterogeneity}{Transition-parameter heterogeneity multiplier: 0, 1,
#'     or 2.}
#'   \item{ci}{Confidence or credible interval method.}
#'   \item{est}{Mean parameter estimate.}
#'   \item{se}{Mean standard error or posterior standard deviation.}
#'   \item{z}{Mean test statistic when available.}
#'   \item{p}{Mean p-value when available.}
#'   \item{ll}{Mean lower interval limit.}
#'   \item{ul}{Mean upper interval limit.}
#'   \item{sig}{Proportion statistically significant when available.}
#'   \item{zero_hit}{Proportion of intervals containing zero.}
#'   \item{theta_hit}{Proportion of intervals containing the calibrated
#'     population value.}
#'   \item{sq_error}{Mean squared error.}
#'   \item{bias}{Mean estimate minus the calibrated population value.}
#'   \item{rel_bias}{Relative bias for nonzero population values and `NA` when
#'     the population value is zero.}
#'   \item{rmse}{Root mean squared error.}
#'   \item{n_bias}{Number of finite replication-level bias values used to
#'     calculate the Monte Carlo standard error of bias.}
#'   \item{n_rmse}{Number of finite replication-level squared errors used to
#'     calculate the Monte Carlo standard error of RMSE.}
#'   \item{n_coverage}{Number of finite coverage indicators used to calculate
#'     the Monte Carlo standard error of coverage.}
#'   \item{n_rejection}{Number of finite rejection indicators used to
#'     calculate the Monte Carlo standard error of the rejection rate.}
#'   \item{mcse_bias}{Monte Carlo standard error of bias.}
#'   \item{mcse_rmse}{Delta-method Monte Carlo standard error of RMSE,
#'     obtained from the Monte Carlo standard error of mean squared error.}
#'   \item{coverage}{Coverage probability.}
#'   \item{mcse_coverage}{Binomial Monte Carlo standard error of coverage.}
#'   \item{rejection_rate}{Proportion of intervals excluding zero.}
#'   \item{mcse_rejection_rate}{Binomial Monte Carlo standard error of the
#'     rejection rate.}
#'   \item{power}{Rejection rate for nonzero population values and `NA` for
#'     zero population values.}
#'   \item{mcse_power}{Monte Carlo standard error of power for nonzero
#'     population values and `NA` for zero population values.}
#'   \item{type1_error}{Rejection rate for zero population values and `NA` for
#'     nonzero population values.}
#'   \item{mcse_type1_error}{Monte Carlo standard error of the Type I error
#'     rate for zero population values and `NA` for nonzero population values.}
#'   \item{par_idx}{Parameter display index.}
#' }
#'
#' @keywords data resultsk4
"resultsk4"
