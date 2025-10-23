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
#' print(data)
#' summary(data)
#' plot(data)
#' }
#'
#' @family Data Generation Functions
#' @keywords manMetaVAR gendata
#' @import simStateSpace
#' @export
GenData <- function(taskid) {
  param <- params[taskid, ]
  burnin <- 10000
  n <- param$n
  time <- param$time + burnin
  dynamics <- param$dynamics
  model <- Dynamics(dynamics = dynamics)
  nu <- simStateSpace::SimNuN(
    n = n,
    nu = model$nu_mu,
    vcov_nu_l = model$nu_sigma_l
  )
  beta <- simStateSpace::SimBetaN(
    n = n,
    beta = model$beta_mu,
    vcov_beta_vec_l = model$beta_sigma_l,
    margin = 0.95
  )
  mu0 <- lapply(
    X = beta,
    FUN = simStateSpace::SSMMeanEta,
    alpha = model$alpha
  )
  sigma0 <- lapply(
    X = beta,
    FUN = simStateSpace::SSMCovEta,
    psi = model$psi
  )
  sigma0_l <- lapply(
    X = sigma0,
    FUN = function(x) {
      t(chol(x))
    }
  )
  sigma0_ldl <- lapply(
    X = sigma0,
    FUN = fitDTVARMxID::LDL
  )
  sigma0_d_ldl <- lapply(
    X = sigma0_ldl,
    FUN = function(i) {
      i$d_uc
    }
  )
  sigma0_l_ldl <- lapply(
    X = sigma0_ldl,
    FUN = function(i) {
      i$l_mat_strict
    }
  )
  sim <- simStateSpace::SimSSMIVary(
    n = n,
    time = time,
    mu0 = mu0,
    sigma0_l = sigma0_l,
    alpha = list(model$alpha),
    beta = beta,
    psi_l = list(model$psi_l),
    nu = nu,
    lambda = list(model$lambda),
    theta_l = list(model$theta_l),
    type = 0,
    x = NULL,
    gamma = NULL,
    kappa = NULL
  )
  out <- c(
    as.list(param),
    burnin = burnin,
    model,
    nu = list(nu),
    beta = list(beta),
    mu0 = list(mu0),
    sigma0 = list(sigma0),
    sigma0_l = list(sigma0_l),
    sigma0_d_ldl = list(sigma0_d_ldl),
    sigma0_l_ldl = list(sigma0_l_ldl),
    sim = list(sim),
    data = list(
      as.data.frame(
        sim,
        burnin = burnin
      )
    )
  )
  structure(
    out,
    class = "manmetavar.data"
  )
}
