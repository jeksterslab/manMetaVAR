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
  output <- MetaVARMx(
    object = fit$output,
    x = NULL,
    random = TRUE,
    alpha_values = model$ma_fixed,
    tau_sqr_diag = FALSE,
    tau_sqr_d_free = TRUE,
    tau_sqr_d_values = model$ma_random_d_ldl,
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
    tau_sqr_l_values = model$ma_random_l_ldl,
    effects = TRUE,
    set_point = TRUE,
    int_meas = FALSE,
    int_dyn = FALSE,
    cov_meas = FALSE,
    cov_dyn = FALSE,
    robust_v = FALSE,
    robust = FALSE,
    seed = seed,
    tries_explore = 100,
    tries_local = 100,
    max_attempts = 10,
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
