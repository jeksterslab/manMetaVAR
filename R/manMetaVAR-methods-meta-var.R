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
#' @rdname coef.manmetavar
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
#' @rdname vcov.manmetavar
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
#' @rdname print.manmetavar
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
#' @rdname summary.manmetavar
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

#' Confidence Intervals for the Parameter Estimates (FitMetaVAR)
#'
#' @author Ivan Jacob Agaloos Pesigan
#'
#' @param object Object of class `manmetavar.metavar`.
#' @param ... additional arguments.
#' @param parm a specification of which parameters
#'   are to be given confidence intervals,
#'   either a vector of numbers or a vector of names.
#'   If missing, all parameters are considered.
#' @param level the confidence level required.
#' @param lb Logical.
#'   If `TRUE`, returns profile likelihood-based confidence intervals.
#'   If `FALSE`, returns Wald confidence intervals.
#' @return Returns a matrix of confidence intervals.
#'
#' @rdname confint.manmetavar
#' @method confint manmetavar.metavar
#' @keywords methods
#' @import metaVAR
#' @importFrom stats confint
#' @export
confint.manmetavar.metavar <- function(object,
                                       parm = NULL,
                                       level = 0.95,
                                       lb = TRUE,
                                       ...) {
  confint(
    object = object$output,
    parm = parm,
    level = level,
    lb = lb,
  )
}
