#' Methods for Objects of Class `manmetavar.mplus`
#'
#' This page documents the available methods for objects of class
#' `manmetavar.mplus`.
#'
#' @name manmetavar-mplus-methods
#' @keywords methods
NULL

#' Extract Posterior Draws from a FitMplus Object
#'
#' @param object Object of class `manmetavar.mplus` returned by `FitMplus()`.
#' @param burnin Integer indicating the number of initial draws to discard
#'   from each chain. If `burnin = NULL`, use `object$burnin`.
#'
#' @return A numeric matrix containing the chain identifier, iteration
#'   identifier, and named model-parameter draws.
#'
#' @noRd
.PosteriorDrawsManMetaVAR <- function(object,
                                      burnin = NULL) {
  if (!inherits(object, "manmetavar.mplus")) {
    stop(
      "`object` should be the output of `FitMplus()`.",
      call. = FALSE
    )
  }
  if (is.null(object$output$posterior)) {
    stop(
      "Posterior draws are not available in `object$output$posterior`.",
      call. = FALSE
    )
  }
  varnames <- c(
    "psi[1,1]",
    "psi[2,1]",
    "psi[2,2]",
    "mean(beta[1,1])",
    "mean(beta[2,1])",
    "mean(beta[1,2])",
    "mean(beta[2,2])",
    "mean(mu[1,1])",
    "mean(mu[2,1])",
    "cov(beta[1,1],beta[1,1])",
    "cov(beta[2,1],beta[1,1])",
    "cov(beta[2,1],beta[2,1])",
    "cov(beta[1,2],beta[1,1])",
    "cov(beta[1,2],beta[2,1])",
    "cov(beta[1,2],beta[1,2])",
    "cov(beta[2,2],beta[1,1])",
    "cov(beta[2,2],beta[2,1])",
    "cov(beta[2,2],beta[1,2])",
    "cov(beta[2,2],beta[2,2])",
    "cov(mu[1,1],mu[1,1])",
    "cov(mu[2,1],mu[1,1])",
    "cov(mu[2,1],mu[2,1])"
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

#' Parameter Estimates (FitMplus)
#'
#' @author Ivan Jacob Agaloos Pesigan
#'
#' @param object Object of class `manmetavar.mplus`.
#' @param burnin Integer indicating initial samples to discard.
#'   If `burnin = NULL`, use the burn-in stored in `object$burnin`.
#' @param median Logical.
#'   If `median = TRUE`, return median of the posterior.
#'   If `median = FALSE`, return mean of the posterior.
#' @inheritParams Template
#'
#' @rdname manmetavar-mplus-methods
#' @method coef manmetavar.mplus
#' @keywords methods
#' @export
coef.manmetavar.mplus <- function(object,
                                  median = TRUE,
                                  burnin = NULL,
                                  ...) {
  thetahatstar <- .PosteriorDrawsManMetaVAR(
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

#' Sampling Covariance Matrix of the Parameter Estimates (FitMplus)
#'
#' @author Ivan Jacob Agaloos Pesigan
#'
#' @param object Object of class `manmetavar.mplus`.
#' @inheritParams coef.manmetavar.mplus
#' @inheritParams Template
#'
#' @rdname manmetavar-mplus-methods
#' @method vcov manmetavar.mplus
#' @keywords methods
#' @export
vcov.manmetavar.mplus <- function(object,
                                  burnin = NULL,
                                  ...) {
  thetahatstar <- .PosteriorDrawsManMetaVAR(
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

.PosteriorCIManMetaVAR <- function(object,
                                   alpha = 0.05,
                                   median = TRUE,
                                   burnin = NULL) {
  draws <- .PosteriorDrawsManMetaVAR(
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

#' Summary Method (FitMplus)
#'
#' @author Ivan Jacob Agaloos Pesigan
#'
#' @param object Object of class `manmetavar.mplus`.
#'
#' @inheritParams Template
#' @inheritParams coef.manmetavar.mplus
#' @inheritParams summary.manmetavar.dtvar
#'
#' @rdname manmetavar-mplus-methods
#' @method summary manmetavar.mplus
#' @keywords methods
#' @export
summary.manmetavar.mplus <- function(object,
                                     alpha = 0.05,
                                     median = TRUE,
                                     digits = 4,
                                     burnin = NULL,
                                     ...) {
  ci <- .PosteriorCIManMetaVAR(
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
    "summary.manmetavar.mplus",
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
.PrintMplusSummary <- function(x,
                               ...) {
  print_summary <- attr(
    x = x,
    which = "print_summary"
  )
  print(print_summary)
  invisible(x)
}

#' Confidence Intervals for the Parameter Estimates (FitMplus)
#'
#' @author Ivan Jacob Agaloos Pesigan
#'
#' @param object Object of class `manmetavar.mplus`.
#' @param ... additional arguments.
#' @param parm a specification of which parameters
#'   are to be given confidence intervals,
#'   either a vector of numbers or a vector of names.
#'   If missing, all parameters are considered.
#' @param level the confidence level required.
#' @inheritParams Template
#'
#' @rdname manmetavar-mplus-methods
#' @method confint manmetavar.mplus
#' @keywords methods
#' @export
confint.manmetavar.mplus <- function(object,
                                     parm = NULL,
                                     level = 0.95,
                                     burnin = NULL,
                                     ...) {
  ci <- .PosteriorCIManMetaVAR(
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

#' Plot Method for an Object of Class `manmetavar.mplus`
#'
#' @author Ivan Jacob Agaloos Pesigan
#'
#' @param x Object of class `manmetavar.mplus`.
#' @param what Character string.
#'   If `what = "posterior"`, return posterior distribution plots.
#'   If `what = "trace"`, return trace plots.
#'   If `what = "rhat"`, `"ess"`, or `"mcse"`, return the corresponding
#'   Bayesian diagnostic plot from [FitMplusDiagnostics()].
#'
#' @inheritParams Template
#' @inheritParams confint.manmetavar.mplus
#' @param legend_loc Character string.
#'   Legend location.
#'
#' @rdname manmetavar-mplus-methods
#' @method plot manmetavar.mplus
#' @keywords methods
#' @export
plot.manmetavar.mplus <- function(x,
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
    diagnostics <- FitMplusDiagnostics(
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
  thetahatstar <- .PosteriorDrawsManMetaVAR(
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
