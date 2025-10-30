#' Parameter Estimates (FitMplus)
#'
#' @author Ivan Jacob Agaloos Pesigan
#'
#' @param object Object of class `manmetavar.mplus`.
#' @param median Logical.
#'   If `median = TRUE`, return median of the posterior.
#'   If `median = FALSE`, return mean of the posterior.
#'
#' @inheritParams Template
#'
#' @return Returns a vector of estimated parameters.
#'
#' @rdname coef.manmetavar
#' @method coef manmetavar.mplus
#' @keywords methods
#' @import metaVAR
#' @export
coef.manmetavar.mplus <- function(object,
                                  median = TRUE,
                                  ...) {
  posterior <- as.matrix(
    utils::read.table(
      text = object$output$posterior
    )
  )[, -c(1, 2), drop = FALSE]
  if (median) {
    out <- apply(
      X = posterior,
      MARGIN = 2,
      FUN = median
    )
  } else {
    out <- colMeans(posterior)
  }
  names(out) <- c(
    "theta[1,1]",
    "theta[2,2]",
    "psi[1,1]",
    "psi[2,1]",
    "psi[2,2]",
    "mean(nu[1,1])",
    "mean(nu[2,1])",
    "mean(beta[1,1])",
    "mean(beta[2,1])",
    "mean(beta[1,2])",
    "mean(beta[2,2])",
    "cov(nu[1,1],nu[1,1])",
    "cov(nu[2,1],nu[1,1])",
    "cov(nu[2,1],nu[2,1])",
    "cov(nu[1,1],beta[1,1])",
    "cov(nu[2,1],beta[1,1])",
    "cov(beta[1,1],beta[1,1])",
    "cov(nu[1,1],beta[2,1])",
    "cov(nu[2,1],beta[2,1])",
    "cov(beta[2,1], beta[1,1])",
    "cov(beta[2,1],beta[2,1])",
    "cov(nu[1,1],beta[1,2])",
    "cov(nu[2,1],beta[1,2])",
    "cov(beta[1,2],beta[1,1])",
    "cov(beta[1,2],beta[2,1])",
    "cov(beta[1,2],beta[1,2])",
    "cov(nu[1,1],beta[2,2])",
    "cov(nu[2,1],beta[2,2])",
    "cov(beta[2,2],beta[1,1])",
    "cov(beta[2,2],beta[2,1])",
    "cov(beta[2,2],beta[1,2])",
    "cov(beta[2,2],beta[2,2])"
  )
  out
}

#' Sampling Covariance Matrix of the Parameter Estimates (FitMplus)
#'
#' @author Ivan Jacob Agaloos Pesigan
#'
#' @param object Object of class `manmetavar.mplus`.
#'
#' @inheritParams Template
#'
#' @return Returns the sampling variance-covariance matrix
#'   of the estimated parameters.
#'
#' @rdname vcov.manmetavar
#' @method vcov manmetavar.mplus
#' @keywords methods
#' @export
vcov.manmetavar.mplus <- function(object,
                                  ...) {
  posterior <- as.matrix(
    utils::read.table(
      text = object$output$posterior
    )
  )[, -c(1, 2), drop = FALSE]
  out <- stats::cov(posterior)
  names(out) <- c(
    "theta[1,1]",
    "theta[2,2]",
    "psi[1,1]",
    "psi[2,1]",
    "psi[2,2]",
    "mean(nu[1,1])",
    "mean(nu[2,1])",
    "mean(beta[1,1])",
    "mean(beta[2,1])",
    "mean(beta[1,2])",
    "mean(beta[2,2])",
    "cov(nu[1,1],nu[1,1])",
    "cov(nu[2,1],nu[1,1])",
    "cov(nu[2,1],nu[2,1])",
    "cov(nu[1,1],beta[1,1])",
    "cov(nu[2,1],beta[1,1])",
    "cov(beta[1,1],beta[1,1])",
    "cov(nu[1,1],beta[2,1])",
    "cov(nu[2,1],beta[2,1])",
    "cov(beta[2,1], beta[1,1])",
    "cov(beta[2,1],beta[2,1])",
    "cov(nu[1,1],beta[1,2])",
    "cov(nu[2,1],beta[1,2])",
    "cov(beta[1,2],beta[1,1])",
    "cov(beta[1,2],beta[2,1])",
    "cov(beta[1,2],beta[1,2])",
    "cov(nu[1,1],beta[2,2])",
    "cov(nu[2,1],beta[2,2])",
    "cov(beta[2,2],beta[1,1])",
    "cov(beta[2,2],beta[2,1])",
    "cov(beta[2,2],beta[1,2])",
    "cov(beta[2,2],beta[2,2])"
  )
  out
}

