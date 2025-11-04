#' Process Dynamics
#'
#' @inheritParams Template
#'
#' @examples
#' # stable reciprocal regulation,
#' Dynamics(dynamics = 1)
#' # escalating co-activation
#' Dynamics(dynamics = 2)
#' # adaptive recovery
#' Dynamics(dynamics = 3)
#'
#' @family Data Generation Functions
#' @keywords manMetaVAR gendata
#' @import simStateSpace
#' @export
Dynamics <- function(dynamics) {
  p <- k <- 2
  lambda <- diag(k)
  theta <- matrix(
    data = c(
      0.50, 0.00,
      0.00, 0.50
    ),
    nrow = p,
    ncol = p
  )
  alpha <- rep(
    x = 0,
    times = p
  )
  if (dynamics == 1) {
    nu_mu <- c(
      0.5,
      -0.5
    )
    nu_sigma <- matrix(
      data = c(
        0.10, -0.05,
        -0.05, 0.10
      ),
      nrow = k
    )
    beta_mu <- matrix(
      data = c(
        0.70, -0.15,
        -0.20, 0.65
      ),
      nrow = p,
      ncol = p
    )
    beta_sigma <- matrix(
      data = c(
        0.020, 0.010, 0.000, 0.000,
        0.010, 0.015, 0.000, 0.000,
        0.000, 0.000, 0.010, 0.005,
        0.000, 0.000, 0.005, 0.015
      ),
      nrow = p * p
    )
    psi <- matrix(
      data = c(
        0.20, -0.05,
        -0.05, 0.18
      ),
      nrow = p,
      ncol = p
    )
  }
  if (dynamics == 2) {
    nu_mu <- c(
      1.0,
      1.0
    )
    nu_sigma <- matrix(
      data = c(
        0.25, 0.20,
        0.20, 0.25
      ),
      nrow = k
    )
    beta_mu <- matrix(
      data = c(
        0.80, 0.20,
        0.25, 0.85
      ),
      nrow = p,
      ncol = p
    )
    beta_sigma <- matrix(
      data = c(
        0.040, 0.020, 0.015, 0.010,
        0.020, 0.030, 0.010, 0.015,
        0.015, 0.010, 0.030, 0.020,
        0.010, 0.015, 0.020, 0.040
      ),
      nrow = p * p
    )
    psi <- matrix(
      data = c(
        0.35, 0.20,
        0.20, 0.40
      ),
      nrow = p,
      ncol = p
    )
  }
  if (dynamics == 3) {
    nu_mu <- c(
      0.8,
      0.5
    )
    nu_sigma <- matrix(
      data = c(
        0.15, 0.05,
        0.05, 0.10
      ),
      nrow = k
    )
    beta_mu <- matrix(
      data = c(
        0.60, 0.25,
        -0.30, 0.70
      ),
      nrow = p,
      ncol = p
    )
    beta_sigma <- matrix(
      data = c(
        0.025, 0.010, 0.000, 0.000,
        0.010, 0.020, 0.000, 0.000,
        0.000, 0.000, 0.020, 0.010,
        0.000, 0.000, 0.010, 0.025
      ),
      nrow = p * p
    )
    psi <- matrix(
      data = c(
        0.25, -0.10,
        -0.10, 0.22
      ),
      nrow = p,
      ncol = p
    )
  }
  theta_ldl <- fitDTVARMxID::LDL(theta)
  theta_d_ldl <- theta_ldl$d_uc
  theta_l_ldl <- theta_ldl$l_mat_strict
  psi_ldl <- fitDTVARMxID::LDL(psi)
  psi_d_ldl <- psi_ldl$d_uc
  psi_l_ldl <- psi_ldl$l_mat_strict
  ma_fixed <- c(
    c(beta_mu),
    c(nu_mu)
  )
  ma_random <- rbind(
    cbind(
      beta_sigma,
      matrix(
        data = 0,
        nrow = nrow(beta_sigma),
        ncol = ncol(nu_sigma)
      )
    ),
    cbind(
      matrix(
        data = 0,
        nrow = nrow(nu_sigma),
        ncol = ncol(beta_sigma)
      ),
      nu_sigma
    )
  )
  ma_random_ldl <- fitDTVARMxID::LDL(ma_random)
  ma_random_d_ldl <- ma_random_ldl$d_uc
  ma_random_l_ldl <- ma_random_ldl$l_mat_strict
  list(
    p = p,
    k = k,
    lambda = lambda,
    nu_mu = nu_mu,
    nu_sigma = nu_sigma,
    nu_sigma_l = t(chol(nu_sigma)),
    theta = theta,
    theta_l = t(chol(theta)),
    theta_d_ldl = theta_d_ldl,
    theta_l_ldl = theta_l_ldl,
    alpha = alpha,
    beta_mu = beta_mu,
    beta_sigma = beta_sigma,
    beta_sigma_l = t(chol(beta_sigma)),
    psi = psi,
    psi_l = t(chol(psi)),
    psi_d_ldl = psi_d_ldl,
    psi_l_ldl = psi_l_ldl,
    ma_fixed = ma_fixed,
    ma_random = ma_random,
    ma_random_d_ldl = ma_random_d_ldl,
    ma_random_l_ldl = ma_random_l_ldl
  )
}
