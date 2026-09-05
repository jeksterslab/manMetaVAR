#' Methods for Objects of Class `manmetavar.naive.k4`
#'
#' This page documents the available methods for objects of class
#' `manmetavar.naive.k4`.
#'
#' @name manmetavar-naive-k4-methods
#' @keywords methods
NULL

#' Parameter Estimates (FitNaiveK4)
#'
#' @author Ivan Jacob Agaloos Pesigan
#'
#' @param object Object of class `manmetavar.naive.k4`.
#'
#' @inheritParams Template
#'
#' @rdname manmetavar-naive-k4-methods
#' @method coef manmetavar.naive.k4
#' @keywords methods
#' @export
coef.manmetavar.naive.k4 <- function(object,
                                     ...) {
  coef(
    object$output,
    ...
  )
}

#' Sampling Covariance Matrix of the Parameter Estimates (FitNaiveK4)
#'
#' @author Ivan Jacob Agaloos Pesigan
#'
#' @param object Object of class `manmetavar.naive.k4`.
#'
#' @inheritParams Template
#'
#' @rdname manmetavar-naive-k4-methods
#' @method vcov manmetavar.naive.k4
#' @keywords methods
#' @export
vcov.manmetavar.naive.k4 <- function(object,
                                     ...) {
  vcov(
    object$output,
    ...
  )
}

#' Print Method (FitNaiveK4)
#'
#' @author Ivan Jacob Agaloos Pesigan
#'
#' @param x Object of class `manmetavar.naive.k4`.
#'
#' @inheritParams Template
#'
#' @rdname manmetavar-naive-k4-methods
#' @method print manmetavar.naive.k4
#' @keywords methods
#' @export
print.manmetavar.naive.k4 <- function(x,
                                      ...) {
  print(
    x$output,
    ...
  )
}

#' Summary Method (FitNaiveK4)
#'
#' @author Ivan Jacob Agaloos Pesigan
#'
#' @param object Object of class `manmetavar.naive.k4`.
#'
#' @inheritParams Template
#' @inheritParams summary.manmetavar.dtvar
#'
#' @rdname manmetavar-naive-k4-methods
#' @method summary manmetavar.naive.k4
#' @keywords methods
#' @export
summary.manmetavar.naive.k4 <- function(object,
                                        alpha = 0.05,
                                        digits = 4,
                                        ...) {
  k <- 4L
  q <- k * k
  p <- k + q
  est <- coef(
    object$output
  )
  parameter_names <- c(
    paste0(
      "alpha[",
      seq_len(p),
      ",1]"
    ),
    paste0(
      "tau_sqr[",
      seq_len(p),
      ",",
      seq_len(p),
      "]"
    )
  )
  if (length(est) != length(parameter_names)) {
    stop(
      paste0(
        "Expected ",
        length(parameter_names),
        " free parameters for the four-variable diagonal-random-effects ",
        "model but found ",
        length(est),
        "."
      ),
      call. = FALSE
    )
  }
  names(est) <- parameter_names
  se <- sqrt(
    diag(
      vcov(
        object$output
      )
    )
  )
  names(se) <- parameter_names
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
    "summary.manmetavar.naive.k4",
    class(out)
  )
  attr(
    out,
    "fit"
  ) <- object
  attr(
    out,
    "alpha"
  ) <- alpha
  attr(
    out,
    "digits"
  ) <- digits
  attr(
    out,
    "print_summary"
  ) <- print_summary
  out
}

#' @noRd
#' @keywords internal
.PrintNaiveK4Summary <- function(x,
                                 ...) {
  print_summary <- attr(
    x = x,
    which = "print_summary"
  )
  object <- attr(
    x = x,
    which = "fit"
  )
  print(
    print_summary
  )
  invisible(
    object
  )
}
