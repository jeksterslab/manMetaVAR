data_process_model <- function(overwrite = FALSE) {
  cat("\ndata_process_model\n")
  set.seed(42)
  # find root directory
  root <- rprojroot::is_rstudio_project
  data_folder <- root$find_file(
    "data"
  )
  if (!dir.exists(data_folder)) {
    dir.create(
      data_folder,
      recursive = TRUE
    )
  }
  model_file <- file.path(
    data_folder,
    "model.rda"
  )
  if (!file.exists(model_file)) {
    write <- TRUE
  } else {
    if (overwrite) {
      write <- TRUE
    } else {
      write <- FALSE
    }
  }
  if (write) {
    k <- 2
    mu_mu <- c(
      2.87,
      2.04
    )
    mu_var <- c(
      1.2,
      1.1
    )
    mu_r <- matrix(
      data = 0.40,
      nrow = k,
      ncol = k
    )
    diag(mu_r) <- 1
    mu_d <- diag(
      sqrt(mu_var)
    )
    mu_sigma <- mu_d %*% mu_r %*% mu_d
    beta_mu <- matrix(
      data = c(
        0.28,
        -0.035,
        -0.048,
        0.26
      ),
      nrow = k,
      ncol = k
    )
    beta_var <- c(
      0.0169,
      0.00810,
      0.000784,
      0.0256
    )
    beta_r <- matrix(
      data = 0.40,
      nrow = k * k,
      ncol = k * k
    )
    diag(beta_r) <- 1
    beta_d <- diag(
      sqrt(beta_var)
    )
    beta_sigma <- beta_d %*% beta_r %*% beta_d
    psi_var <- c(
      1.3,
      1.56
    )
    psi_r <- matrix(
      data = 0.40,
      nrow = k,
      ncol = k
    )
    diag(psi_r) <- 1
    psi_d <- diag(
      sqrt(psi_var)
    )
    psi <- psi_d %*% psi_r %*% psi_d
    psi_ldl <- fitVARMxID::LDL(psi)
    psi_d_ldl <- psi_ldl$uc_d
    psi_l_ldl <- psi_ldl$s_l
    ma_fixed <- c(
      c(mu_mu),
      c(beta_mu)
    )
    ma_random <- rbind(
      cbind(
        mu_sigma,
        matrix(
          data = 0,
          nrow = nrow(mu_sigma),
          ncol = ncol(beta_sigma)
        )
      ),
      cbind(
        matrix(
          data = 0,
          nrow = nrow(beta_sigma),
          ncol = ncol(mu_sigma)
        ),
        beta_sigma
      )
    )
    ma_random_ldl <- fitVARMxID::LDL(ma_random)
    ma_random_d_ldl <- ma_random_ldl$uc_d
    ma_random_l_ldl <- ma_random_ldl$s_l
    model <- list(
      k = k,
      mu_mu = mu_mu,
      mu_sigma = mu_sigma,
      mu_sigma_l = t(chol(mu_sigma)),
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
    save(
      model,
      file = model_file,
      compress = "xz"
    )
  }
}
data_process_model()
rm(data_process_model)
