#' Fit the Model using the fitDTVARMxID Package
#'
#' The function fits the model using the [fitDTVARMxID] package.
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
#' print(fit)
#' summary(fit)
#' coef(fit)
#' vcov(fit)
#' }
#'
#' @family Model Fitting Functions
#' @keywords manMetaVAR fit
#' @import OpenMx
#' @import fitDTVARMxID
#' @export
FitDTVAR <- function(data,
                     wd = ".",
                     ncores = NULL,
                     seed = NULL) {
  start_time <- Sys.time()
  path <- .CreateFolder(
    x = normalizePath(
      path = wd,
      mustWork = FALSE
    ),
    prefix = "FitDTVAR"
  )
  on.exit(
    unlink(
      x = path,
      recursive = TRUE
    ),
    add = TRUE
  )
  initial <- fitDTVARMxID::FitDTVARMxID(
    data = data$data,
    observed = paste0(
      "y",
      seq_len(data$k)
    ),
    id = "id",
    alpha_fixed = TRUE,
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
    psi_d_free = NULL,
    psi_d_values = NULL,
    psi_d_lbound = NULL,
    psi_d_ubound = NULL,
    psi_l_free = NULL,
    psi_l_values = NULL,
    psi_l_lbound = NULL,
    psi_l_ubound = NULL,
    nu_fixed = FALSE,
    nu_free = NULL,
    nu_values = data$nu,
    nu_lbound = NULL,
    nu_ubound = NULL,
    theta_diag = TRUE,
    theta_fixed = FALSE,
    theta_d_free = NULL,
    theta_d_values = data$theta_d_ldl,
    theta_d_lbound = NULL,
    theta_d_ubound = NULL,
    theta_d_equal = FALSE,
    theta_l_free = NULL,
    theta_l_values = NULL,
    theta_l_lbound = NULL,
    theta_l_ubound = NULL,
    mu0_fixed = TRUE,
    mu0_func = FALSE,
    mu0_free = NULL,
    mu0_values = data$mu0,
    mu0_lbound = NULL,
    mu0_ubound = NULL,
    sigma0_fixed = TRUE,
    sigma0_func = FALSE,
    sigma0_diag = FALSE,
    sigma0_d_free = NULL,
    sigma0_d_values = data$sigma0_d_ldl,
    sigma0_d_lbound = NULL,
    sigma0_d_ubound = NULL,
    sigma0_l_free = NULL,
    sigma0_l_values = data$sigma0_l_ldl,
    sigma0_l_lbound = NULL,
    sigma0_l_ubound = NULL,
    robust = FALSE,
    tries_explore = 100,
    tries_local = 100,
    max_attempts = 10,
    grad_tol = 1e-2,
    hess_tol = 1e-8,
    eps = 1e-6,
    factor = 10,
    overwrite = FALSE,
    path = path,
    prefix = "FitDTVARinit",
    seed = seed,
    silent = TRUE,
    ncores = ncores,
    clean = TRUE
  )
  fixed_theta <- metaVAR::MetaVARMx(
    object = initial,
    x = NULL,
    alpha_values = data$theta_d_ldl,
    alpha_free = NULL,
    alpha_lbound = NULL,
    alpha_ubound = NULL,
    gamma_values = NULL,
    gamma_free = NULL,
    gamma_lbound = NULL,
    gamma_ubound = NULL,
    tau_sqr_d_free = NULL,
    tau_sqr_d_values = NULL,
    tau_sqr_d_lbound = NULL,
    tau_sqr_d_ubound = NULL,
    tau_sqr_l_free = NULL,
    tau_sqr_l_values = NULL,
    tau_sqr_l_lbound = NULL,
    tau_sqr_l_ubound = NULL,
    random = FALSE,
    diag = FALSE,
    effects = FALSE,
    int_meas = FALSE,
    int_dyn = FALSE,
    cov_meas = TRUE,
    cov_dyn = FALSE,
    converged = TRUE,
    grad_tol = 1e-2,
    hess_tol = 1e-8,
    vanishing_theta = TRUE,
    theta_tol = 0.01,
    try = 1000,
    ncores = ncores
  )
  output <- fitDTVARMxID::FitDTVARMxID(
    data = data$data,
    observed = paste0(
      "y",
      seq_len(data$k)
    ),
    id = "id",
    alpha_fixed = TRUE,
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
    psi_d_free = NULL,
    psi_d_values = NULL,
    psi_d_lbound = NULL,
    psi_d_ubound = NULL,
    psi_l_free = NULL,
    psi_l_values = NULL,
    psi_l_lbound = NULL,
    psi_l_ubound = NULL,
    nu_fixed = FALSE,
    nu_free = NULL,
    nu_values = data$nu,
    nu_lbound = NULL,
    nu_ubound = NULL,
    theta_diag = TRUE,
    theta_fixed = TRUE,
    theta_d_free = NULL,
    theta_d_values = coef(fixed_theta),
    theta_d_lbound = NULL,
    theta_d_ubound = NULL,
    theta_d_equal = FALSE,
    theta_l_free = NULL,
    theta_l_values = NULL,
    theta_l_lbound = NULL,
    theta_l_ubound = NULL,
    mu0_fixed = TRUE,
    mu0_func = FALSE,
    mu0_free = NULL,
    mu0_values = data$mu0,
    mu0_lbound = NULL,
    mu0_ubound = NULL,
    sigma0_fixed = TRUE,
    sigma0_func = FALSE,
    sigma0_diag = FALSE,
    sigma0_d_free = NULL,
    sigma0_d_values = data$sigma0_d_ldl,
    sigma0_d_lbound = NULL,
    sigma0_d_ubound = NULL,
    sigma0_l_free = NULL,
    sigma0_l_values = data$sigma0_l_ldl,
    sigma0_l_lbound = NULL,
    sigma0_l_ubound = NULL,
    robust = FALSE,
    tries_explore = 100,
    tries_local = 100,
    max_attempts = 10,
    grad_tol = 1e-2,
    hess_tol = 1e-8,
    eps = 1e-6,
    factor = 10,
    overwrite = FALSE,
    path = path,
    prefix = "FitDTVAR",
    seed = seed,
    silent = TRUE,
    ncores = ncores,
    clean = TRUE
  )
  end_time <- Sys.time()
  elapsed <- end_time - start_time
  structure(
    list(
      initial = initial,
      initial_converged = fitDTVARMxID::converged(
        object = initial,
        vanishing_theta = TRUE,
        theta_tol = 0.01,
        prop = TRUE
      ),
      output = output,
      output_converged = fitDTVARMxID::converged(
        object = output,
        vanishing_theta = TRUE,
        theta_tol = 0.01,
        prop = TRUE
      ),
      elapsed = elapsed
    ),
    class = "manmetavar.dtvar"
  )
}
