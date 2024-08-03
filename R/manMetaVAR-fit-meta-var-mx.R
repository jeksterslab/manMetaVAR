#' Multivariate Meta-Analysis using the metaVAR Package
#'
#' The function performs multivariate meta-snalysis using the [metaVAR] package.
#'
#' @inheritParams Template
#'
#' @examples
#' \dontrun{
#' set.seed(42)
#' data <- GenData(n = 50, time = 100, theta = 0.2)
#' fit <- FitDTVARMx(data)
#' FitMetaVARMx(fit)
#' }
#' @family Meta-Analysis Functions
#' @keywords manMetaVAR meta
#' @import metaVAR
#' @export
FitMetaVARMx <- function(fit) {
  return(
    metaVAR::MetaVARMx(
      object = fit,
      mu_start = NULL,
      mu_lbound = NULL,
      mu_ubound = NULL,
      sigma_l_start = NULL,
      sigma_l_lbound = NULL,
      sigma_l_ubound = NULL,
      diag = FALSE,
      intercept = FALSE,
      noise = FALSE,
      error = FALSE,
      try = 10000,
      ncores = NULL
    )
  )
}
