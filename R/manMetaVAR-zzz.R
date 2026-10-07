#' Register internal S3 methods
#'
#' The print methods use short internal function names while retaining the
#' existing public class names.
#'
#' @param libname Library path supplied by R.
#' @param pkgname Package name supplied by R.
#'
#' @noRd
.onLoad <- function(libname, pkgname) {
  registerS3method(
    "print",
    "manmetavar.mplus.diagnostics",
    .PrintMplusDiag
  )
  registerS3method(
    "print",
    "summary.manmetavar.mplus",
    .PrintMplusSummary
  )
  registerS3method(
    "print",
    "summary.manmetavar.naive",
    .PrintNaiveSummary
  )
  registerS3method(
    "print",
    "summary.manmetavar.metavar",
    .PrintMetaVARSummary
  )
}
