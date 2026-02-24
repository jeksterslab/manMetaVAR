#' Methods for Objects of Class `manmetavar.metavar`
#'
#' This page documents the available methods for objects of class
#' `manmetavar.metavar`.
#'
#' @name manmetavar-metavar-methods
#' @keywords methods
NULL

#' Parameter Estimates (FitMetaVAR)
#'
#' @author Ivan Jacob Agaloos Pesigan
#'
#' @param object Object of class `manmetavar.metavar`.
#'
#' @inheritParams Template
#'
#' @rdname manmetavar-metavar-methods
#' @method coef manmetavar.metavar
#' @keywords methods
#' @import metaDyn
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
#' @inheritParams metaDyn::vcov.metadynmeta
#'
#' @rdname manmetavar-metavar-methods
#' @method vcov manmetavar.metavar
#' @keywords methods
#' @export
vcov.manmetavar.metavar <- function(object,
                                    robust = NULL,
                                    ...) {
  vcov(
    object = object$output,
    robust = robust
  )
}

#' Print Method (FitMetaVAR)
#'
#' @author Ivan Jacob Agaloos Pesigan
#'
#' @param x Object of class `manmetavar.metavar`.
#' @inheritParams metaDyn::summary.metadynmeta
#'
#' @rdname manmetavar-metavar-methods
#' @method print manmetavar.metavar
#' @keywords methods
#' @import metaDyn
#' @export
print.manmetavar.metavar <- function(x,
                                     alpha = NULL,
                                     robust = NULL,
                                     digits = 4,
                                     ...) {
  print(
    x = x$output,
    alpha = alpha,
    robust = robust,
    digits = digits
  )
}

#' Summary Method (FitMetaVAR)
#'
#' @author Ivan Jacob Agaloos Pesigan
#'
#' @param object Object of class `manmetavar.metavar`.
#' @inheritParams metaDyn::summary.metadynmeta
#'
#' @rdname manmetavar-metavar-methods
#' @method summary manmetavar.metavar
#' @keywords methods
#' @import metaDyn
#' @export
summary.manmetavar.metavar <- function(object,
                                       alpha = NULL,
                                       robust = NULL,
                                       digits = 4,
                                       ...) {
  summary(
    object = object$output,
    alpha = alpha,
    robust = robust,
    digits = digits
  )
}

#' @noRd
#' @keywords internal
#' @exportS3Method print summary.manmetavar.metavar
print.summary.manmetavar.metavar <- function(x,
                                             ...) {
  print_summary <- attr(
    x = x,
    which = "print_summary"
  )
  object <- attr(
    x = x,
    which = "fit"
  )
  cat("Call:\n")
  base::print(object$call)
  print(print_summary)
  invisible(x)
}

#' Confidence Intervals for the Parameter Estimates (FitMetaVAR)
#'
#' @author Ivan Jacob Agaloos Pesigan
#'
#' @param object Object of class `manmetavar.metavar`.
#' @inheritParams metaDyn::confint.metadynmeta
#'
#' @rdname manmetavar-metavar-methods
#' @method confint manmetavar.metavar
#' @keywords methods
#' @import metaDyn
#' @importFrom stats confint
#' @export
confint.manmetavar.metavar <- function(object,
                                       parm = NULL,
                                       level = 0.95,
                                       robust = NULL,
                                       ...) {
  confint(
    object = object$output,
    parm = parm,
    level = level,
    robust = robust
  )
}
