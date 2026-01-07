data_process_fisher2017_empirical_dynamics <- function(overwrite = FALSE) {
  cat("\ndata_process_fisher2017_empirical_dynamics\n")
  set.seed(42)
  # find root directory
  root <- rprojroot::is_rstudio_project
  output <- root$find_file(
    ".setup",
    "data-raw",
    "fisher2017-empirical-dynamics.Rds"
  )
  source(
    root$find_file(
      ".setup",
      "data-process",
      "data-process-fisher2017-between.R"
    )
  )
  source(
    root$find_file(
      ".setup",
      "data-process",
      "data-process-fisher2017-ema.R"
    )
  )
  if (!file.exists(output)) {
    write <- TRUE
  } else {
    if (overwrite) {
      write <- TRUE
    } else {
      write <- FALSE
    }
  }
  if (write) {
    library(OpenMx)
    library(fitDTVARMxID)
    library(metaVAR)
    data <- readRDS(
      root$find_file(
        ".setup",
        "data-raw",
        "fisher2017-ema.Rds"
      )
    )
    path <- root$find_file(
      ".setup",
      "notes"
    )
    fit <- FitDTVARMxID(
      data = data,
      observed = c("na", "pa"),
      id = "id",
      alpha_fixed = TRUE,
      beta_free = matrix(
        data = c(
          TRUE, FALSE,
          FALSE, TRUE
        ),
        nrow = 2,
        ncol = 2
      ),
      beta_lbound = matrix(
        data = 0,
        nrow = 2,
        ncol = 2
      ),
      nu_fixed = FALSE,
      psi_diag = TRUE,
      tries_explore = 1000,
      tries_local = 1000,
      max_attempts = 100,
      ncores = parallel::detectCores(),
      path = path
    )
    summary(fit)
    converged(fit, prop = TRUE)
    fixed_theta <- MetaVARMx(
      fit,
      random = FALSE, # TRUE by default
      effects = FALSE, # TRUE by default
      cov_meas = TRUE, # FALSE by default
      theta_tol = 0.01
    )
    fit <- FitDTVARMxID(
      data = data,
      observed = c("na", "pa"),
      id = "id",
      alpha_fixed = TRUE,
      beta_free = matrix(
        data = c(
          TRUE, FALSE,
          FALSE, TRUE
        ),
        nrow = 2,
        ncol = 2
      ),
      beta_lbound = matrix(
        data = 0,
        nrow = 2,
        ncol = 2
      ),
      nu_fixed = FALSE,
      psi_diag = TRUE,
      theta_fixed = TRUE,
      theta_d_values = coef(fixed_theta),
      tries_explore = 1000,
      tries_local = 1000,
      max_attempts = 100,
      ncores = parallel::detectCores(),
      path = path
    )
    summary(fit)
    converged(fit, prop = TRUE)
    saveRDS(
      object = fit,
      file = output
    )
  }
}
data_process_fisher2017_empirical_dynamics()
rm(data_process_fisher2017_empirical_dynamics)
