#' Methods for Objects of Class `manmetavar.mplus.k4`
#'
#' This page documents the available methods for objects of class
#' `manmetavar.mplus.k4`.
#'
#' @name manmetavar-mplus-k4-methods
#' @keywords methods
NULL

#' Extract Posterior Draws from a FitMplusK4 Object
#'
#' @param object Object of class `manmetavar.mplus.k4`
#'   returned by `FitMplusK4()`.
#' @param burnin Integer indicating the number of initial draws to discard
#'   from each chain. If `burnin = NULL`, use `object$burnin`.
#'
#' @return A numeric matrix containing the chain identifier, iteration
#'   identifier, and named model-parameter draws.
#'
#' @noRd
.PosteriorDrawsManMetaVARK4 <- function(object,
                                        burnin = NULL) {
  if (!inherits(object, "manmetavar.mplus.k4")) {
    stop(
      "`object` should be the output of `FitMplusK4()`.",
      call. = FALSE
    )
  }
  if (is.null(object$output$posterior)) {
    stop(
      "Posterior draws are not available in `object$output$posterior`.",
      call. = FALSE
    )
  }
  k <- 4L
  psi_names <- unlist(
    lapply(
      X = seq_len(k),
      FUN = function(i) {
        paste0(
          "psi[",
          i,
          ",",
          seq_len(i),
          "]"
        )
      }
    ),
    use.names = FALSE
  )
  beta_outcome <- rep(
    seq_len(k),
    times = k
  )
  beta_predictor <- rep(
    seq_len(k),
    each = k
  )
  beta_names <- paste0(
    "beta[",
    beta_outcome,
    ",",
    beta_predictor,
    "]"
  )
  mu_names <- paste0(
    "mu[",
    seq_len(k),
    ",1]"
  )
  varnames <- c(
    psi_names,
    paste0(
      "mean(",
      beta_names,
      ")"
    ),
    paste0(
      "mean(",
      mu_names,
      ")"
    ),
    paste0(
      "cov(",
      beta_names,
      ",",
      beta_names,
      ")"
    ),
    paste0(
      "cov(",
      mu_names,
      ",",
      mu_names,
      ")"
    )
  )
  expected_columns <- length(varnames) + 2L
  thetahatstar <- .ParseMplusPosteriorDraws(
    posterior = object$output$posterior,
    expected_columns = expected_columns
  )
  thetahatstar <- .TrimMplusFactorScoreRows(
    draws = thetahatstar,
    fscores = object$args$fscores,
    iter = object$args$iter
  )
  if (ncol(thetahatstar) != expected_columns) {
    stop(
      paste0(
        "Expected ",
        expected_columns,
        " columns in the saved posterior draws but found ",
        ncol(thetahatstar),
        "."
      ),
      call. = FALSE
    )
  }
  colnames(thetahatstar) <- c(
    "chain",
    "iteration",
    varnames
  )
  if (is.null(burnin)) {
    burnin <- object$burnin
  }
  if (is.null(burnin)) {
    burnin <- 0L
  }
  if (
    length(burnin) != 1L ||
      !is.numeric(burnin) ||
      !is.finite(burnin) ||
      burnin < 0 ||
      burnin != floor(burnin)
  ) {
    stop(
      "`burnin` should be a single nonnegative integer.",
      call. = FALSE
    )
  }
  burnin <- as.integer(burnin)
  chain <- unique(thetahatstar[, "chain"])
  thetahatstar_list <- lapply(
    X = chain,
    FUN = function(i) {
      chain_i <- thetahatstar[
        thetahatstar[, "chain"] == i, ,
        drop = FALSE
      ]
      if (burnin >= nrow(chain_i)) {
        stop(
          paste(
            "`burnin` should be less than",
            "the number of iterations in every chain."
          ),
          call. = FALSE
        )
      }
      if (burnin > 0L) {
        chain_i <- chain_i[-seq_len(burnin), , drop = FALSE]
      }
      chain_i
    }
  )
  thetahatstar <- do.call(
    what = "rbind",
    args = thetahatstar_list
  )
  rownames(thetahatstar) <- NULL
  attr(thetahatstar, "burnin") <- burnin
  attr(thetahatstar, "chains") <- chain
  attr(thetahatstar, "iterations_per_chain") <- vapply(
    X = thetahatstar_list,
    FUN = nrow,
    FUN.VALUE = integer(1)
  )
  thetahatstar
}

#' Parameter Estimates (FitMplusK4)
#'
#' @author Ivan Jacob Agaloos Pesigan
#'
#' @param object Object of class `manmetavar.mplus.k4`.
#' @param burnin Integer indicating initial samples to discard.
#'   If `burnin = NULL`, use the burn-in stored in `object$burnin`.
#' @param median Logical.
#'   If `median = TRUE`, return median of the posterior.
#'   If `median = FALSE`, return mean of the posterior.
#' @inheritParams Template
#'
#' @rdname manmetavar-mplus-k4-methods
#' @method coef manmetavar.mplus.k4
#' @keywords methods
#' @export
coef.manmetavar.mplus.k4 <- function(object,
                                     median = TRUE,
                                     burnin = NULL,
                                     ...) {
  thetahatstar <- .PosteriorDrawsManMetaVARK4(
    object = object,
    burnin = burnin
  )
  thetahatstar <- thetahatstar[
    ,
    -match(c("chain", "iteration"), colnames(thetahatstar)),
    drop = FALSE
  ]
  if (median) {
    out <- apply(
      X = thetahatstar,
      MARGIN = 2,
      FUN = median
    )
  } else {
    out <- colMeans(thetahatstar)
  }
  out
}

