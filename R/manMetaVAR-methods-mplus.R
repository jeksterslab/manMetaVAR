#' Parameter Estimates (FitMplus)
#'
#' @author Ivan Jacob Agaloos Pesigan
#'
#' @param object Object of class `manmetavar.mplus`.
#' @param median Logical.
#'   If `median = TRUE`, return median of the posterior.
#'   If `median = FALSE`, return mean of the posterior.
#' @inheritParams Template
#'
#' @inheritParams Template
#'
#' @return Returns a vector of estimated parameters.
#'
#' @rdname coef.manmetavar
#' @method coef manmetavar.mplus
#' @keywords methods
#' @import metaVAR
#' @export
coef.manmetavar.mplus <- function(object,
                                  median = TRUE,
                                  burnin = NULL,
                                  ...) {
  thetahatstar <- as.matrix(
    utils::read.table(
      text = object$output$posterior
    )
  )
  if (!is.null(object$args$fscores)) {
    thetahatstar <- thetahatstar[
      1:(dim(thetahatstar)[1] - object$args$fscores), ,
      drop = FALSE
    ]
  }
  if (!is.null(burnin)) {
    chain <- unique(thetahatstar[, 1])
    thetahatstar_list <- lapply(
      X = chain,
      FUN = function(i) {
        chain_i <- thetahatstar[
          which(thetahatstar[, 1] == i), ,
          drop = FALSE
        ]
        dims <- dim(chain_i)
        if (burnin >= dims[1]) {
          stop(
            "`burnin` should be less than the number of iterations."
          )
        }
        chain_i[-(1:burnin), , drop = FALSE]
      }
    )
    thetahatstar <- do.call(
      what = "rbind",
      args = thetahatstar_list
    )
  }
  thetahatstar <- thetahatstar[, -c(1, 2), drop = FALSE]
  if (median) {
    out <- apply(
      X = thetahatstar,
      MARGIN = 2,
      FUN = median
    )
  } else {
    out <- colMeans(thetahatstar)
  }
  names(out) <- c(
    "theta[1,1]",
    "theta[2,2]",
    "psi[1,1]",
    "psi[2,1]",
    "psi[2,2]",
    "mean(nu[1,1])",
    "mean(nu[2,1])",
    "mean(beta[1,1])",
    "mean(beta[2,1])",
    "mean(beta[1,2])",
    "mean(beta[2,2])",
    "cov(nu[1,1],nu[1,1])",
    "cov(nu[2,1],nu[1,1])",
    "cov(nu[2,1],nu[2,1])",
    "cov(nu[1,1],beta[1,1])",
    "cov(nu[2,1],beta[1,1])",
    "cov(beta[1,1],beta[1,1])",
    "cov(nu[1,1],beta[2,1])",
    "cov(nu[2,1],beta[2,1])",
    "cov(beta[2,1], beta[1,1])",
    "cov(beta[2,1],beta[2,1])",
    "cov(nu[1,1],beta[1,2])",
    "cov(nu[2,1],beta[1,2])",
    "cov(beta[1,2],beta[1,1])",
    "cov(beta[1,2],beta[2,1])",
    "cov(beta[1,2],beta[1,2])",
    "cov(nu[1,1],beta[2,2])",
    "cov(nu[2,1],beta[2,2])",
    "cov(beta[2,2],beta[1,1])",
    "cov(beta[2,2],beta[2,1])",
    "cov(beta[2,2],beta[1,2])",
    "cov(beta[2,2],beta[2,2])"
  )
  out
}

