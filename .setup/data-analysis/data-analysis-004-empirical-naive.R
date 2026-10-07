data_analysis_adid2010_naive <- function(overwrite = FALSE) {
  set.seed(42)

  root <- rprojroot::is_rstudio_project

  input <- root$find_file(
    ".setup",
    "data-raw",
    "adid2010-stage-1.Rds"
  )

  output <- root$find_file(
    ".setup",
    "data-raw",
    "adid2010-naive.Rds"
  )

  source(
    root$find_file(
      ".setup",
      "data-analysis",
      "data-analysis-002-empirical-stage-1.R"
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

  if (!file.exists(input)) {
    write <- FALSE
  }

  if (write) {
    cat("\ndata_analysis_adid2010_naive\n")

    Sys.setenv(
      OMP_NUM_THREADS = "1",
      MKL_NUM_THREADS = "1",
      OPENBLAS_NUM_THREADS = "1"
    )

    library(fitVARMxID)
    library(OpenMx)

    stage1 <- readRDS(
      file = input
    )

    start_time <- Sys.time()

    # ----------------------------------------------------------
    # Extract person-specific parameter estimates
    # ----------------------------------------------------------

    data <- as.data.frame(
      summary(
        object = stage1,
        means = FALSE,
        mu = TRUE,
        alpha = FALSE,
        beta = TRUE,
        nu = FALSE,
        psi = TRUE,
        theta = FALSE,
        ncores = parallel::detectCores()
      )
    )

    expected_ncol <- 9L

    if (ncol(data) != expected_ncol) {
      stop(
        paste0(
          "Expected nine Stage 1 parameter estimates, but found ",
          ncol(data),
          ".\n\n",
          "Observed parameter names:\n",
          paste(
            colnames(data),
            collapse = "\n"
          )
        ),
        call. = FALSE
      )
    }

    colnames(data) <- c(
      "mu11",
      "mu21",
      "beta11",
      "beta21",
      "beta12",
      "beta22",
      "psi11",
      "psi21",
      "psi22"
    )

    data[] <- lapply(
      X = data,
      FUN = as.numeric
    )

    if (nrow(data) < 2L) {
      stop(
        paste0(
          "At least two person-specific estimates are required ",
          "for the naive analysis."
        ),
        call. = FALSE
      )
    }

    finite_rows <- apply(
      X = data,
      MARGIN = 1L,
      FUN = function(x) {
        all(is.finite(x))
      }
    )

    if (!all(finite_rows)) {
      stop(
        paste0(
          "Nonfinite Stage 1 parameter estimates were found for ",
          sum(!finite_rows),
          " participant(s)."
        ),
        call. = FALSE
      )
    }

    # ----------------------------------------------------------
    # Basic dimensions
    # ----------------------------------------------------------

    n <- nrow(data)
    p <- ncol(data)

    parameter_names <- colnames(data)

    # ----------------------------------------------------------
    # OpenMx saturated multivariate normal model
    # ----------------------------------------------------------

    mu_start <- matrix(
      data = colMeans(data),
      nrow = 1,
      ncol = p
    )

    mu_labels <- matrix(
      data = paste0(
        "mean_",
        parameter_names
      ),
      nrow = 1,
      ncol = p
    )

    mu <- mxMatrix(
      type = "Full",
      nrow = 1,
      ncol = p,
      free = TRUE,
      values = mu_start,
      labels = mu_labels,
      dimnames = list(
        "mu",
        parameter_names
      ),
      name = "mu"
    )

    sigma_start <- stats::cov(data) * ((n - 1) / n)

    sigma_labels <- matrix(
      data = NA_character_,
      nrow = p,
      ncol = p
    )

    for (j in seq_len(p)) {
      for (i in seq_len(p)) {
        sigma_labels[i, j] <-
          sigma_labels[j, i] <- paste0(
            "sigma_",
            parameter_names[min(i, j)],
            "_",
            parameter_names[max(i, j)]
          )
      }
    }

    sigma_lbound <- matrix(
      data = NA_real_,
      nrow = p,
      ncol = p
    )

    diag(sigma_lbound) <- 0

    sigma <- mxMatrix(
      type = "Symm",
      nrow = p,
      ncol = p,
      free = TRUE,
      values = sigma_start,
      labels = sigma_labels,
      lbound = sigma_lbound,
      dimnames = list(
        parameter_names,
        parameter_names
      ),
      name = "sigma"
    )

    model <- mxModel(
      model = "Naive",
      mu,
      sigma,
      mxData(
        observed = data,
        type = "raw"
      ),
      mxExpectationNormal(
        covariance = "sigma",
        means = "mu",
        dimnames = parameter_names
      ),
      mxFitFunctionML()
    )

    # model <- mxRun(
    #   model,
    #   intervals = FALSE,
    #   silent = TRUE
    # )

    model <- mxTryHard(
      model,
      extraTries = 1000,
      greenOK = TRUE,
      checkHess = TRUE,
      bestInitsOutput = FALSE,
      intervals = FALSE,
      silent = TRUE
    )

    # ----------------------------------------------------------
    # Extract estimates
    # ----------------------------------------------------------

    estimates <- omxGetParameters(
      model
    )

    vcov_estimates <- vcov(
      model
    )

    if (
      is.null(vcov_estimates) ||
        any(dim(vcov_estimates) == 0L)
    ) {
      stop(
        "vcov(model) could not be computed.",
        call. = FALSE
      )
    }

    standard_errors <- sqrt(
      diag(vcov_estimates)
    )

    confidence_level <- 0.95

    critical_value <- qnorm(
      p = 1 - (1 - confidence_level) / 2
    )

    confidence_lower <- estimates -
      critical_value * standard_errors

    confidence_upper <- estimates +
      critical_value * standard_errors

    # ----------------------------------------------------------
    # Means
    # ----------------------------------------------------------

    mean_names <- paste0(
      "mean_",
      parameter_names
    )

    means <- estimates[
      mean_names
    ]

    se_means <- standard_errors[
      mean_names
    ]

    vcov_means <- vcov_estimates[
      mean_names,
      mean_names,
      drop = FALSE
    ]

    means_table <- data.frame(
      parameter = parameter_names,
      estimate = as.numeric(means),
      se = as.numeric(se_means),
      lower = as.numeric(
        confidence_lower[mean_names]
      ),
      upper = as.numeric(
        confidence_upper[mean_names]
      ),
      row.names = NULL
    )

    # ----------------------------------------------------------
    # Covariances
    # ----------------------------------------------------------

    covariances <- model$sigma$values

    vech_indices <- which(
      lower.tri(
        x = covariances,
        diag = TRUE
      ),
      arr.ind = TRUE
    )

    q <- nrow(
      vech_indices
    )

    covariance_names <- character(q)
    covariance_vector <- numeric(q)
    covariance_lhs <- character(q)
    covariance_rhs <- character(q)
    se_covariance_vector <- numeric(q)

    for (a in seq_len(q)) {
      i <- vech_indices[a, 1L]
      j <- vech_indices[a, 2L]

      covariance_lhs[a] <- parameter_names[i]
      covariance_rhs[a] <- parameter_names[j]

      covariance_names[a] <- paste0(
        "sigma_",
        parameter_names[min(i, j)],
        "_",
        parameter_names[max(i, j)]
      )

      covariance_vector[a] <- estimates[
        covariance_names[a]
      ]

      se_covariance_vector[a] <- standard_errors[
        covariance_names[a]
      ]
    }

    names(covariance_vector) <- covariance_names
    names(se_covariance_vector) <- covariance_names

    missing_covariance_names <- setdiff(
      covariance_names,
      rownames(vcov_estimates)
    )

    if (length(missing_covariance_names) > 0L) {
      stop(
        paste0(
          "Missing covariance parameters in vcov(model):\n\n",
          paste(
            missing_covariance_names,
            collapse = "\n"
          )
        ),
        call. = FALSE
      )
    }

    vcov_covariances <- vcov_estimates[
      covariance_names,
      covariance_names,
      drop = FALSE
    ]

    se_covariances <- matrix(
      data = NA_real_,
      nrow = p,
      ncol = p,
      dimnames = list(
        parameter_names,
        parameter_names
      )
    )

    for (a in seq_len(q)) {
      i <- vech_indices[a, 1L]
      j <- vech_indices[a, 2L]

      se_covariances[i, j] <-
        se_covariance_vector[a]

      se_covariances[j, i] <-
        se_covariance_vector[a]
    }

    covariances_table <- data.frame(
      lhs = covariance_lhs,
      rhs = covariance_rhs,
      parameter = covariance_names,
      estimate = as.numeric(
        covariance_vector
      ),
      se = as.numeric(
        se_covariance_vector
      ),
      lower = as.numeric(
        confidence_lower[covariance_names]
      ),
      upper = as.numeric(
        confidence_upper[covariance_names]
      ),
      row.names = NULL
    )

    # ----------------------------------------------------------
    # Full parameter table
    # ----------------------------------------------------------

    estimates_table <- data.frame(
      parameter = names(estimates),
      estimate = as.numeric(estimates),
      se = as.numeric(standard_errors),
      lower = as.numeric(confidence_lower),
      upper = as.numeric(confidence_upper),
      row.names = NULL
    )

    end_time <- Sys.time()

    elapsed <- end_time - start_time

    # ----------------------------------------------------------
    # Save results
    # ----------------------------------------------------------

    out <- list(
      output = model,
      estimates = estimates,
      standard_errors = standard_errors,
      vcov = vcov_estimates,
      means = means,
      se_means = se_means,
      vcov_means = vcov_means,
      covariances = covariances,
      se_covariances = se_covariances,
      covariance_vector = covariance_vector,
      se_covariance_vector = se_covariance_vector,
      vcov_covariances = vcov_covariances,
      tables = list(
        estimates = estimates_table,
        means = means_table,
        covariances = covariances_table
      ),
      confidence_level = confidence_level,
      data = data,
      elapsed = elapsed
    )

    class(out) <- c(
      "manmetavar.naive",
      class(out)
    )

    saveRDS(
      object = out,
      file = output
    )
  }
}

data_analysis_adid2010_naive()

rm(
  data_analysis_adid2010_naive
)
