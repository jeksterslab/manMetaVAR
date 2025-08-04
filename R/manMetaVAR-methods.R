#' Summary Method for an Object of Class `fitjags`
#'
#' @author Ivan Jacob Agaloos Pesigan
#'
#' @param object Object of class `fitjags`.
#' @param ... additional arguments.
#'
#' @keywords methods
#' @export
summary.fitjags <- function(object,
                            ...) {
  summary(object$samples)
}

#' Summary Method for an Object of Class `gendata`
#'
#' @author Ivan Jacob Agaloos Pesigan
#'
#' @param object Object of class `gendata`.
#' @param ... additional arguments.
#'
#' @keywords methods
#' @export
summary.gendata <- function(object,
                            ...) {
  summary(object$data)
}

#' Plot Method for an Object of Class `gendata`
#'
#' @author Ivan Jacob Agaloos Pesigan
#'
#' @param x Object of class `gendata`.
#' @param ... additional arguments.
#'
#' @keywords methods
#' @export
plot.gendata <- function(x,
                         ...) {
  plot(x$sim)
}
