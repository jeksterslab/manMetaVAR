#' Simulate Data
#'
#' The function simulates data using
#' the [simStateSpace::SimSSMIVary()] function.
#'
#' @inheritParams Template
#'
#' @examples
#' \dontrun{
#' set.seed(42)
#' data <- GenData(taskid = 1)
#' }
#' @family Data Generation Functions
#' @keywords manMetaVAR gendata
#' @import simStateSpace
#' @export
GenData <- function(taskid) {
  param <- params[taskid, ]
  n <- param$n
  time <- param$time
  alpha <- simStateSpace::SimAlphaN(
    n = n,
    alpha = model$alpha_mu,
    vcov_alpha_l = model$alpha_sigma_l
  )
  beta <- simStateSpace::SimBetaN2(
    n = n,
    beta = model$beta_mu,
    vcov_beta_vec_l = model$beta_sigma_l
  )
  mu0 <- mapply(
    FUN = simStateSpace::SSMMeanEta,
    beta = model$beta_mu,
    alpha = model$alpha_mu
  )
  sigma0 <- lapply(
    X = model$beta_mu,
    FUN = simStateSpace::SSMCovEta,
    psi = model$psi
  )
  sigma0_l <- lapply(
    X = sigma0,
    FUN = function(x) {
      t(chol(x))
    }
  )
  sim <- simStateSpace::SimSSMIVary(
    n = n,
    time = time,
    mu0 = mu0,
    sigma0_l = sigma0_l,
    alpha = alpha,
    beta = beta,
    psi_l = list(model$psi_l),
    nu = list(model$nu),
    lambda = list(model$lambda),
    theta_l = list(model$theta_l),
    type = 0,
    x = NULL,
    gamma = NULL,
    kappa = NULL
  )
  structure(
    list(
      sim = sim,
      alpha = alpha,
      beta = beta,
      data = as.data.frame(sim)
    ),
    class = "manmetavar_data"
  )
}
