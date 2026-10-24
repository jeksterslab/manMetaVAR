#' Boundary Likelihood Ratio Test for Transition Heterogeneity
#'
#' Tests whether the between-person covariance matrix of the transition
#' parameters is zero in a fitted MetaVAR Stage 2 model.
#' The model is refitted with the transition rows and columns of
#' \eqn{\boldsymbol{\tau}^2} fixed at zero
#' (variances at the lower bound of the softplus parameterization),
#' and the likelihood ratio statistic is referred to a simulated
#' chi-bar-square distribution for the cone of positive semidefinite
#' matrices, using the Fisher information at the null fit,
#' and to the naive chi-square distribution.
#'
#' @author Ivan Jacob Agaloos Pesigan
#'
#' @param fit Fitted MetaVAR Stage 2 model:
#'   an object returned by [FitMetaVAR()], by [metaDyn::MetaVARMx()],
#'   or the underlying `MxModel`.
#' @param block Integer vector.
#'   Positions of the transition parameters in \eqn{\boldsymbol{\tau}^2}.
#' @param others Integer vector.
#'   Positions of the remaining random effects in \eqn{\boldsymbol{\tau}^2}.
#' @param cross Logical.
#'   If `cross = TRUE`, the covariances between `block` and `others` are
#'   free in `fit` and are also set to zero under the null hypothesis.
#' @param draws Positive integer.
#'   Number of draws from the chi-bar-square distribution.
#' @param seed Integer.
#'   Random seed for the chi-bar-square draws.
#'
#' @return A one-row data frame with the -2 log-likelihoods of the full and
#'   null models, the statistic, the null-fit status code, the number of
#'   tested parameters (`df`), the chi-bar-square p-value and 95% critical
#'   value, and the naive chi-square p-value.
#'
#' @examples
#' \dontrun{
#' seed <- 42
#' data <- GenData(taskid = 25, seed = seed)
#' fit <- FitDTVAR(data = data, seed = seed)
#' meta <- FitMetaVAR(fit = fit, seed = seed)
#' LRTMetaVAR(fit = meta, seed = seed)
#' }
#'
#' @family Model Fitting Functions
#' @keywords manMetaVAR meta
#' @export
LRTMetaVAR <- function(fit,
                       block = 3:6,
                       others = 1:2,
                       cross = FALSE,
                       draws = 2000L,
                       seed = NULL) {
  mx <- fit
  while (!inherits(mx, "MxModel")) {
    if (is.null(mx$output)) {
      stop(
        "`fit` does not contain a fitted `MxModel`.",
        call. = FALSE
      )
    }
    mx <- mx$output
  }
  null <- mx
  tau_sqr_d <- null$tau_sqr_d
  tau_sqr_d$free[block, 1] <- FALSE
  tau_sqr_d$values[block, 1] <- tau_sqr_d$lbound[block, 1]
  null$tau_sqr_d <- tau_sqr_d
  tau_sqr_l <- null$tau_sqr_l
  tau_sqr_l$free[block, ] <- FALSE
  tau_sqr_l$free[, block] <- FALSE
  tau_sqr_l$values[block, ] <- 0
  tau_sqr_l$values[, block] <- 0
  null$tau_sqr_l <- tau_sqr_l
  null <- OpenMx::mxRun(
    null,
    silent = TRUE,
    suppressWarnings = TRUE
  )
  if (null$output$status$code > 1) {
    null <- OpenMx::mxTryHard(
      null,
      silent = TRUE,
      extraTries = 20
    )
  }
  m2ll_full <- mx$output$Minus2LogLikelihood
  m2ll_null <- null$output$Minus2LogLikelihood
  stat <- m2ll_null - m2ll_full
  tau_sqr <- OpenMx::mxEvalByName(
    name = "tau_sqr",
    model = null,
    compute = TRUE
  )
  p <- nrow(tau_sqr)
  observed <- mx$data$observed
  v_names <- grep(
    pattern = "^v[0-9]+$",
    x = names(observed),
    value = TRUE
  )
  vech <- .LRTVechIndex(p)
  v <- lapply(
    X = seq_len(nrow(observed)),
    FUN = function(i) {
      v_i <- matrix(
        data = 0,
        nrow = p,
        ncol = p
      )
      v_i[vech] <- unlist(observed[i, v_names])
      v_i[upper.tri(v_i)] <- t(v_i)[upper.tri(v_i)]
      v_i
    }
  )
  info <- .LRTInformation(
    tau_sqr = tau_sqr,
    v = v,
    block = block,
    others = others,
    cross = cross
  )
  chi_bar <- .LRTChiBar(
    stat = max(stat, 0),
    info = info,
    k = length(block),
    draws = draws,
    seed = seed
  )
  data.frame(
    m2ll_full = m2ll_full,
    m2ll_null = m2ll_null,
    stat = stat,
    status_null = null$output$status$code,
    df = nrow(info),
    p_chibar = chi_bar$p,
    crit_chibar = chi_bar$crit,
    p_chisq = stats::pchisq(
      q = max(stat, 0),
      df = nrow(info),
      lower.tail = FALSE
    )
  )
}