#' Sampling Covariance Matrix of the Parameter Estimates (FitMplus)
#'
#' @author Ivan Jacob Agaloos Pesigan
#'
#' @param object Object of class `manmetavar.mplus`.
#' @inheritParams Template
#'
#' @inheritParams Template
#'
#' @return Returns the sampling variance-covariance matrix
#'   of the estimated parameters.
#'
#' @rdname vcov.manmetavar
#' @method vcov manmetavar.mplus
#' @keywords methods
#' @export
vcov.manmetavar.mplus <- function(object,
                                  burnin = NULL,
                                  ...) {
  thetahatstar <- as.matrix(
    utils::read.table(
      text = object$output$posterior
    )
  )
  if (!is.null(object$args$fscores)) {
    thetahatstar <- thetahatstar[
      1:(dim(thetahatstar)[1] - object$args$fscores), ,
      drop = FALSE
    ]
  }
  if (!is.null(burnin)) {
    chain <- unique(thetahatstar[, 1])
    thetahatstar_list <- lapply(
      X = chain,
      FUN = function(i) {
        chain_i <- thetahatstar[
          which(thetahatstar[, 1] == i), ,
          drop = FALSE
        ]
        dims <- dim(chain_i)
        if (burnin >= dims[1]) {
          stop(
            "`burnin` should be less than the number of iterations."
          )
        }
        chain_i[-(1:burnin), , drop = FALSE]
      }
    )
    thetahatstar <- do.call(
      what = "rbind",
      args = thetahatstar_list
    )
  }
  thetahatstar <- thetahatstar[, -c(1, 2), drop = FALSE]
  out <- stats::cov(thetahatstar)
  rownames(out) <- colnames(out) <- c(
    "theta[1,1]",
    "theta[2,2]",
    "psi[1,1]",
    "psi[2,1]",
    "psi[2,2]",
    "mean(nu[1,1])",
    "mean(nu[2,1])",
    "mean(beta[1,1])",
    "mean(beta[2,1])",
    "mean(beta[1,2])",
    "mean(beta[2,2])",
    "cov(nu[1,1],nu[1,1])",
    "cov(nu[2,1],nu[1,1])",
    "cov(nu[2,1],nu[2,1])",
    "cov(nu[1,1],beta[1,1])",
    "cov(nu[2,1],beta[1,1])",
    "cov(beta[1,1],beta[1,1])",
    "cov(nu[1,1],beta[2,1])",
    "cov(nu[2,1],beta[2,1])",
    "cov(beta[2,1], beta[1,1])",
    "cov(beta[2,1],beta[2,1])",
    "cov(nu[1,1],beta[1,2])",
    "cov(nu[2,1],beta[1,2])",
    "cov(beta[1,2],beta[1,1])",
    "cov(beta[1,2],beta[2,1])",
    "cov(beta[1,2],beta[1,2])",
    "cov(nu[1,1],beta[2,2])",
    "cov(nu[2,1],beta[2,2])",
    "cov(beta[2,2],beta[1,1])",
    "cov(beta[2,2],beta[2,1])",
    "cov(beta[2,2],beta[1,2])",
    "cov(beta[2,2],beta[2,2])"
  )
  out
}

