#' Calibration of Stage 1 Sampling Variances in the Simulation
#'
#' For each simulation condition and transition parameter, the between-person
#' variance of the Stage 1 estimates, the mean Stage 1 sampling variance, and
#' their ratio, averaged over admissible MetaVAR replications
#' ([SumStage1Calibration()]).
#' Under zero transition heterogeneity, a ratio of one means that the
#' Stage 1 sampling variances are calibrated;
#' a ratio above one means that they are too small.
#'
#' @author Ivan Jacob Agaloos Pesigan
#'
#' @docType data
#' @name calibration
#' @usage data(calibration)
#' @format A data frame with one row per task ID and transition parameter:
#'
#' \describe{
#'   \item{taskid}{Simulation task ID.}
#'   \item{replications}{Number of replications.}
#'   \item{replications_used}{Number of admissible MetaVAR replications.}
#'   \item{n}{Number of persons.}
#'   \item{time}{Number of measurement occasions; `NA` denotes the unbalanced
#'     condition.}
#'   \item{heterogeneity}{Transition-parameter heterogeneity multiplier.}
#'   \item{position}{Position of the transition parameter in the Stage 1
#'     parameter vector (3 to 6 for \eqn{a_{11}}, \eqn{a_{21}},
#'     \eqn{a_{12}}, \eqn{a_{22}}).}
#'   \item{between_var}{Between-person variance of the Stage 1 estimates.}
#'   \item{mean_sampling_var}{Mean Stage 1 sampling variance.}
#'   \item{ratio}{`between_var` divided by `mean_sampling_var`.}
#' }
#'
#' @keywords data diagnostics
"calibration"
