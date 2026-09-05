#' Posterior Diagnostics for FitMplusK4
#'
#' The function computes parameter-level posterior summaries and Markov chain
#' Monte Carlo diagnostics from the posterior draws saved by `FitMplusK4()`.
#'
#' @param object Object of class `manmetavar.mplus.k4` returned by
#'   `FitMplusK4()`.
#' @param burnin Integer indicating the number of initial draws to discard
#'   from each chain. If `burnin = NULL`, use `object$burnin`.
#' @param level Numeric value indicating the credibility level.
#'
#' @return An object of class `manmetavar.mplus.k4.diagnostics` containing a
#'   parameter-level diagnostics data frame and a run-level diagnostics data
#'   frame.
#'
#' @examples
#' \dontrun{
#' seed <- 42
#' data <- GenDataK4(taskid = 1, seed = seed)
#' fit <- FitMplusK4(data = data, seed = seed)
#' diagnostics <- FitMplusK4Diagnostics(fit)
#' diagnostics$parameters
#' diagnostics$run
#' print(diagnostics)
#' }
#'
#' @family Model Fitting Functions
#' @keywords manMetaVAR fit diagnostics
#' @export
FitMplusK4Diagnostics <- function(object,
                                  burnin = NULL,
                                  level = 0.95) {
  if (!inherits(object, "manmetavar.mplus.k4")) {
    stop(
      "`object` should be an object returned by `FitMplusK4()`.",
      call. = FALSE
    )
  }
  if (
    length(level) != 1L ||
      !is.numeric(level) ||
      !is.finite(level) ||
      level <= 0 ||
      level >= 1
  ) {
    stop(
      "`level` should be a single numeric value between 0 and 1.",
      call. = FALSE
    )
  }
  draws <- .PosteriorDrawsManMetaVARK4(
    object = object,
    burnin = burnin
  )
  chain <- unique(
    draws[, "chain"]
  )
  iterations_per_chain <- vapply(
    X = chain,
    FUN = function(i) {
      sum(
        draws[, "chain"] == i
      )
    },
    FUN.VALUE = integer(1)
  )
  if (length(unique(iterations_per_chain)) != 1L) {
    stop(
      "All chains should contain the same number of retained iterations.",
      call. = FALSE
    )
  }
  n_iterations <- iterations_per_chain[1]
  varnames <- setdiff(
    x = colnames(draws),
    y = c(
      "chain",
      "iteration"
    )
  )
  alpha <- (1 - level) / 2
  probs <- c(
    alpha,
    1 - alpha
  )
  diagnostics <- lapply(
    X = varnames,
    FUN = function(parameter) {
      parameter_draws <- vapply(
        X = chain,
        FUN = function(i) {
          draws[
            draws[, "chain"] == i,
            parameter
          ]
        },
        FUN.VALUE = numeric(n_iterations)
      )
      quantiles <- stats::quantile(
        x = parameter_draws,
        probs = probs,
        names = FALSE
      )
      mcse_quantiles <- posterior::mcse_quantile(
        x = parameter_draws,
        probs = probs,
        names = FALSE
      )
      data.frame(
        parameter = parameter,
        mean = mean(parameter_draws),
        median = stats::median(parameter_draws),
        sd = stats::sd(parameter_draws),
        ll = quantiles[1],
        ul = quantiles[2],
        rhat = posterior::rhat(parameter_draws),
        ess_bulk = posterior::ess_bulk(parameter_draws),
        ess_tail = posterior::ess_tail(parameter_draws),
        mcse_mean = posterior::mcse_mean(parameter_draws),
        mcse_median = posterior::mcse_median(parameter_draws),
        mcse_ll = mcse_quantiles[1],
        mcse_ul = mcse_quantiles[2],
        row.names = NULL,
        check.names = FALSE
      )
    }
  )
  parameters <- do.call(
    what = "rbind",
    args = diagnostics
  )
  safe_min <- function(x) {
    x <- x[is.finite(x)]
    if (length(x) == 0L) {
      NA_real_
    } else {
      min(x)
    }
  }
  safe_max <- function(x) {
    x <- x[is.finite(x)]
    if (length(x) == 0L) {
      NA_real_
    } else {
      max(x)
    }
  }
  if (!is.null(object$args$default_priors)) {
    default_priors <- isTRUE(
      object$args$default_priors
    )
  } else {
    default_priors <- !any(
      grepl(
        pattern = "^[[:space:]]*MODEL PRIORS:",
        x = object$output$input,
        ignore.case = TRUE
      )
    )
  }
  if (inherits(object$elapsed, "difftime")) {
    elapsed_seconds <- as.numeric(
      object$elapsed,
      units = "secs"
    )
  } else {
    elapsed_seconds <- as.numeric(
      object$elapsed
    )
  }
  run <- data.frame(
    default_priors = default_priors,
    chains = length(chain),
    requested_iterations = as.integer(
      object$args$iter
    ),
    retained_iterations_per_chain = n_iterations,
    burnin = attr(
      draws,
      "burnin"
    ),
    retained_draws = nrow(draws),
    level = level,
    elapsed_seconds = elapsed_seconds,
    max_rhat = safe_max(
      parameters$rhat
    ),
    min_ess_bulk = safe_min(
      parameters$ess_bulk
    ),
    min_ess_tail = safe_min(
      parameters$ess_tail
    ),
    n_rhat_na = sum(
      !is.finite(parameters$rhat)
    ),
    n_rhat_gt_1_01 = sum(
      parameters$rhat > 1.01,
      na.rm = TRUE
    ),
    n_ess_bulk_na = sum(
      !is.finite(parameters$ess_bulk)
    ),
    n_ess_bulk_lt_100 = sum(
      parameters$ess_bulk < 100,
      na.rm = TRUE
    ),
    n_ess_bulk_lt_200 = sum(
      parameters$ess_bulk < 200,
      na.rm = TRUE
    ),
    n_ess_bulk_lt_400 = sum(
      parameters$ess_bulk < 400,
      na.rm = TRUE
    ),
    n_ess_tail_na = sum(
      !is.finite(parameters$ess_tail)
    ),
    n_ess_tail_lt_100 = sum(
      parameters$ess_tail < 100,
      na.rm = TRUE
    ),
    n_ess_tail_lt_200 = sum(
      parameters$ess_tail < 200,
      na.rm = TRUE
    ),
    n_ess_tail_lt_400 = sum(
      parameters$ess_tail < 400,
      na.rm = TRUE
    ),
    row.names = NULL,
    check.names = FALSE
  )
  out <- list(
    parameters = parameters,
    run = run
  )
  class(out) <- c(
    "manmetavar.mplus.k4.diagnostics",
    class(out)
  )
  out
}

#' @noRd
#' @keywords internal
.PrintMplusK4Diag <- function(x,
                              digits = 4,
                              ...) {
  cat(
    "FitMplusK4 posterior diagnostics\n\n"
  )
  print(
    x$run,
    row.names = FALSE
  )
  cat(
    "\nParameter diagnostics\n\n"
  )
  parameters <- x$parameters
  numeric_columns <- vapply(
    X = parameters,
    FUN = is.numeric,
    FUN.VALUE = logical(1)
  )
  parameters[numeric_columns] <- lapply(
    X = parameters[numeric_columns],
    FUN = round,
    digits = digits
  )
  print(
    parameters,
    row.names = FALSE
  )
  invisible(x)
}
