#' Multivariate Meta-Analysis using the metaDyn Package
#'
#' The function performs multivariate meta-snalysis using the [metaDyn] package.
#'
#' @inheritParams Template
#'
#' @examples
#' \dontrun{
#' seed <- 42
#' data <- GenData(taskid = 1, seed = seed)
#' fit <- FitDTVAR(data = data, seed = seed)
#' meta <- FitMetaVAR(fit = fit, seed = seed)
#' summary(meta)
#' print(meta)
#' coef(meta)
#' vcov(meta)
#' }
#'
#' @family Model Fitting Functions
#' @keywords manMetaVAR meta
#' @import metaDyn
#' @export
FitMetaVAR <- function(fit,
                       ncores = NULL,
                       seed = NULL) {
  start_time <- Sys.time()
  data <- as.data.frame(
    summary(
      fit,
      means = FALSE
    )[, 1:6]
  )
  covariances <- stats::var(data)
  means <- colMeans(data)
  covariances_free <- matrix(
    data = c(
      TRUE, TRUE, FALSE, FALSE, FALSE, FALSE,
      TRUE, TRUE, FALSE, FALSE, FALSE, FALSE,
      FALSE, FALSE, TRUE, TRUE, TRUE, TRUE,
      FALSE, FALSE, TRUE, TRUE, TRUE, TRUE,
      FALSE, FALSE, TRUE, TRUE, TRUE, TRUE,
      FALSE, FALSE, TRUE, TRUE, TRUE, TRUE
    ),
    byrow = TRUE,
    nrow = 6,
    ncol = 6
  )
  covariances[!covariances_free] <- 0
  ldl <- metaDyn:::.MxHelperLDL(covariances)
  output <- MetaVARMx(
    object = fit$output,
    x = NULL,
    random = TRUE,
    alpha_values = means,
    tau_sqr_diag = FALSE,
    tau_sqr_d_free = TRUE,
    tau_sqr_d_values = ldl$uc_d,
    tau_sqr_l_free = matrix(
      data = c(
        FALSE, FALSE, FALSE, FALSE, FALSE, FALSE,
        TRUE, FALSE, FALSE, FALSE, FALSE, FALSE,
        FALSE, FALSE, FALSE, FALSE, FALSE, FALSE,
        FALSE, FALSE, TRUE, FALSE, FALSE, FALSE,
        FALSE, FALSE, TRUE, TRUE, FALSE, FALSE,
        FALSE, FALSE, TRUE, TRUE, TRUE, FALSE
      ),
      byrow = TRUE,
      nrow = 6,
      ncol = 6
    ),
    tau_sqr_l_values = ldl$s_l,
    effects = TRUE,
    set_point = TRUE,
    int_meas = FALSE,
    int_dyn = FALSE,
    cov_meas = FALSE,
    cov_dyn = FALSE,
    robust_v = FALSE,
    robust = FALSE,
    seed = seed,
    silent = TRUE,
    ncores = ncores
  )
  end_time <- Sys.time()
  elapsed <- end_time - start_time
  out <- list(
    output = output,
    elapsed = elapsed
  )
  class(out) <- c(
    "manmetavar.metavar",
    class(out)
  )
  out
}
