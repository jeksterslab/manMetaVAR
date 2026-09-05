#' Methods for Objects of Class `manmetavar.naive`
#'
#' This page documents the available methods for objects of class
#' `manmetavar.naive`.
#'
#' @name manmetavar-metavar-methods
#' @keywords methods
NULL

#' Parameter Estimates (FitNaive)
#'
#' @author Ivan Jacob Agaloos Pesigan
#'
#' @param object Object of class `manmetavar.naive`.
#'
#' @inheritParams Template
#'
#' @rdname manmetavar-metavar-methods
#' @method coef manmetavar.naive
#' @keywords methods
#' @export
coef.manmetavar.naive <- function(object,
                                  ...) {
  coef(
    object$output,
    ...
  )
}

#' Sampling Covariance Matrix of the Parameter Estimates (FitNaive)
#'
#' @author Ivan Jacob Agaloos Pesigan
#'
#' @param object Object of class `manmetavar.naive`.
#'
#' @inheritParams Template
#'
#' @rdname manmetavar-metavar-methods
#' @method vcov manmetavar.naive
#' @keywords methods
#' @export
vcov.manmetavar.naive <- function(object,
                                  ...) {
  vcov(
    object$output,
    ...
  )
}

#' Print Method (FitNaive)
#'
#' @author Ivan Jacob Agaloos Pesigan
#'
#' @param x Object of class `manmetavar.naive`.
#'
#' @inheritParams Template
#'
#' @rdname manmetavar-metavar-methods
#' @method print manmetavar.naive
#' @keywords methods
#' @export
print.manmetavar.naive <- function(x,
                                   ...) {
  print(
    x$output,
    ...
  )
}

#' Summary Method (FitNaive)
#'
#' @author Ivan Jacob Agaloos Pesigan
#'
#' @param object Object of class `manmetavar.naive`.
#'
#' @inheritParams Template
#' @inheritParams summary.manmetavar.dtvar
#'
#' @rdname manmetavar-metavar-methods
#' @method summary manmetavar.naive
#' @keywords methods
#' @export
summary.manmetavar.naive <- function(object,
                                     alpha = 0.05,
                                     digits = 4,
                                     ...) {
  est <- coef(object$output)
  names(est) <- c(
    "alpha[1,1]",
    "alpha[2,1]",
    "alpha[3,1]",
    "alpha[4,1]",
    "alpha[5,1]",
    "alpha[6,1]",
    "tau_sqr[1,1]",
    "tau_sqr[2,1]",
    "tau_sqr[2,2]",
    "tau_sqr[3,3]",
    "tau_sqr[4,3]",
    "tau_sqr[5,3]",
    "tau_sqr[6,3]",
    "tau_sqr[4,4]",
    "tau_sqr[5,4]",
    "tau_sqr[6,4]",
    "tau_sqr[5,5]",
    "tau_sqr[6,5]",
    "tau_sqr[6,6]"
  )
  se <- sqrt(diag(vcov(object$output)))
  names(se) <- names(est)
  out <- .CIWald(
    est = est,
    se = se,
    theta = 0,
    alpha = alpha,
    z = TRUE
  )
  print_summary <- round(
    x = out,
    digits = digits
  )
  class(out) <- c(
    "summary.manmetavar.naive",
    class(out)
  )
  attr(out, "fit") <- object
  attr(out, "alpha") <- alpha
  attr(out, "digits") <- digits
  attr(out, "print_summary") <- print_summary
  out
}

#' @noRd
#' @keywords internal
.PrintNaiveSummary <- function(x,
                               ...) {
  print_summary <- attr(
    x = x,
    which = "print_summary"
  )
  object <- attr(
    x = x,
    which = "fit"
  )
  print(print_summary)
  invisible(object)
}