.PosteriorCI <- function(object,
                         alpha = 0.05,
                         median = TRUE) {
  thetahatstar <- as.matrix(
    utils::read.table(
      text = object$output$posterior
    )
  )[, -c(1, 2), drop = FALSE]
  thetahat <- coef.manmetavar.mplus(
    object = object,
    median = median
  )
  stopifnot(
    all(alpha > 0 & alpha < 1)
  )
  probs <- .PCProbs(alpha = alpha)
  ci <- vector(
    mode = "list",
    length = dim(thetahatstar)[2]
  )
  for (i in seq_len(dim(thetahatstar)[2])) {
    ci[[i]] <- .PCCI(
      thetahatstar = thetahatstar[, i],
      thetahat = thetahat[[i]],
      probs = probs
    )
  }
  ci <- do.call(
    what = "rbind",
    args = ci
  )
  varnames <- names(thetahat)
  if (!is.null(varnames)) {
    rownames(ci) <- varnames
  }
  ci
}

#' Summary Method (FitMplus)
#'
#' @author Ivan Jacob Agaloos Pesigan
#'
#' @param object Object of class `manmetavar.mplus`.
#'
#' @inheritParams Template
#' @inheritParams coef.manmetavar.mplus
#'
#' @return Returns a matrix of estimates, standard errors,
#'   number of posterior samples, and confidence intervals.
#'
#' @rdname summary.manmetavar
#' @method summary manmetavar.mplus
#' @keywords methods
#' @export
summary.manmetavar.mplus <- function(object,
                                     alpha = 0.05,
                                     median = TRUE,
                                     digits = 4,
                                     ...) {
  ci <- .PosteriorCI(
    object = object,
    alpha = alpha,
    median = median
  )
  structure(
    .Data = ci,
    fit = object,
    alpha = alpha,
    digits = digits,
    print_summary = round(
      x = ci,
      digits = digits
    ),
    class = "summary.manmetavar.mplus"
  )
}

#' @noRd
#' @keywords internal
#' @exportS3Method print summary.manmetavar.mplus
print.summary.manmetavar.mplus <- function(x,
                                           ...) {
  print_summary <- attr(
    x = x,
    which = "print_summary"
  )
  print(print_summary)
  invisible(x)
}

#' Confidence Intervals for the Parameter Estimates (FitMplus)
#'
#' @author Ivan Jacob Agaloos Pesigan
#'
#' @param object Object of class `manmetavar.mplus`.
#' @param ... additional arguments.
#' @param parm a specification of which parameters
#'   are to be given confidence intervals,
#'   either a vector of numbers or a vector of names.
#'   If missing, all parameters are considered.
#' @param level the confidence level required.
#' @return Returns a matrix of confidence intervals.
#'
#' @rdname confint.manmetavar
#' @method confint manmetavar.mplus
#' @keywords methods
#' @import metaVAR
#' @export
confint.manmetavar.mplus <- function(object,
                                     parm = NULL,
                                     level = 0.95,
                                     ...) {
  ci <- .PosteriorCI(
    object = object,
    alpha = 1 - level[1],
    median = TRUE
  )
  if (is.null(parm)) {
    parameters <- rownames(
      ci
    )
    if (!is.null(parameters)) {
      parm <- parameters
    } else {
      parm <- seq_len(dim(ci)[1])
    }
  }
  ci <- ci[parm, 4:5, drop = FALSE]
  varnames <- colnames(ci)
  varnames <- gsub(
    pattern = "%",
    replacement = " %",
    x = varnames
  )
  colnames(ci) <- varnames
  ci
}
