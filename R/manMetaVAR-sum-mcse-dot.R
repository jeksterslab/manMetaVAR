.SumMCSE <- function(replications,
                     means) {
  if (length(replications) < 2L) {
    stop(
      "At least two admissible replications are required to calculate MCSEs.",
      call. = FALSE
    )
  }
  extract <- function(variable) {
    out <- lapply(
      X = replications,
      FUN = function(x) {
        x[[variable]]
      }
    )
    do.call(
      what = cbind,
      args = out
    )
  }
  mcse_mean <- function(x) {
    apply(
      X = x,
      MARGIN = 1L,
      FUN = function(z) {
        z <- z[is.finite(z)]
        if (length(z) < 2L) {
          return(NA_real_)
        }
        stats::sd(z) / sqrt(length(z))
      }
    )
  }
  n_finite <- function(x) {
    rowSums(is.finite(x))
  }
  bias <- extract("bias")
  sq_error <- extract("sq_error")
  theta_hit <- extract("theta_hit")
  zero_hit <- extract("zero_hit")
  n_bias <- n_finite(bias)
  n_rmse <- n_finite(sq_error)
  n_coverage <- n_finite(theta_hit)
  n_rejection <- n_finite(zero_hit)
  mcse_bias <- mcse_mean(bias)
  mcse_mse <- mcse_mean(sq_error)
  mcse_rmse <- ifelse(
    means$rmse > 0,
    mcse_mse / (2 * means$rmse),
    ifelse(mcse_mse == 0, 0, NA_real_)
  )
  binomial_mcse <- function(p,
                            n) {
    ifelse(
      n > 0 & is.finite(p),
      sqrt(
        p * (1 - p) / n
      ),
      NA_real_
    )
  }
  mcse_coverage <- binomial_mcse(
    p = means$coverage,
    n = n_coverage
  )
  mcse_rejection <- binomial_mcse(
    p = means$rejection_rate,
    n = n_rejection
  )
  means$n_bias <- n_bias
  means$n_rmse <- n_rmse
  means$n_coverage <- n_coverage
  means$n_rejection <- n_rejection
  means$mcse_bias <- mcse_bias
  means$mcse_rmse <- mcse_rmse
  means$mcse_coverage <- mcse_coverage
  means$mcse_rejection_rate <- mcse_rejection
  means$mcse_power <- ifelse(
    is.na(means$power),
    NA_real_,
    mcse_rejection
  )
  means$mcse_type1_error <- ifelse(
    is.na(means$type1_error),
    NA_real_,
    mcse_rejection
  )
  means
}
