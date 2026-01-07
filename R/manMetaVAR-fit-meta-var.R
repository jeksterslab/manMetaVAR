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
#'   data = data,
#'   fit = fit,
#'   ncores = parallel::detectCores()
#' )
#' summary(pooled)
#' print(pooled)
#' coef(pooled)
#' vcov(pooled)
#' }
#'
#' @family Model Fitting Functions
#' @keywords manMetaVAR meta
#' @import metaVAR
#' @export
FitMetaVAR <- function(data,
                       fit,
                       ncores = NULL) {
  start_time <- Sys.time()
  output <- metaVAR::MetaVARMx(
    object = fit$output,
    x = NULL,
    random = TRUE,
    alpha_values = data$ma_fixed,
    diag = FALSE,
    effects = TRUE,
    int_meas = TRUE,
    int_dyn = FALSE,
    cov_meas = FALSE,
    cov_dyn = FALSE,
    robust_v = FALSE,
    robust = TRUE,
    try = 1000,
    ncores = ncores
  )
  end_time <- Sys.time()
  elapsed <- end_time - start_time
  structure(
    list(
      output = output,
      elapsed = elapsed
    ),
    class = "manmetavar.metavar"
  )
}
