data_analysis_adid2010_dsem_priors_2_values <- function() {
  # Prior centers for adid2010-dsem-priors-2.inp, taken from the MetaVAR
  # Stage 2 fit. The innovation block in Mplus is (LOGV1, LOGV2, ZCOR12), so
  # its means and covariance are mapped from MetaVAR's (xi11, xi21, xi22)
  # with the delta method.
  root <- rprojroot::is_rstudio_project
  fit <- readRDS(
    root$find_file(
      ".setup",
      "data-private",
      "adid2010-stage-2-random.Rds"
    )
  )
  est <- coef(fit$output)
  alpha_names <- paste0("alpha_", 1:9, "_1")
  alpha <- unname(est[alpha_names])
  alpha_vcov <- vcov(fit$output)[alpha_names, alpha_names]
  tau_sqr <- OpenMx::mxEvalByName(
    "tau_sqr",
    fit$output
  )
  # innovation means and variances: xi11 = alpha[7], xi21 = alpha[8],
  # xi22 = alpha[9]
  g <- function(x) {
    c(
      log(x[1]),
      log(x[3]),
      atanh(x[2] / sqrt(x[1] * x[3]))
    )
  }
  jac <- function(x) {
    s <- sqrt(x[1] * x[3])
    r <- x[2] / s
    dz <- 1 / (1 - r^2)
    rbind(
      c(1 / x[1], 0, 0),
      c(0, 0, 1 / x[3]),
      dz * c(-r / (2 * x[1]), 1 / s, -r / (2 * x[3]))
    )
  }
  xi <- alpha[7:9]
  j <- jac(xi)
  innovation_mean <- g(xi)
  innovation_tau_sqr <- j %*% tau_sqr[7:9, 7:9] %*% t(j)
  innovation_se2 <- diag(j %*% alpha_vcov[7:9, 7:9] %*% t(j))
  list(
    setpoint_mean = alpha[1:2],
    setpoint_se2 = diag(alpha_vcov)[1:2],
    setpoint_tau_sqr = tau_sqr[1:2, 1:2],
    transition_mean = alpha[3:6],
    transition_se2 = diag(alpha_vcov)[3:6],
    transition_tau_sqr = tau_sqr[3:6, 3:6],
    innovation_mean = innovation_mean,
    innovation_se2 = innovation_se2,
    innovation_tau_sqr = innovation_tau_sqr
  )
}