#' Sampling Covariance Matrix of the Parameter Estimates (FitMplusK4)
#'
#' @author Ivan Jacob Agaloos Pesigan
#'
#' @param object Object of class `manmetavar.mplus.k4`.
#' @inheritParams coef.manmetavar.mplus.k4
#' @inheritParams Template
#'
#' @rdname manmetavar-mplus-k4-methods
#' @method vcov manmetavar.mplus.k4
#' @keywords methods
#' @export
vcov.manmetavar.mplus.k4 <- function(object,
                                     burnin = NULL,
                                     ...) {
  thetahatstar <- .PosteriorDrawsManMetaVARK4(
    object = object,
    burnin = burnin
  )
  thetahatstar <- thetahatstar[
    ,
    -match(c("chain", "iteration"), colnames(thetahatstar)),
    drop = FALSE
  ]
  stats::cov(thetahatstar)
}

.PosteriorCIManMetaVARK4 <- function(object,
                                     alpha = 0.05,
                                     median = TRUE,
                                     burnin = NULL) {
  draws <- .PosteriorDrawsManMetaVARK4(
    object = object,
    burnin = burnin
  )
  effective_burnin <- attr(draws, "burnin")
  thetahatstar <- draws[
    ,
    -match(c("chain", "iteration"), colnames(draws)),
    drop = FALSE
  ]
  if (median) {
    thetahat <- apply(
      X = thetahatstar,
      MARGIN = 2,
      FUN = stats::median
    )
  } else {
    thetahat <- colMeans(thetahatstar)
  }
  stopifnot(
    all(alpha > 0 & alpha < 1)
  )
  probs <- .PCProbs(alpha = alpha)
  ci <- vector(
    mode = "list",
    length = dim(thetahatstar)[2]
  )
  for (i in seq_len(dim(thetahatstar)[2])) {
    ci[[i]] <- .PCCI(
      thetahatstar = thetahatstar[, i],
      thetahat = thetahat[[i]],
      probs = probs
    )
  }
  ci <- do.call(
    what = "rbind",
    args = ci
  )
  varnames <- names(thetahat)
  if (!is.null(varnames)) {
    rownames(ci) <- varnames
  }
  attr(ci, "burnin") <- effective_burnin
  ci
}

#' Summary Method (FitMplusK4)
#'
#' @author Ivan Jacob Agaloos Pesigan
#'
#' @param object Object of class `manmetavar.mplus.k4`.
#'
#' @inheritParams Template
#' @inheritParams coef.manmetavar.mplus.k4
#' @inheritParams summary.manmetavar.dtvar
#'
#' @rdname manmetavar-mplus-k4-methods
#' @method summary manmetavar.mplus.k4
#' @keywords methods
#' @export
summary.manmetavar.mplus.k4 <- function(object,
                                        alpha = 0.05,
                                        median = TRUE,
                                        digits = 4,
                                        burnin = NULL,
                                        ...) {
  ci <- .PosteriorCIManMetaVARK4(
    object = object,
    alpha = alpha,
    median = median,
    burnin = burnin
  )
  effective_burnin <- attr(ci, "burnin")
  print_summary <- round(
    x = ci,
    digits = digits
  )
  class(ci) <- c(
    "summary.manmetavar.mplus.k4",
    class(ci)
  )
  attributes(ci)$fit <- object
  attributes(ci)$alpha <- alpha
  attributes(ci)$median <- median
  attributes(ci)$digits <- digits
  attributes(ci)$burnin <- effective_burnin
  attributes(ci)$print_summary <- print_summary
  ci
}

#' @noRd
#' @keywords internal
.PrintMplusK4Summary <- function(x,
                                 ...) {
  print_summary <- attr(
    x = x,
    which = "print_summary"
  )
  print(print_summary)
  invisible(x)
}

