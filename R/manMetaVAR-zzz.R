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
    "manmetavar.mplus.k4.diagnostics",
    .PrintMplusK4Diag
  )
  registerS3method(
    "print",
    "summary.manmetavar.mplus",
    .PrintMplusSummary
  )
  registerS3method(
    "print",
    "summary.manmetavar.mplus.k4",
    .PrintMplusK4Summary
  )
  registerS3method(
    "print",
    "summary.manmetavar.naive",
    .PrintNaiveSummary
  )
  registerS3method(
    "print",
    "summary.manmetavar.naive.k4",
    .PrintNaiveK4Summary
  )
  registerS3method(
    "print",
    "summary.manmetavar.metavar",
    .PrintMetaVARSummary
  )
}
