#' Multivariate Meta-Analysis for the Four-Variable Model
#'
#' The function performs multivariate meta-analysis for the four-variable
#' feasibility model using the [metaDyn] package. The random-effects covariance
#' matrix is diagonal, consistent with the population specification in
#' `modelk4`.
#'
#' @inheritParams Template
#' @param fit R object.
#'   Output of the [FitDTVARK4()] function.
#'
#' @examples
#' \dontrun{
#' seed <- 42
#' data <- GenDataK4(taskid = 1, seed = seed)
#' fit <- FitDTVARK4(data = data, seed = seed)
#' meta <- FitMetaVARK4(fit = fit, seed = seed)
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
FitMetaVARK4 <- function(fit,
                         ncores = NULL,
                         seed = NULL) {
  start_time <- Sys.time()
  k <- modelk4$k
  q <- k * k
  p <- k + q
  data <- as.data.frame(
    summary(
      fit,
      means = FALSE
    )[, seq_len(p), drop = FALSE]
  )
  means <- colMeans(
    data,
    na.rm = TRUE
  )
  covariances <- stats::var(
    data,
    na.rm = TRUE
  )
  # Match modelk4: all random-effect covariances are fixed to zero.
  covariances[
    row(covariances) != col(covariances)
  ] <- 0
  ldl <- metaDyn:::.MxHelperLDL(
    covariances
  )
  output <- MetaVARMx(
    object = fit$output,
    x = NULL,
    random = TRUE,
    alpha_values = means,
    tau_sqr_diag = TRUE,
    tau_sqr_d_free = TRUE,
    tau_sqr_d_values = ldl$uc_d,
    tau_sqr_l_free = NULL,
    tau_sqr_l_values = NULL,
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