.PosteriorCI <- function(object,
                         alpha = 0.05,
                         median = TRUE,
                         burnin = NULL) {
  thetahatstar <- as.matrix(
    utils::read.table(
      text = object$output$posterior
    )
  )
  if (!is.null(object$args$fscores)) {
    thetahatstar <- thetahatstar[
      1:(dim(thetahatstar)[1] - object$args$fscores), ,
      drop = FALSE
    ]
  }
  if (!is.null(burnin)) {
    chain <- unique(thetahatstar[, 1])
    thetahatstar_list <- lapply(
      X = chain,
      FUN = function(i) {
        chain_i <- thetahatstar[
          which(thetahatstar[, 1] == i), ,
          drop = FALSE
        ]
        dims <- dim(chain_i)
        if (burnin >= dims[1]) {
          stop(
            "`burnin` should be less than the number of iterations."
          )
        }
        chain_i[-(1:burnin), , drop = FALSE]
      }
    )
    thetahatstar <- do.call(
      what = "rbind",
      args = thetahatstar_list
    )
  }
  thetahatstar <- thetahatstar[, -c(1, 2), drop = FALSE]
  thetahat <- coef.manmetavar.mplus(
    object = object,
    median = median,
    burnin = burnin
  )
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
#'
#' @return Returns a matrix of estimates, standard errors,
#'   number of posterior samples, and confidence intervals.
#'
#' @rdname summary.manmetavar
#' @method summary manmetavar.mplus
#' @keywords methods
#' @export
summary.manmetavar.mplus <- function(object,
                                     alpha = 0.05,
                                     median = TRUE,
                                     digits = 4,
                                     burnin = NULL,
                                     ...) {
  ci <- .PosteriorCI(
    object = object,
    alpha = alpha,
    median = median,
    burnin = burnin
  )
  structure(
    .Data = ci,
    fit = object,
    alpha = alpha,
    digits = digits,
    print_summary = round(
      x = ci,
      digits = digits
    ),
    class = "summary.manmetavar.mplus"
  )
}

#' @noRd
#' @keywords internal
#' @exportS3Method print summary.manmetavar.mplus
print.summary.manmetavar.mplus <- function(x,
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
#' @return Returns a matrix of confidence intervals.
#'
#' @rdname confint.manmetavar
#' @method confint manmetavar.mplus
#' @keywords methods
#' @import metaVAR
#' @export
confint.manmetavar.mplus <- function(object,
                                     parm = NULL,
                                     level = 0.95,
                                     burnin = NULL,
                                     ...) {
  ci <- .PosteriorCI(
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
#'
#' @inheritParams Template
#' @inheritParams confint.manmetavar.mplus
#'
#' @rdname plot.manmetavar
#' @method plot manmetavar.mplus
#' @keywords methods
#' @export
plot.manmetavar.mplus <- function(x,
                                  what = "posterior",
                                  parm = NULL,
                                  level = 0.95,
                                  burnin = NULL,
                                  ...) {
  thetahatstar <- as.matrix(
    utils::read.table(
      text = x$output$posterior
    )
  )
  if (!is.null(x$args$fscores)) {
    thetahatstar <- thetahatstar[
      1:(dim(thetahatstar)[1] - x$args$fscores), ,
      drop = FALSE
    ]
  }
  chain <- unique(thetahatstar[, 1])
  if (!is.null(burnin)) {
    thetahatstar_list <- lapply(
      X = chain,
      FUN = function(i) {
        chain_i <- thetahatstar[
          which(thetahatstar[, 1] == i), ,
          drop = FALSE
        ]
        dims <- dim(chain_i)
        if (burnin >= dims[1]) {
          stop(
            "`burnin` should be less than the number of iterations."
          )
        }
        chain_i[-(1:burnin), , drop = FALSE]
      }
    )
    thetahatstar <- do.call(
      what = "rbind",
      args = thetahatstar_list
    )
  }
  rownames(thetahatstar) <- NULL
  varnames <- c(
    "theta[1,1]",
    "theta[2,2]",
    "psi[1,1]",
    "psi[2,1]",
    "psi[2,2]",
    "mean(nu[1,1])",
    "mean(nu[2,1])",
    "mean(beta[1,1])",
    "mean(beta[2,1])",
    "mean(beta[1,2])",
    "mean(beta[2,2])",
    "cov(nu[1,1],nu[1,1])",
    "cov(nu[2,1],nu[1,1])",
    "cov(nu[2,1],nu[2,1])",
    "cov(nu[1,1],beta[1,1])",
    "cov(nu[2,1],beta[1,1])",
    "cov(beta[1,1],beta[1,1])",
    "cov(nu[1,1],beta[2,1])",
    "cov(nu[2,1],beta[2,1])",
    "cov(beta[2,1], beta[1,1])",
    "cov(beta[2,1],beta[2,1])",
    "cov(nu[1,1],beta[1,2])",
    "cov(nu[2,1],beta[1,2])",
    "cov(beta[1,2],beta[1,1])",
    "cov(beta[1,2],beta[2,1])",
    "cov(beta[1,2],beta[1,2])",
    "cov(nu[1,1],beta[2,2])",
    "cov(nu[2,1],beta[2,2])",
    "cov(beta[2,2],beta[1,1])",
    "cov(beta[2,2],beta[2,1])",
    "cov(beta[2,2],beta[1,2])",
    "cov(beta[2,2],beta[2,2])"
  )
  colnames(thetahatstar) <- c(
    "chain",
    "iteration",
    varnames
  )
  if (is.null(parm)) {
    parm <- varnames
  } else {
    if (is.numeric(parm)) {
      parm <- varnames[as.integer(parm)]
    } else {
      if (any(!parm %in% varnames)) {
        stop(
          "One or more elements of `parm` are not present in the parameter vector."
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
        main = "Posterior Distribution",
        xlab = parm[i]
      )
      graphics::abline(v = mu, lwd = 2, lty = 3, col = "blue")
      graphics::abline(v = qs[2], lwd = 2, lty = 1, col = "black")
      graphics::abline(v = qs[c(1, 3)], lwd = 2, lty = 2, col = "red")
      graphics::legend(
        x = "topright",
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
      plot(
        x = NULL,
        xlim = range(thetahatstar[, 2]),
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
            which(thetahatstar[, 1] == chain[j]),
            2
          ],
          y = thetahatstar[
            which(thetahatstar[, 1] == chain[j]),
            parm[i]
          ],
          col = cols[j]
        )
      }
    }
  }
}
