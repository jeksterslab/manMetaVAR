#' Methods for Objects of Class `manmetavar.mlvar`
#'
#' This page documents the available methods for objects of class
#' `manmetavar.mlvar`.
#'
#' @name manmetavar-mlvar-methods
#' @keywords methods
NULL

#' Print Method (FitMLVAR)
#'
#' @author Ivan Jacob Agaloos Pesigan
#'
#' @param x Object of class `manmetavar.mlvar`.
#'
#' @inheritParams Template
#'
#' @rdname manmetavar-mlvar-methods
#' @method print manmetavar.mlvar
#' @keywords methods
#' @import mlVAR
#' @export
print.manmetavar.mlvar <- function(x,
                                   show = c(
                                     "fit",
                                     "temporal",
                                     "contemporaneous",
                                     "between"
                                   ),
                                   digits = 4,
                                   ...) {
  print(
    summary.manmetavar.mlvar(
      object = x,
      show = show,
      digits = digits
    )
  )
}

#' Summary Method (FitMLVAR)
#'
#' @author Ivan Jacob Agaloos Pesigan
#'
#' @param object Object of class `manmetavar.mlvar`.
#'
#' @inheritParams Template
#'
#' @rdname manmetavar-mlvar-methods
#' @method summary manmetavar.mlvar
#' @keywords methods
#' @import mlVAR
#' @export
summary.manmetavar.mlvar <- function(object,
                                     show = c(
                                       "fit",
                                       "temporal",
                                       "contemporaneous",
                                       "between"
                                     ),
                                     digits = 4,
                                     ...) {
  summary(
    object = object$output,
    show = show,
    round = digits
  )
}
