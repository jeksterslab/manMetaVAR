#' Methods for Objects of Class `manmetavar.data`
#'
#' This page documents the available methods for objects of class
#' `manmetavar.data`.
#'
#' @name manmetavar-data-methods
#' @keywords methods
NULL

#' Print Method for an Object of Class `manmetavar.data`
#'
#' @author Ivan Jacob Agaloos Pesigan
#'
#' @param x Object of class `manmetavar.data`.
#'
#' @inheritParams Template
#'
#' @rdname manmetavar-data-methods
#' @method print manmetavar.data
#' @keywords methods
#' @export
print.manmetavar.data <- function(x,
                                  ...) {
  base::print(
    x = x$data
  )
}

#' Summary Method for an Object of Class `manmetavar.data`
#'
#' @author Ivan Jacob Agaloos Pesigan
#'
#' @param object Object of class `manmetavar.data`.
#'
#' @inheritParams Template
#'
#' @rdname manmetavar-data-methods
#' @method summary manmetavar.data
#' @keywords methods
#' @export
summary.manmetavar.data <- function(object,
                                    ...) {
  summary(
    object = object$data
  )
}

#' Plot Method for an Object of Class `manmetavar.data`
#'
#' @author Ivan Jacob Agaloos Pesigan
#'
#' @param x Object of class `manmetavar.data`.
#'
#' @inheritParams Template
#'
#' @rdname manmetavar-data-methods
#' @method plot manmetavar.data
#' @keywords methods
#' @export
plot.manmetavar.data <- function(x,
                                 ...) {
  plot(
    x = x$sim
  )
}
