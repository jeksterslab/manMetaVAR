#' Print Method (FitMLVAR)
#'
#' @author Ivan Jacob Agaloos Pesigan
#'
#' @param x Object of class `manmetavar.mlvar`.
#'
#' @inheritParams Template
#'
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
#' @return Returns a matrix of
#'   estimates,
#'   standard errors,
#'   test statistics,
#'   degrees of freedom,
#'   p-values,
#'   and
#'   confidence intervals.
#'
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
