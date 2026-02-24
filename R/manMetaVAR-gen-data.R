#' Simulate Data
#'
#' The function simulates data using
#' the [simStateSpace::SimSSMIVary()] function.
#'
#' @inheritParams Template
#'
#' @examples
#' \dontrun{
#' seed <- 42
#' data <- GenData(taskid = 1, seed = seed)
#' print(data)
#' summary(data)
#' plot(data)
#' }
#'
#' @family Data Generation Functions
#' @keywords manMetaVAR gendata
#' @import simStateSpace
#' @export
GenData <- function(taskid,
                    seed = NULL) {
  start_time <- Sys.time()
  if (isFALSE(is.null(seed))) {
    set.seed(seed)
  }
  param <- params[taskid, ]
  n <- param$n
  time <- param$time
  mu <- simStateSpace::SimNuN(
    n = n,
    nu = model$mu_mu,
    vcov_nu_l = model$mu_sigma_l
  )
  beta <- simStateSpace::SimBetaN(
    n = n,
    beta = model$beta_mu,
    vcov_beta_vec_l = model$beta_sigma_l
  )
  alpha <- mapply(
    FUN = simStateSpace::SSMInterceptEta,
    beta = beta,
    mean_eta = mu,
    SIMPLIFY = FALSE
  )
  mu0 <- mapply(
    FUN = simStateSpace::SSMMeanEta,
    beta = beta,
    alpha = alpha,
    SIMPLIFY = FALSE
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
    FUN = fitVARMxID::LDL
  )
  sigma0_d_ldl <- lapply(
    X = sigma0_ldl,
    FUN = function(i) {
      i$uc_d
    }
  )
  sigma0_l_ldl <- lapply(
    X = sigma0_ldl,
    FUN = function(i) {
      i$s_l
    }
  )
  sim <- simStateSpace::SimSSMVARIVary(
    n = n,
    time = time,
    mu0 = mu0,
    sigma0_l = sigma0_l,
    alpha = alpha,
    beta = beta,
    psi_l = list(model$psi_l),
    type = 0,
    x = NULL,
    gamma = NULL
  )
  data <- as.data.frame(sim)
  end_time <- Sys.time()
  elapsed <- end_time - start_time
  out <- list(
    param = param,
    mu = mu,
    beta = beta,
    mu0 = mu0,
    sigma0 = sigma0,
    sigma0_l = sigma0_l,
    sigma0_d_ldl = sigma0_d_ldl,
    sigma0_l_ldl = sigma0_l_ldl,
    sim = sim,
    data = data,
    elapsed = elapsed
  )
  class(out) <- c(
    "manmetavar.data",
    class(out)
  )
  out
}