data_analysis_adid2010_dsem_priors_2_inp <- function(n_prior = 212,
                                                     diagonal = FALSE,
                                                     name = "adid2010-dsem-priors-2",
                                                     overwrite = FALSE) {
  # Writes <name>.inp from adid2010-dsem-priors.inp,
  # replacing only the title, MODEL PRIORS, and output file names.
  # Location priors: N(MetaVAR estimate, MetaVAR sampling variance).
  # Covariance priors: IW(S, df) with df = n_prior + p + 1 and
  # S = n_prior * MetaVAR tau_sqr block, so the prior mean equals the
  # MetaVAR estimate and the prior carries the weight of n_prior persons.
  # With diagonal = TRUE, S keeps only the diagonal of the block
  # (prior mean: MetaVAR variances, zero covariances), as in
  # adid2010-dsem-priors-3.inp
  # (data_analysis_adid2010_dsem_priors_2_inp(
  #   diagonal = TRUE, name = "adid2010-dsem-priors-3"
  # )).
  root <- rprojroot::is_rstudio_project
  data_private <- root$find_file(
    ".setup",
    "data-private"
  )
  output <- file.path(
    data_private,
    paste0(name, ".inp")
  )
  if (file.exists(output) && !overwrite) {
    return(invisible(output))
  }
  v <- data_analysis_adid2010_dsem_priors_2_values()
  f <- function(x) {
    formatC(x, digits = 6, format = "g")
  }
  normal <- function(label, mean, var) {
    sprintf("  %s ~ N(%s, %s);", label, f(mean), f(var))
  }
  iw <- function(labels, tau_sqr) {
    p <- nrow(tau_sqr)
    df <- n_prior + p + 1
    s <- n_prior * tau_sqr
    if (diagonal) {
      s <- diag(diag(s), nrow = p)
    }
    out <- character(0)
    for (i in seq_len(p)) {
      for (j in seq_len(i)) {
        out <- c(
          out,
          sprintf("  %s ~ IW(%s, %d);", labels[i, j], f(s[i, j]), df)
        )
      }
    }
    out
  }
  lab_sp <- matrix(c("vsp1", "csp12", "csp12", "vsp2"), 2, 2)
  lab_b <- matrix("", 4, 4)
  diag(lab_b) <- c("vb11", "vb21", "vb12", "vb22")
  lab_b[2, 1] <- "cb1121"
  lab_b[3, 1] <- "cb1112"
  lab_b[3, 2] <- "cb2112"
  lab_b[4, 1] <- "cb1122"
  lab_b[4, 2] <- "cb2122"
  lab_b[4, 3] <- "cb1222"
  lab_v <- matrix("", 3, 3)
  diag(lab_v) <- c("vlv1", "vlv2", "vrc12")
  lab_v[2, 1] <- "clv12"
  lab_v[3, 1] <- "clv1r"
  lab_v[3, 2] <- "clv2r"
  priors <- c(
    "MODEL PRIORS:",
    "",
    "  ! Data-informed priors centered on the MetaVAR estimates",
    sprintf(
      "  ! (adid2010-stage-2-random.Rds); prior weight of %d persons.",
      n_prior
    ),
    "  ! Location priors: N(MetaVAR estimate, MetaVAR sampling variance).",
    if (diagonal) {
      c(
        "  ! Covariance priors: IW(n * diag(tau_sqr), n + p + 1), prior mean",
        "  ! diag(tau_sqr): MetaVAR variances, zero covariances."
      )
    } else {
      "  ! Covariance priors: IW(n * tau_sqr, n + p + 1), prior mean tau_sqr."
    },
    "  ! Innovation block mapped to (LOGV1, LOGV2, ZCOR12) by the delta",
    "  ! method.",
    "",
    normal("msp1", v$setpoint_mean[1], v$setpoint_se2[1]),
    normal("msp2", v$setpoint_mean[2], v$setpoint_se2[2]),
    normal("mb11", v$transition_mean[1], v$transition_se2[1]),
    normal("mb21", v$transition_mean[2], v$transition_se2[2]),
    normal("mb12", v$transition_mean[3], v$transition_se2[3]),
    normal("mb22", v$transition_mean[4], v$transition_se2[4]),
    normal("mlv1", v$innovation_mean[1], v$innovation_se2[1]),
    normal("mlv2", v$innovation_mean[2], v$innovation_se2[2]),
    normal("mrc12", v$innovation_mean[3], v$innovation_se2[3]),
    "",
    iw(lab_sp, v$setpoint_tau_sqr),
    "",
    iw(lab_b, v$transition_tau_sqr),
    "",
    iw(lab_v, v$innovation_tau_sqr),
    ""
  )
  template <- readLines(
    file.path(
      data_private,
      "adid2010-dsem-priors.inp"
    )
  )
  start <- grep("^MODEL PRIORS:", template)
  end <- grep("^MODEL CONSTRAINT:", template)
  inp <- c(
    template[seq_len(start - 1)],
    priors,
    template[end:length(template)]
  )
  inp <- sub(
    "(user specified priors);",
    if (diagonal) {
      "(MetaVAR-informed priors, diagonal base);"
    } else {
      "(MetaVAR-informed priors);"
    },
    inp,
    fixed = TRUE
  )
  inp <- sub(
    "adid2010-dsem-priors-posterior.txt",
    paste0(name, "-posterior.txt"),
    inp,
    fixed = TRUE
  )
  writeLines(inp, output)
  invisible(output)
}
