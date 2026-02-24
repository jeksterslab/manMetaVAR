#' Methods for Objects of Class `manmetavar.dtvar`
#'
#' This page documents the available methods for objects of class
#' `manmetavar.dtvar`.
#'
#' @name manmetavar-dtvar-methods
#' @keywords methods
NULL

#' Parameter Estimates (FitDTVAR)
#'
#' @author Ivan Jacob Agaloos Pesigan
#'
#' @param object Object of class `manmetavar.dtvar`.
#' @inheritParams fitVARMxID::coef.varmxid
#'
#' @rdname manmetavar-dtvar-methods
#' @method coef manmetavar.dtvar
#' @keywords methods
#' @export
coef.manmetavar.dtvar <- function(object,
                                  mu = TRUE,
                                  alpha = TRUE,
                                  beta = TRUE,
                                  nu = TRUE,
                                  psi = TRUE,
                                  theta = TRUE,
                                  ncores = NULL,
                                  ...) {
  coef(
    object = object$output,
    mu = mu,
    alpha = alpha,
    beta = beta,
    nu = nu,
    psi = psi,
    theta = theta,
    ncores = ncores
  )
}

#' Sampling Covariance Matrix of the Parameter Estimates (FitDTVAR)
#'
#' @author Ivan Jacob Agaloos Pesigan
#'
#' @param object Object of class `manmetavar.dtvar`.
#' @inheritParams fitVARMxID::vcov.varmxid
#'
#' @rdname manmetavar-dtvar-methods
#' @method vcov manmetavar.dtvar
#' @keywords methods
#' @export
vcov.manmetavar.dtvar <- function(object,
                                  mu = TRUE,
                                  alpha = TRUE,
                                  beta = TRUE,
                                  nu = TRUE,
                                  psi = TRUE,
                                  theta = TRUE,
                                  robust = FALSE,
                                  ncores = NULL,
                                  ...) {
  vcov(
    object = object$output,
    mu = mu,
    alpha = alpha,
    beta = beta,
    nu = nu,
    psi = psi,
    theta = theta,
    robust = robust,
    ncores = ncores
  )
}

#' Print Method (FitDTVAR)
#'
#' @author Ivan Jacob Agaloos Pesigan
#'
#' @param x Object of class `manmetavar.dtvar`.
#' @param means Logical.
#'   If `means = TRUE`, return means.
#'   Otherwise, the function returns raw estimates.
#' @inheritParams coef.manmetavar.dtvar
#' @inheritParams Template
#'
#' @rdname manmetavar-dtvar-methods
#' @method print manmetavar.dtvar
#' @keywords methods
#' @export
print.manmetavar.dtvar <- function(x,
                                   means = FALSE,
                                   mu = TRUE,
                                   alpha = TRUE,
                                   beta = TRUE,
                                   nu = TRUE,
                                   psi = TRUE,
                                   theta = TRUE,
                                   digits = 4,
                                   ncores = NULL,
                                   ...) {
  print(
    x = x$output,
    means = means,
    mu = mu,
    alpha = alpha,
    beta = beta,
    nu = nu,
    psi = psi,
    theta = theta,
    digits = digits,
    ncores = ncores
  )
}

#' Summary Method (FitDTVAR)
#'
#' @author Ivan Jacob Agaloos Pesigan
#'
#' @param object Object of class `manmetavar.dtvar`.
#' @inheritParams fitVARMxID::summary.varmxid
#'
#' @rdname manmetavar-dtvar-methods
#' @method summary manmetavar.dtvar
#' @keywords methods
#' @import fitVARMxID
#' @export
summary.manmetavar.dtvar <- function(object,
                                     means = FALSE,
                                     mu = TRUE,
                                     alpha = TRUE,
                                     beta = TRUE,
                                     nu = TRUE,
                                     psi = TRUE,
                                     theta = TRUE,
                                     digits = 4,
                                     ncores = NULL,
                                     ...) {
  summary(
    object = object$output,
    means = means,
    mu = mu,
    alpha = alpha,
    beta = beta,
    nu = nu,
    psi = psi,
    theta = theta,
    digits = digits,
    ncores = ncores
  )
}
