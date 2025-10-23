#' Parameter Estimates (FitMetaVAR)
#'
#' @author Ivan Jacob Agaloos Pesigan
#'
#' @param object Object of class `manmetavar.metavar`.
#'
#' @inheritParams Template
#'
#' @return Returns a vector of estimated parameters.
#'
#' @method coef manmetavar.metavar
#' @keywords methods
#' @import metaVAR
#' @export
coef.manmetavar.metavar <- function(object,
                                    ...) {
  coef(
    object = object$output
  )
}

#' Sampling Covariance Matrix of the Parameter Estimates (FitMetaVAR)
#'
#' @author Ivan Jacob Agaloos Pesigan
#'
#' @param object Object of class `manmetavar.metavar`.
#'
#' @inheritParams Template
#'
#' @return Returns the sampling variance-covariance matrix
#'   of the estimated parameters.
#'
#' @method vcov manmetavar.metavar
#' @keywords methods
#' @export
vcov.manmetavar.metavar <- function(object,
                                    ...) {
  vcov(
    object = object$output
  )
}

#' Print Method (FitMetaVAR)
#'
#' @author Ivan Jacob Agaloos Pesigan
#'
#' @param x Object of class `manmetavar.metavar`.
#'
#' @inheritParams Template
#'
#' @return Returns a matrix of
#'   estimates,
#'   standard errors,
#'   test statistics,
#'   degrees of freedom,
#'   p-values,
#'   and
#'   confidence intervals.
#'
#' @method print manmetavar.metavar
#' @keywords methods
#' @import metaVAR
#' @export
print.manmetavar.metavar <- function(x,
                                     alpha = 0.05,
                                     digits = 4,
                                     ...) {
  print(
    x = x$output,
    alpha = alpha,
    digits = digits
  )
}

#' Summary Method (FitMetaVAR)
#'
#' @author Ivan Jacob Agaloos Pesigan
#'
#' @param object Object of class `manmetavar.metavar`.
#'
#' @inheritParams Template
#'
#' @return Returns a matrix of
#'   estimates,
#'   standard errors,
#'   test statistics,
#'   degrees of freedom,
#'   p-values,
#'   and
#'   confidence intervals.
#'
#' @method summary manmetavar.metavar
#' @keywords methods
#' @import metaVAR
#' @export
summary.manmetavar.metavar <- function(object,
                                       alpha = 0.05,
                                       digits = 4,
                                       ...) {
  summary(
    object = object$output,
    alpha = alpha,
    digits = digits
  )
}
