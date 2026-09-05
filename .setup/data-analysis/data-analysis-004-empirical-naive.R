data_analysis_adid2010_naive <- function(overwrite = FALSE) {
  set.seed(42)

  # Find root directory.
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

    stage1 <- readRDS(
      file = input
    )

    start_time <- Sys.time()

    # ----------------------------------------------------------
    # Extract person-specific parameter estimates
    #
    # Parameter order:
    #
    #   Setpoints:
    #     mu11
    #     mu21
    #
    #   Lagged coefficients:
    #     beta11
    #     beta21
    #     beta12
    #     beta22
    #
    #   Process-noise covariance parameters:
    #     psi11
    #     psi21
    #     psi22
    #
    # Variable indexing:
    #   1 = negative affect
    #   2 = positive affect
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

    # Make sure all columns are ordinary numeric vectors.
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
    # Naive population estimates
    #
    # The person-specific Stage 1 point estimates are treated as
    # observed multivariate data. Their Stage 1 sampling
    # uncertainty is ignored.
    # ----------------------------------------------------------

    means <- colMeans(
      x = data
    )

    covariances <- stats::cov(
      x = data
    )

    # stats::cov() uses the unbiased denominator n - 1.
    covariance_denominator <- n - 1L

    # ----------------------------------------------------------
    # Analytic sampling covariance of the estimated means
    #
    # Var(xbar) = Sigma / n
    #
    # The sample covariance matrix is used as a plug-in estimate
    # of Sigma.
    # ----------------------------------------------------------

    vcov_means <- covariances / n

    se_means <- sqrt(
      diag(vcov_means)
    )

    names(se_means) <- parameter_names

    # ----------------------------------------------------------
    # Analytic sampling covariance of covariance estimates
    #
    # Under multivariate normality:
    #
    # Cov(S_ij, S_kl) =
    #
    #   (Sigma_ik Sigma_jl + Sigma_il Sigma_jk) / (n - 1)
    #
    # The sample covariance matrix is used as a plug-in estimate
    # of Sigma.
    # ----------------------------------------------------------

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

    covariance_names <- character(
      length = q
    )

    covariance_vector <- numeric(
      length = q
    )

    covariance_lhs <- character(
      length = q
    )

    covariance_rhs <- character(
      length = q
    )

    for (a in seq_len(q)) {
      i <- vech_indices[a, 1L]
      j <- vech_indices[a, 2L]

      covariance_lhs[a] <- parameter_names[i]
      covariance_rhs[a] <- parameter_names[j]

      covariance_names[a] <- paste0(
        "sigma_",
        parameter_names[i],
        "_",
        parameter_names[j]
      )

      covariance_vector[a] <- covariances[
        i,
        j
      ]
    }

    names(covariance_vector) <- covariance_names

    vcov_covariances <- matrix(
      data = NA_real_,
      nrow = q,
      ncol = q,
      dimnames = list(
        covariance_names,
        covariance_names
      )
    )

    for (a in seq_len(q)) {
      i <- vech_indices[a, 1L]
      j <- vech_indices[a, 2L]

      for (b in seq_len(q)) {
        k <- vech_indices[b, 1L]
        l <- vech_indices[b, 2L]

        vcov_covariances[a, b] <- (
          covariances[i, k] * covariances[j, l] +
            covariances[i, l] * covariances[j, k]
        ) / covariance_denominator
      }
    }

    se_covariance_vector <- sqrt(
      diag(vcov_covariances)
    )

    # ----------------------------------------------------------
    # Matrix of covariance standard errors
    #
    # SE(S_ij) =
    #
    #   sqrt(
    #     (S_ii S_jj + S_ij^2) / (n - 1)
    #   )
    #
    # For a variance:
    #
    # SE(S_ii) = S_ii sqrt(2 / (n - 1))
    # ----------------------------------------------------------

    se_covariances <- matrix(
      data = NA_real_,
      nrow = p,
      ncol = p,
      dimnames = list(
        parameter_names,
        parameter_names
      )
    )

    for (i in seq_len(p)) {
      for (j in seq_len(p)) {
        se_covariances[i, j] <- sqrt(
          (
            covariances[i, i] * covariances[j, j] +
              covariances[i, j]^2
          ) / covariance_denominator
        )
      }
    }

    # ----------------------------------------------------------
    # Joint estimate vector and sampling covariance matrix
    #
    # Under multivariate normality, the sample mean vector and
    # sample covariance matrix are independent. Their analytic
    # cross-covariance block is therefore zero.
    # ----------------------------------------------------------

    mean_names <- paste0(
      "mean_",
      parameter_names
    )

    mean_vector <- means
    names(mean_vector) <- mean_names

    estimates <- c(
      mean_vector,
      covariance_vector
    )

    vcov_estimates <- matrix(
      data = 0,
      nrow = p + q,
      ncol = p + q,
      dimnames = list(
        names(estimates),
        names(estimates)
      )
    )

    vcov_estimates[
      seq_len(p),
      seq_len(p)
    ] <- vcov_means

    covariance_positions <- p + seq_len(q)

    vcov_estimates[
      covariance_positions,
      covariance_positions
    ] <- vcov_covariances

    standard_errors <- sqrt(
      diag(vcov_estimates)
    )

    # ----------------------------------------------------------
    # Wald confidence intervals
    #
    # These are symmetric normal-theory intervals. For variance
    # parameters, the lower bound can be negative.
    # ----------------------------------------------------------

    confidence_level <- 0.95

    critical_value <- stats::qnorm(
      p = 1 - (1 - confidence_level) / 2
    )

    confidence_lower <- estimates -
      critical_value * standard_errors

    confidence_upper <- estimates +
      critical_value * standard_errors

    # ----------------------------------------------------------
    # Convenient parameter tables
    # ----------------------------------------------------------

    means_table <- data.frame(
      parameter = parameter_names,
      estimate = as.numeric(means),
      se = as.numeric(se_means),
      lower = as.numeric(
        means - critical_value * se_means
      ),
      upper = as.numeric(
        means + critical_value * se_means
      ),
      row.names = NULL
    )

    covariances_table <- data.frame(
      lhs = covariance_lhs,
      rhs = covariance_rhs,
      parameter = covariance_names,
      estimate = as.numeric(covariance_vector),
      se = as.numeric(se_covariance_vector),
      lower = as.numeric(
        covariance_vector -
          critical_value * se_covariance_vector
      ),
      upper = as.numeric(
        covariance_vector +
          critical_value * se_covariance_vector
      ),
      row.names = NULL
    )

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
      output = list(
        n = n,
        p = p,
        parameter_names = parameter_names,
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
        covariance_denominator = covariance_denominator
      ),
      data = data,
      elapsed = elapsed
    )

    # Use a distinct class because output is no longer an
    # OpenMx model and existing manmetavar.naive methods may
    # assume that out$output is an MxModel object.
    class(out) <- c(
      "manmetavar.naive.analytic",
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
