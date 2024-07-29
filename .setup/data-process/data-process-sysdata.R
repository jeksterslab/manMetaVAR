data_process_sysdata <- function() {
  cat("\ndata_process_sysdata\n")
  set.seed(42)
  # find root directory
  root <- rprojroot::is_rstudio_project
  k <- p <- 2
  iden <- diag(k)
  null_vec <- rep(x = 0, times = k)
  null_mat <- matrix(
    data = 0,
    nrow = p,
    ncol = p
  )
  mu0 <- null_vec
  sigma0 <- null_mat
  sigma0_l <- null_mat
  alpha_mu <- c(
    2.87,
    2.04
  )
  alpha_d <- sqrt(
    c(1.2, 1.1)
  ) * iden
  alpha_r <- matrix(
    data = c(1, 0.4, 0.4, 1),
    nrow = p
  )
  alpha_sigma <- alpha_d %*% alpha_r %*% alpha_d
  alpha_sigma_l <- t(chol(alpha_sigma))
  alpha_lbound <- rep(
    x = -10,
    times = k
  )
  alpha_ubound <- rep(
    x = +10,
    times = k
  )
  psi_d <- sqrt(
    c(1.3, 1.56)
  ) * iden
  psi_r <- matrix(
    data = c(1, 0.4, 0.4, 1),
    nrow = p
  )
  psi <- psi_d %*% psi_r %*% psi_d
  psi[upper.tri(psi)] <- t(psi)[upper.tri(psi)]
  psi_l <- t(chol(psi))
  beta_mu <- matrix(
    data = c(
      0.28, -0.035,
      -0.048, 0.26
    ),
    nrow = p
  )
  beta_d <- sqrt(
    c(
      0.0169,
      0.00810,
      0.000784,
      0.0256
    )
  ) * diag(p * p)
  beta_r <- matrix(
    data = c(
      1, 0.4, 0.4, 0.4,
      0.4, 1, 0.4, 0.4,
      0.4, 0.4, 1, 0.4,
      0.4, 0.4, 0.4, 1
    ),
    nrow = p * p
  )
  beta_sigma <- beta_d %*% beta_r %*% beta_d
  beta_sigma[upper.tri(beta_sigma)] <- t(beta_sigma)[upper.tri(beta_sigma)]
  beta_sigma_l <- t(chol(beta_sigma))
  nu <- null_vec
  lambda <- iden
  theta <- 0.2 * iden
  theta_l <- t(chol(theta))
  beta_lbound <- matrix(
    data = -1,
    nrow = p,
    ncol = p
  )
  beta_ubound <- matrix(
    data = +1,
    nrow = p,
    ncol = p
  )
  psi_lbound <- matrix(
    data = -5,
    nrow = p,
    ncol = p
  )
  psi_ubound <- matrix(
    data = +5,
    nrow = p,
    ncol = p
  )
  diag(psi_lbound) <- .Machine$double.xmin
  theta_lbound <- .Machine$double.xmin * diag(p)
  theta_ubound <- diag(p)
  mu <- c(
    c(beta_mu),
    alpha_mu
  )
  q <- length(mu)
  mu_lbound <- rep(
    x = -10,
    times = q
  )
  mu_ubound <- rep(
    x = +10,
    times = q
  )
  sigma <- matrix(
    data = 0,
    nrow = q,
    ncol = q
  )
  sigma[seq_len(p^2), seq_len(p^2)] <- beta_sigma
  sigma[(p^2 + 1):q, (p^2 + 1):q] <- alpha_sigma
  sigma_lbound <- sigma_ubound <- matrix(
    data = NA,
    nrow = q,
    ncol = q
  )
  diag(sigma_lbound) <- .Machine$double.xmin
  model <- list(
    p = p,
    k = k,
    mu0 = mu0,
    sigma0 = sigma0,
    sigma0_l = sigma0_l,
    alpha_mu = alpha_mu,
    alpha_sigma = alpha_sigma,
    alpha_sigma_l = alpha_sigma_l,
    beta_mu = beta_mu,
    beta_sigma = beta_sigma,
    beta_sigma_l = beta_sigma_l,
    psi = psi,
    psi_l = psi_l,
    nu = nu,
    lambda = lambda,
    theta = theta,
    theta_l = theta_l,
    mu = mu,
    sigma = sigma,
    alpha_lbound = alpha_lbound,
    alpha_ubound = alpha_ubound,
    beta_lbound = beta_lbound,
    beta_ubound = beta_ubound,
    psi_lbound = psi_lbound,
    psi_ubound = psi_ubound,
    theta_lbound = theta_lbound,
    theta_ubound = theta_ubound
  )
  usethis::use_data(
    model,
    internal = TRUE,
    overwrite = TRUE
  )
}
data_process_sysdata()
rm(data_process_sysdata)
