#' Summary Method for an Object of Class `manmetavar_fitdtvar`
#'
#' @author Ivan Jacob Agaloos Pesigan
#'
#' @param object Object of class `manmetavar_fitdtvar`.
#' @param ... additional arguments.
#'
#' @keywords methods
#' @export
summary.manmetavar_fitdtvar <- function(object,
                                        ...) {
  summary(object$output)
}

#' Summary Method for an Object of Class `manmetavar_fitmetavar`
#'
#' @author Ivan Jacob Agaloos Pesigan
#'
#' @param object Object of class `manmetavar_fitmetavar`.
#' @param ... additional arguments.
#'
#' @keywords methods
#' @export
summary.manmetavar_fitmetavar <- function(object,
                                          ...) {
  summary(object$output)
}

#' Summary Method for an Object of Class `manmetavar_fitjags`
#'
#' @author Ivan Jacob Agaloos Pesigan
#'
#' @param object Object of class `manmetavar_fitjags`.
#' @param ... additional arguments.
#'
#' @keywords methods
#' @export
summary.manmetavar_fitjags <- function(object,
                                       ...) {
  summary(object$samples)
}

#' Summary Method for an Object of Class `manmetavar_fitmlvar`
#'
#' @author Ivan Jacob Agaloos Pesigan
#'
#' @param object Object of class `manmetavar_fitmlvar`.
#' @param ... additional arguments.
#'
#' @keywords methods
#' @export
summary.manmetavar_fitmlvar <- function(object,
                                        ...) {
  summary(object$output)
}

#' Summary Method for an Object of Class `manmetavar_data`
#'
#' @author Ivan Jacob Agaloos Pesigan
#'
#' @param object Object of class `manmetavar_data`.
#' @param ... additional arguments.
#'
#' @keywords methods
#' @export
summary.manmetavar_data <- function(object,
                                    ...) {
  summary(object$data)
}

#' Plot Method for an Object of Class `manmetavar_data`
#'
#' @author Ivan Jacob Agaloos Pesigan
#'
#' @param x Object of class `manmetavar_data`.
#' @param ... additional arguments.
#'
#' @keywords methods
#' @export
plot.manmetavar_data <- function(x,
                                 ...) {
  plot(x$sim)
}
