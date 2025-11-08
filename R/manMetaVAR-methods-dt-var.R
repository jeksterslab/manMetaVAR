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
#' @param alpha Logical.
#'   If `alpha = TRUE`,
#'   include estimates of the `alpha` vector, if available.
#'   If `alpha = FALSE`,
#'   exclude estimates of the `alpha` vector.
#' @param beta Logical.
#'   If `beta = TRUE`,
#'   include estimates of the `beta` matrix, if available.
#'   If `beta = FALSE`,
#'   exclude estimates of the `beta` matrix.
#' @param nu Logical.
#'   If `nu = TRUE`,
#'   include estimates of the `nu` vector, if available.
#'   If `nu = FALSE`,
#'   exclude estimates of the `nu` vector.
#' @param psi Logical.
#'   If `psi = TRUE`,
#'   include estimates of the `psi` matrix, if available.
#'   If `psi = FALSE`,
#'   exclude estimates of the `psi` matrix.
#' @param theta Logical.
#'   If `theta = TRUE`,
#'   include estimates of the `theta` matrix, if available.
#'   If `theta = FALSE`,
#'   exclude estimates of the `theta` matrix.
#' @param converged Logical.
#'   Only include converged cases.
#' @param grad_tol Numeric scalar.
#'   Tolerance for the maximum absolute gradient
#'   if `converged = TRUE`.
#' @param hess_tol Numeric scalar.
#'   Tolerance for Hessian eigenvalues;
#'   eigenvalues must be strictly greater than this value
#'   if `converged = TRUE`.
#' @param vanishing_theta Logical.
#'   Test for measurement error variance going to zero
#'   if `converged = TRUE`.
#' @param theta_tol Numeric.
#'   Tolerance for vanishing theta test
#'   if `converged` and `theta_tol` are `TRUE`.
#'
#' @inheritParams Template
#'
#' @rdname manmetavar-dtvar-methods
#' @method coef manmetavar.dtvar
#' @keywords methods
#' @export
coef.manmetavar.dtvar <- function(object,
                                  alpha = TRUE,
                                  beta = TRUE,
                                  nu = TRUE,
                                  psi = TRUE,
                                  theta = TRUE,
                                  converged = TRUE,
                                  grad_tol = 1e-2,
                                  hess_tol = 1e-8,
                                  vanishing_theta = TRUE,
                                  theta_tol = 0.001,
                                  ...) {
  coef(
    object = object$output,
    alpha = alpha,
    beta = beta,
    nu = nu,
    psi = psi,
    theta = theta,
    converged = converged,
    grad_tol = grad_tol,
    hess_tol = hess_tol,
    vanishing_theta = vanishing_theta,
    theta_tol = theta_tol
  )
}

#' Sampling Covariance Matrix of the Parameter Estimates (FitDTVAR)
#'
#' @author Ivan Jacob Agaloos Pesigan
#'
#' @param object Object of class `manmetavar.dtvar`.
#'
#' @inheritParams coef.manmetavar.dtvar
#' @inheritParams Template
#'
#' @rdname manmetavar-dtvar-methods
#' @method vcov manmetavar.dtvar
#' @keywords methods
#' @export
vcov.manmetavar.dtvar <- function(object,
                                  alpha = TRUE,
                                  beta = TRUE,
                                  nu = TRUE,
                                  psi = TRUE,
                                  theta = TRUE,
                                  converged = TRUE,
                                  grad_tol = 1e-2,
                                  hess_tol = 1e-8,
                                  vanishing_theta = TRUE,
                                  theta_tol = 0.001,
                                  ...) {
  vcov(
    object = object$output,
    alpha = alpha,
    beta = beta,
    nu = nu,
    psi = psi,
    theta = theta,
    converged = converged,
    grad_tol = grad_tol,
    hess_tol = hess_tol,
    vanishing_theta = vanishing_theta,
    theta_tol = theta_tol
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
                                   alpha = TRUE,
                                   beta = TRUE,
                                   nu = TRUE,
                                   psi = TRUE,
                                   theta = TRUE,
                                   converged = TRUE,
                                   grad_tol = 1e-2,
                                   hess_tol = 1e-8,
                                   vanishing_theta = TRUE,
                                   theta_tol = 0.001,
                                   digits = 4,
                                   ...) {
  print(
    x = x$output,
    means = means,
    alpha = alpha,
    beta = beta,
    nu = nu,
    psi = psi,
    theta = theta,
    converged = converged,
    grad_tol = grad_tol,
    hess_tol = hess_tol,
    vanishing_theta = vanishing_theta,
    theta_tol = theta_tol,
    digits = digits
  )
}

#' Summary Method (FitDTVAR)
#'
#' @author Ivan Jacob Agaloos Pesigan
#'
#' @param object Object of class `manmetavar.dtvar`.
#' @inheritParams print.manmetavar.dtvar
#' @inheritParams Template
#'
#' @rdname manmetavar-dtvar-methods
#' @method summary manmetavar.dtvar
#' @keywords methods
#' @import fitDTVARMxID
#' @export
summary.manmetavar.dtvar <- function(object,
                                     means = FALSE,
                                     alpha = TRUE,
                                     beta = TRUE,
                                     nu = TRUE,
                                     psi = TRUE,
                                     theta = TRUE,
                                     converged = TRUE,
                                     grad_tol = 1e-2,
                                     hess_tol = 1e-8,
                                     vanishing_theta = TRUE,
                                     theta_tol = 0.001,
                                     digits = 4,
                                     ...) {
  summary(
    object = object$output,
    means = means,
    alpha = alpha,
    beta = beta,
    nu = nu,
    psi = psi,
    theta = theta,
    converged = converged,
    grad_tol = grad_tol,
    hess_tol = hess_tol,
    vanishing_theta = vanishing_theta,
    theta_tol = theta_tol,
    digits = digits
  )
}
