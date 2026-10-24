data_analysis_adid2010_dsem_compare <- function(overwrite = FALSE) {
  # Posterior summaries and diagnostics of the four empirical DSEM fits
  # (default, custom, priors-2, priors-3) next to the MetaVAR values that
  # centre the priors-2 and priors-3 priors.
  root <- rprojroot::is_rstudio_project
  data_private <- root$find_file(
    ".setup",
    "data-private"
  )
  output <- file.path(
    data_private,
    "adid2010-dsem-compare.Rds"
  )
  if (file.exists(output) && !overwrite) {
    return(invisible(output))
  }
  # The stored Stage 2 model's algebra calls OpenMx functions
  # (mxRobustLog), which are found only when OpenMx is attached.
  library(OpenMx)
  source(
    root$find_file(
      ".setup",
      "data-analysis",
      "data-analysis-007-empirical-dsem-priors-2-values.R"
    ),
    local = TRUE
  )
  fits <- c(
    default = "adid2010-dsem-default",
    priors = "adid2010-dsem-priors",
    priors_2 = "adid2010-dsem-priors-2",
    priors_3 = "adid2010-dsem-priors-3"
  )
  # order of the saved parameters ("Order of parameters saved" in the .out
  # files; the same in all four fits)
  parameter <- c(
    "mean(BETA11)",
    "mean(BETA21)",
    "mean(BETA12)",
    "mean(BETA22)",
    "mean(LOGV1)",
    "mean(LOGV2)",
    "mean(ZCOR12)",
    "mean(Y1)",
    "mean(Y2)",
    "var(BETA11)",
    "cov(BETA21,BETA11)",
    "var(BETA21)",
    "cov(BETA12,BETA11)",
    "cov(BETA12,BETA21)",
    "var(BETA12)",
    "cov(BETA22,BETA11)",
    "cov(BETA22,BETA21)",
    "cov(BETA22,BETA12)",
    "var(BETA22)",
    "var(LOGV1)",
    "cov(LOGV2,LOGV1)",
    "var(LOGV2)",
    "cov(ZCOR12,LOGV1)",
    "cov(ZCOR12,LOGV2)",
    "var(ZCOR12)",
    "var(Y1)",
    "cov(Y2,Y1)",
    "var(Y2)"
  )
  group <- rep(
    x = c(
      "Transition mean",
      "Innovation mean",
      "Set-point mean",
      "Transition covariance",
      "Innovation covariance",
      "Set-point covariance"
    ),
    times = c(4, 3, 2, 10, 6, 3)
  )
  # MetaVAR values on the DSEM scale (as in the priors-2 input)
  v <- data_analysis_adid2010_dsem_priors_2_values()
  lower <- function(x) {
    x[upper.tri(x, diag = TRUE)]
  }
  metavar <- c(
    v$transition_mean,
    v$innovation_mean,
    v$setpoint_mean,
    lower(v$transition_tau_sqr),
    lower(v$innovation_tau_sqr),
    lower(v$setpoint_tau_sqr)
  )
  criteria <- list(
    strict = c(rhat = 1.01, ess = 400, mcse = 0.05),
    moderate = c(rhat = 1.05, ess = 100, mcse = 0.10)
  )
  probs <- c(0.025, 0.975)
  summaries <- lapply(
    X = names(fits),
    FUN = function(fit) {
      draws <- matrix(
        data = scan(
          file = file.path(
            data_private,
            paste0(fits[[fit]], "-posterior.txt")
          ),
          quiet = TRUE
        ),
        ncol = length(parameter) + 2L,
        byrow = TRUE
      )
      chain <- sort(unique(draws[, 1]))
      # Mplus discards the first half of each chain as burn-in
      kept <- lapply(
        X = chain,
        FUN = function(i) {
          chain_i <- draws[draws[, 1] == i, -(1:2), drop = FALSE]
          chain_i[-seq_len(nrow(chain_i) %/% 2), , drop = FALSE]
        }
      )
      out <- do.call(
        what = "rbind",
        args = lapply(
          X = seq_along(parameter),
          FUN = function(j) {
            x <- vapply(
              X = kept,
              FUN = function(chain_i) {
                chain_i[, j]
              },
              FUN.VALUE = numeric(nrow(kept[[1]]))
            )
            quantiles <- stats::quantile(
              x = x,
              probs = probs,
              names = FALSE
            )
            mcse_quantiles <- posterior::mcse_quantile(
              x = x,
              probs = probs,
              names = FALSE
            )
            data.frame(
              median = stats::median(x),
              sd = stats::sd(x),
              ll = quantiles[1],
              ul = quantiles[2],
              rhat = posterior::rhat(x),
              ess_bulk = posterior::ess_bulk(x),
              ess_tail = posterior::ess_tail(x),
              mcse_sd = max(
                posterior::mcse_mean(x),
                posterior::mcse_median(x),
                mcse_quantiles
              ) / stats::sd(x)
            )
          }
        )
      )
      for (criterion in names(criteria)) {
        threshold <- criteria[[criterion]]
        out[[criterion]] <- out$rhat <= threshold["rhat"] &
          pmin(out$ess_bulk, out$ess_tail) >= threshold["ess"] &
          out$mcse_sd <= threshold["mcse"]
      }
      out <- cbind(
        fit = fit,
        parameter = parameter,
        group = group,
        metavar = metavar,
        out
      )
      rownames(out) <- NULL
      out
    }
  )
  names(summaries) <- names(fits)
  parameters <- do.call(
    what = "rbind",
    args = summaries
  )
  rownames(parameters) <- NULL
  # share of the distance from the default fit to MetaVAR that each fit
  # covers
  default <- summaries$default$median
  parameters$share <- (parameters$median - default) / (metavar - default)
  # final PSR and elapsed time from the .out files
  run <- do.call(
    what = "rbind",
    args = lapply(
      X = names(fits),
      FUN = function(fit) {
        out <- readLines(
          file.path(
            data_private,
            paste0(fits[[fit]], ".out")
          )
        )
        psr <- grep(
          pattern = "^ +[0-9]+ +[0-9]+\\.[0-9]+ +[0-9]+ *$",
          x = out,
          value = TRUE
        )
        psr <- as.numeric(
          strsplit(
            x = trimws(utils::tail(psr, 1L)),
            split = " +"
          )[[1]]
        )
        elapsed <- sub(
          pattern = "^ *Elapsed Time: *",
          replacement = "",
          x = grep(
            pattern = "Elapsed Time:",
            x = out,
            value = TRUE
          )
        )
        p <- parameters[parameters$fit == fit, ]
        data.frame(
          fit = fit,
          iterations = psr[1],
          psr = psr[2],
          psr_parameter = psr[3],
          elapsed = elapsed,
          terminated_normally = any(
            grepl(
              pattern = "THE MODEL ESTIMATION TERMINATED NORMALLY",
              x = out,
              fixed = TRUE
            )
          ),
          rhat_max = max(p$rhat),
          ess_bulk_min = min(p$ess_bulk),
          ess_tail_min = min(p$ess_tail),
          strict_fail = sum(!p$strict),
          moderate_fail = sum(!p$moderate)
        )
      }
    )
  )
  # check: the rank-normalized R-hat of the PA-inertia variance reported in
  # V1 (1.442 default, 1.462 custom priors)
  check <- round(
    parameters$rhat[
      parameters$parameter == "var(BETA22)" &
        parameters$fit %in% c("default", "priors")
    ],
    digits = 3
  )
  if (!isTRUE(all.equal(check, c(1.442, 1.462)))) {
    stop(
      paste0(
        "R-hat of var(BETA22) is ",
        paste(check, collapse = " and "),
        ", not 1.442 and 1.462."
      ),
      call. = FALSE
    )
  }
  saveRDS(
    object = list(
      parameters = parameters,
      run = run,
      criteria = criteria
    ),
    file = output,
    compress = "xz"
  )
  invisible(output)
}
data_analysis_adid2010_dsem_compare()
rm(data_analysis_adid2010_dsem_compare)