#' Confidence Intervals for the Parameter Estimates (FitMplusK4)
#'
#' @author Ivan Jacob Agaloos Pesigan
#'
#' @param object Object of class `manmetavar.mplus.k4`.
#' @param ... additional arguments.
#' @param parm a specification of which parameters
#'   are to be given confidence intervals,
#'   either a vector of numbers or a vector of names.
#'   If missing, all parameters are considered.
#' @param level the confidence level required.
#' @inheritParams Template
#'
#' @rdname manmetavar-mplus-k4-methods
#' @method confint manmetavar.mplus.k4
#' @keywords methods
#' @export
confint.manmetavar.mplus.k4 <- function(object,
                                        parm = NULL,
                                        level = 0.95,
                                        burnin = NULL,
                                        ...) {
  ci <- .PosteriorCIManMetaVARK4(
    object = object,
    alpha = 1 - level[1],
    median = TRUE,
    burnin = burnin
  )
  if (is.null(parm)) {
    parameters <- rownames(
      ci
    )
    if (!is.null(parameters)) {
      parm <- parameters
    } else {
      parm <- seq_len(dim(ci)[1])
    }
  }
  ci <- ci[parm, 4:5, drop = FALSE]
  varnames <- colnames(ci)
  varnames <- gsub(
    pattern = "%",
    replacement = " %",
    x = varnames
  )
  colnames(ci) <- varnames
  ci
}

#' Plot Method for an Object of Class `manmetavar.mplus.k4`
#'
#' @author Ivan Jacob Agaloos Pesigan
#'
#' @param x Object of class `manmetavar.mplus.k4`.
#' @param what Character string.
#'   If `what = "posterior"`, return posterior distribution plots.
#'   If `what = "trace"`, return trace plots.
#'   If `what = "rhat"`, `"ess"`, or `"mcse"`, return the corresponding
#'   Bayesian diagnostic plot from [FitMplusK4Diagnostics()].
#'
#' @inheritParams Template
#' @inheritParams confint.manmetavar.mplus.k4
#' @param legend_loc Character string.
#'   Legend location.
#'
#' @rdname manmetavar-mplus-k4-methods
#' @method plot manmetavar.mplus.k4
#' @keywords methods
#' @export
plot.manmetavar.mplus.k4 <- function(x,
                                     what = "posterior",
                                     parm = NULL,
                                     level = 0.95,
                                     burnin = NULL,
                                     legend_loc = "topright",
                                     ...) {
  what <- match.arg(
    arg = what,
    choices = c(
      "posterior",
      "trace",
      "rhat",
      "ess",
      "mcse"
    )
  )
  if (what %in% c("rhat", "ess", "mcse")) {
    diagnostics <- FitMplusK4Diagnostics(
      object = x,
      burnin = burnin,
      level = level[1]
    )
    return(
      graphics::plot(
        x = diagnostics,
        what = what,
        parm = parm,
        ...
      )
    )
  }
  thetahatstar <- .PosteriorDrawsManMetaVARK4(
    object = x,
    burnin = burnin
  )
  chain <- unique(thetahatstar[, "chain"])
  varnames <- setdiff(
    x = colnames(thetahatstar),
    y = c("chain", "iteration")
  )
  if (is.null(parm)) {
    parm <- varnames
  } else {
    if (is.numeric(parm)) {
      parm <- varnames[as.integer(parm)]
    } else {
      if (any(!parm %in% varnames)) {
        stop(
          paste0(
            "One or more elements of `parm` ",
            "are not present in the parameter vector."
          )
        )
      }
    }
  }
  if (what == "posterior") {
    alpha <- (1 - level[1]) / 2
    for (i in seq_along(parm)) {
      qs <- stats::quantile(
        x = thetahatstar[, parm[i]],
        probs = c(alpha, 0.5, 1 - alpha),
        na.rm = TRUE,
        names = FALSE
      )
      mu <- mean(thetahatstar[, parm[i]])
      graphics::hist(
        x = thetahatstar[, parm[i]],
        main = paste("Posterior Distribution", parm[i]),
        xlab = parm[i]
      )
      graphics::abline(v = mu, lwd = 2, lty = 3, col = "blue")
      graphics::abline(v = qs[2], lwd = 2, lty = 1, col = "black")
      graphics::abline(v = qs[c(1, 3)], lwd = 2, lty = 2, col = "red")
      graphics::legend(
        x = legend_loc,
        legend = c(
          sprintf("Mean = %.4f", mu),
          sprintf("Median = %.4f", qs[2]),
          sprintf("%.1f%% CI: [%.4f, %.4f]", 100 * level, qs[1], qs[3])
        ),
        lty = c(3, 1, 2),
        lwd = 2,
        col = c("blue", "black", "red"),
        bty = "n"
      )
    }
  }
  if (what == "trace") {
    for (i in seq_along(parm)) {
      graphics::plot(
        x = NULL,
        xlim = range(thetahatstar[, "iteration"]),
        ylim = range(thetahatstar[, parm[i]]),
        xlab = "Iteration",
        ylab = parm[i],
        main = paste("Trace:", parm[i])
      )
      colfunc <- grDevices::colorRampPalette(
        c(
          "red",
          "yellow",
          "springgreen",
          "royalblue"
        )
      )
      cols <- colfunc(length(chain))
      for (j in seq_along(chain)) {
        graphics::lines(
          x = thetahatstar[
            which(thetahatstar[, "chain"] == chain[j]),
            "iteration"
          ],
          y = thetahatstar[
            which(thetahatstar[, "chain"] == chain[j]),
            parm[i]
          ],
          col = cols[j]
        )
      }
    }
  }
  invisible(x)
}
