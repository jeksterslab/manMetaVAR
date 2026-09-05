#' Fit the Four-Variable Model using the fitVARMxID Package
#'
#' The function fits the four-variable feasibility model using the
#' [fitVARMxID] package.
#'
#' @inheritParams Template
#' @param data R object.
#'   Output of the [GenDataK4()] function.
#'
#' @examples
#' \dontrun{
#' seed <- 42
#' data <- GenDataK4(taskid = 1, seed = seed)
#' fit <- FitDTVARK4(data = data, seed = seed)
#' print(fit)
#' summary(fit)
#' coef(fit)
#' vcov(fit)
#' }
#'
#' @family Model Fitting Functions
#' @keywords manMetaVAR fit
#' @import OpenMx
#' @import fitVARMxID
#' @export
FitDTVARK4 <- function(data,
                       ncores = NULL,
                       seed = NULL) {
  start_time <- Sys.time()
  output <- FitVARMxID(
    data = data$data,
    observed = paste0(
      "y",
      seq_len(modelk4$k)
    ),
    id = "id",
    time = NULL,
    ct = FALSE,
    center = TRUE,
    mu_fixed = FALSE,
    mu_free = NULL,
    mu_values = data$mu,
    mu_lbound = NULL,
    mu_ubound = NULL,
    alpha_fixed = FALSE,
    alpha_free = NULL,
    alpha_values = NULL,
    alpha_lbound = NULL,
    alpha_ubound = NULL,
    beta_fixed = FALSE,
    beta_free = NULL,
    beta_values = data$beta,
    beta_lbound = NULL,
    beta_ubound = NULL,
    psi_diag = FALSE,
    psi_fixed = FALSE,
    psi_d_free = NULL,
    psi_d_values = modelk4$psi_d_ldl,
    psi_d_lbound = NULL,
    psi_d_ubound = NULL,
    psi_d_equal = FALSE,
    psi_l_free = NULL,
    psi_l_values = modelk4$psi_l_ldl,
    psi_l_lbound = NULL,
    psi_l_ubound = NULL,
    nu_fixed = TRUE,
    nu_free = NULL,
    nu_values = NULL,
    nu_lbound = NULL,
    nu_ubound = NULL,
    theta_diag = TRUE,
    theta_fixed = TRUE,
    theta_d_free = NULL,
    theta_d_values = NULL,
    theta_d_lbound = NULL,
    theta_d_ubound = NULL,
    theta_d_equal = FALSE,
    theta_l_free = NULL,
    theta_l_values = NULL,
    theta_l_lbound = NULL,
    theta_l_ubound = NULL,
    mu0_fixed = TRUE,
    mu0_func = TRUE,
    mu0_free = NULL,
    mu0_values = NULL,
    mu0_lbound = NULL,
    mu0_ubound = NULL,
    sigma0_fixed = TRUE,
    sigma0_func = TRUE,
    sigma0_diag = FALSE,
    sigma0_d_free = NULL,
    sigma0_d_values = NULL,
    sigma0_d_lbound = NULL,
    sigma0_d_ubound = NULL,
    sigma0_d_equal = FALSE,
    sigma0_l_free = NULL,
    sigma0_l_values = NULL,
    sigma0_l_lbound = NULL,
    sigma0_l_ubound = NULL,
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
    "manmetavar.dtvar",
    class(out)
  )
  out
}
