#' Multivariate Meta-Analysis using the metaVAR Package
#'
#' The function performs multivariate meta-snalysis using the [metaVAR] package.
#'
#' @inheritParams Template
#'
#' @examples
#' \dontrun{
#' set.seed(42)
#' data <- GenData(taskid = 1)
#' fit <- FitDTVAR(
#'   data = data,
#'   ncores = parallel::detectCores()
#' )
#' pooled <- FitMetaVAR(
#'   fit = fit,
#'   ncores = parallel::detectCores()
#' )
#' summary(pooled)
#' }
#' @family Meta-Analysis Functions
#' @keywords manMetaVAR meta
#' @import metaVAR
#' @export
FitMetaVAR <- function(fit,
                       ncores = NULL) {
  metaVAR::MetaVARMx(
    object = fit,
    x = NULL,
    random = TRUE,
    alpha_values = model$beta0,
    diag = FALSE,
    intercept = TRUE,
    noise = FALSE,
    error = FALSE,
    try = 10000,
    ncores = ncores
  )
}
