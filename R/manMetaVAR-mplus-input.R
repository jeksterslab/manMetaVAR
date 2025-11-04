#' Create Mplus Input File
#'
#' The function creates an Mplus input file.
#'
#' @inheritParams Template
#'
#' @examples
#' cat(
#'   MplusInput(
#'     dynamics = 1,
#'     fn_data = "data.dat",
#'     fn_posterior = "posterior.dat",
#'     fn_factorscores = "factorscores.dat",
#'     chains = 2L,
#'     iter = 60000L,
#'     fscores = 1000L,
#'     plot = TRUE,
#'     default_priors = FALSE,
#'     ncores = NULL
#'   )
#' )
#'
#' @family Model Fitting Functions
#' @keywords manMetaVAR fit
#' @export
MplusInput <- function(dynamics,
                       fn_data,
                       fn_posterior,
                       fn_factorscores,
                       chains,
                       iter,
                       fscores,
                       plot,
                       default_priors,
                       ncores = NULL) {
  stopifnot(
    chains > 1,
    iter > 1
  )
  if (is.null(ncores)) {
    ncores <- 1L
  } else {
    ncores <- as.integer(ncores)
    available_cores <- parallel::detectCores()
    if (ncores > 1) {
      if (ncores >= available_cores) {
        ncores <- available_cores
      }
      if (ncores >= 2) {
        ncores <- 2
      }
    } else {
      stop("'ncores' should be greater than 0.")
    }
  }
  if (is.null(fn_data)) {
    fn_data <- "data.dat"
  }
  if (is.null(fn_posterior)) {
    fn_posterior <- "posterior.dat"
  }
  if (is.null(fn_factorscores)) {
    fn_factorscores <- "factorscores.dat"
  }
  model <- Dynamics(dynamics = dynamics)
  t11 <- if (model$theta[1, 1] == 0) 0.001 else model$theta[1, 1]
  t22 <- if (model$theta[2, 2] == 0) 0.001 else model$theta[2, 2]
  p11 <- if (model$psi[1, 1] == 0) 0.001 else model$psi[1, 1]
  p21 <- if (model$psi[2, 1] == 0) 0.001 else model$psi[2, 1]
  p22 <- if (model$psi[2, 2] == 0) 0.001 else model$psi[2, 2]
  m_b11 <- if (model$ma_fixed[1] == 0) 0.001 else model$ma_fixed[1]
  m_b21 <- if (model$ma_fixed[2] == 0) 0.001 else model$ma_fixed[2]
  m_b12 <- if (model$ma_fixed[3] == 0) 0.001 else model$ma_fixed[3]
  m_b22 <- if (model$ma_fixed[4] == 0) 0.001 else model$ma_fixed[4]
  m_n11 <- if (model$ma_fixed[5] == 0) 0.001 else model$ma_fixed[5]
  m_n21 <- if (model$ma_fixed[6] == 0) 0.001 else model$ma_fixed[6]
  c_b11b11 <- if (model$ma_random[1, 1] == 0) 0.001 else model$ma_random[1, 1]
  c_b21b11 <- if (model$ma_random[2, 1] == 0) 0.001 else model$ma_random[2, 1]
  c_b12b11 <- if (model$ma_random[3, 1] == 0) 0.001 else model$ma_random[3, 1]
  c_b22b11 <- if (model$ma_random[4, 1] == 0) 0.001 else model$ma_random[4, 1]
  c_n11b11 <- if (model$ma_random[5, 1] == 0) 0.001 else model$ma_random[5, 1]
  c_n21b11 <- if (model$ma_random[6, 1] == 0) 0.001 else model$ma_random[6, 1]
  c_b21b21 <- if (model$ma_random[2, 2] == 0) 0.001 else model$ma_random[2, 2]
  c_b12b21 <- if (model$ma_random[3, 2] == 0) 0.001 else model$ma_random[3, 2]
  c_b22b21 <- if (model$ma_random[4, 2] == 0) 0.001 else model$ma_random[4, 2]
  c_n11b21 <- if (model$ma_random[5, 2] == 0) 0.001 else model$ma_random[5, 2]
  c_n21b21 <- if (model$ma_random[6, 2] == 0) 0.001 else model$ma_random[6, 2]
  c_b12b12 <- if (model$ma_random[3, 3] == 0) 0.001 else model$ma_random[3, 3]
  c_b22b12 <- if (model$ma_random[4, 3] == 0) 0.001 else model$ma_random[4, 3]
  c_n11b12 <- if (model$ma_random[5, 3] == 0) 0.001 else model$ma_random[5, 3]
  c_n21b12 <- if (model$ma_random[6, 3] == 0) 0.001 else model$ma_random[6, 3]
  c_b22b22 <- if (model$ma_random[4, 4] == 0) 0.001 else model$ma_random[4, 4]
  c_n11b22 <- if (model$ma_random[5, 4] == 0) 0.001 else model$ma_random[5, 4]
  c_n21b22 <- if (model$ma_random[6, 4] == 0) 0.001 else model$ma_random[6, 4]
  c_n11n11 <- if (model$ma_random[5, 5] == 0) 0.001 else model$ma_random[5, 5]
  c_n21n11 <- if (model$ma_random[6, 5] == 0) 0.001 else model$ma_random[6, 5]
  c_n21n21 <- if (model$ma_random[6, 6] == 0) 0.001 else model$ma_random[6, 6]
  if (!default_priors) {
    ig <- function(expected_value,
                   alpha,
                   label) {
      paste0(
        label,
        "~",
        "IG(",
        alpha,
        ",",
        expected_value * (alpha - 1),
        ")"
      )
    }
    iw <- function(scale,
                   df,
                   label) {
      paste0(
        label,
        "~",
        "IW(",
        scale,
        ",",
        df,
        ")"
      )
    }
    normal <- function(expected_value,
                       sigma,
                       label) {
      paste0(
        label,
        "~",
        "N(",
        expected_value,
        ",",
        sigma,
        ")"
      )
    }
    prior_t11 <- ig(expected_value = t11, alpha = 3, label = "t11")
    prior_t22 <- ig(expected_value = t11, alpha = 3, label = "t22")
    prior_p11 <- iw(scale = 0.50, df = 12, label = "p11")
    prior_p21 <- iw(scale = 0.50, df = 12, label = "p21")
    prior_p22 <- iw(scale = 0.50, df = 12, label = "p22")
    prior_m_b11 <- normal(expected_value = 0, sigma = 1, label = "m_b11")
    prior_m_b21 <- normal(expected_value = 0, sigma = 1, label = "m_b21")
    prior_m_b12 <- normal(expected_value = 0, sigma = 1, label = "m_b12")
    prior_m_b22 <- normal(expected_value = 0, sigma = 1, label = "m_b22")
    prior_m_n11 <- normal(expected_value = 0, sigma = 1, label = "m_n11")
    prior_m_n21 <- normal(expected_value = 0, sigma = 1, label = "m_n21")
    prior_c_b11b11 <- iw(scale = 0.50, df = 12, label = "c_b11b11")
    prior_c_b21b11 <- iw(scale = 0.50, df = 12, label = "c_b21b11")
    prior_c_b12b11 <- iw(scale = 0.50, df = 12, label = "c_b12b11")
    prior_c_b22b11 <- iw(scale = 0.50, df = 12, label = "c_b22b11")
    prior_c_n11b11 <- iw(scale = 0.50, df = 12, label = "c_n11b11")
    prior_c_n21b11 <- iw(scale = 0.50, df = 12, label = "c_n21b11")
    prior_c_b21b21 <- iw(scale = 0.50, df = 12, label = "c_b21b21")
    prior_c_b12b21 <- iw(scale = 0.50, df = 12, label = "c_b12b21")
    prior_c_b22b21 <- iw(scale = 0.50, df = 12, label = "c_b22b21")
    prior_c_n11b21 <- iw(scale = 0.50, df = 12, label = "c_n11b21")
    prior_c_n21b21 <- iw(scale = 0.50, df = 12, label = "c_n21b21")
    prior_c_b12b12 <- iw(scale = 0.50, df = 12, label = "c_b12b12")
    prior_c_b22b12 <- iw(scale = 0.50, df = 12, label = "c_b22b12")
    prior_c_n11b12 <- iw(scale = 0.50, df = 12, label = "c_n11b12")
    prior_c_n21b12 <- iw(scale = 0.50, df = 12, label = "c_n21b12")
    prior_c_b22b22 <- iw(scale = 0.50, df = 12, label = "c_b22b22")
    prior_c_n11b22 <- iw(scale = 0.50, df = 12, label = "c_n11b22")
    prior_c_n21b22 <- iw(scale = 0.50, df = 12, label = "c_n21b22")
    prior_c_n11n11 <- iw(scale = 0.50, df = 12, label = "c_n11n11")
    prior_c_n21n11 <- iw(scale = 0.50, df = 12, label = "c_n21n11")
    prior_c_n21n21 <- iw(scale = 0.50, df = 12, label = "c_n21n21")
    prior_value <- c(
      prior_t11,
      prior_t22,
      prior_p11,
      prior_p21,
      prior_p22,
      prior_m_b11,
      prior_m_b21,
      prior_m_b12,
      prior_m_b22,
      prior_m_n11,
      prior_m_n21,
      prior_c_b11b11,
      prior_c_b21b11,
      prior_c_b12b11,
      prior_c_b22b11,
      prior_c_n11b11,
      prior_c_n21b11,
      prior_c_b21b21,
      prior_c_b12b21,
      prior_c_b22b21,
      prior_c_n11b21,
      prior_c_n21b21,
      prior_c_b12b12,
      prior_c_b22b12,
      prior_c_n11b12,
      prior_c_n21b12,
      prior_c_b22b22,
      prior_c_n11b22,
      prior_c_n21b22,
      prior_c_n11n11,
      prior_c_n21n11,
      prior_c_n21n21
    )
    prior_label <- c(
      "prior_t11",
      "prior_t22",
      "prior_p11",
      "prior_p21",
      "prior_p22",
      "prior_m_b11",
      "prior_m_b21",
      "prior_m_b12",
      "prior_m_b22",
      "prior_m_n11",
      "prior_m_n21",
      "prior_c_b11b11",
      "prior_c_b21b11",
      "prior_c_b12b11",
      "prior_c_b22b11",
      "prior_c_n11b11",
      "prior_c_n21b11",
      "prior_c_b21b21",
      "prior_c_b12b21",
      "prior_c_b22b21",
      "prior_c_n11b21",
      "prior_c_n21b21",
      "prior_c_b12b12",
      "prior_c_b22b12",
      "prior_c_n11b12",
      "prior_c_n21b12",
      "prior_c_b22b22",
      "prior_c_n11b22",
      "prior_c_n21b22",
      "prior_c_n11n11",
      "prior_c_n21n11",
      "prior_c_n21n21"
    )
  }
  start_value <- c(
    t11,
    t22,
    p11,
    p21,
    p22,
    m_b11,
    m_b21,
    m_b12,
    m_b22,
    m_n11,
    m_n21,
    c_b11b11,
    c_b21b11,
    c_b12b11,
    c_b22b11,
    c_n11b11,
    c_n21b11,
    c_b21b21,
    c_b12b21,
    c_b22b21,
    c_n11b21,
    c_n21b21,
    c_b12b12,
    c_b22b12,
    c_n11b12,
    c_n21b12,
    c_b22b22,
    c_n11b22,
    c_n21b22,
    c_n11n11,
    c_n21n11,
    c_n21n21
  )
  start_label <- c(
    "t11",
    "t22",
    "p11",
    "p21",
    "p22",
    "m_b11",
    "m_b21",
    "m_b12",
    "m_b22",
    "m_n11",
    "m_n21",
    "c_b11b11",
    "c_b21b11",
    "c_b12b11",
    "c_b22b11",
    "c_n11b11",
    "c_n21b11",
    "c_b21b21",
    "c_b12b21",
    "c_b22b21",
    "c_n11b21",
    "c_n21b21",
    "c_b12b12",
    "c_b22b12",
    "c_n11b12",
    "c_n21b12",
    "c_b22b22",
    "c_n11b22",
    "c_n21b22",
    "c_n11n11",
    "c_n21n11",
    "c_n21n21"
  )
  out <- "
    TITLE:
      Multilevel Vector Autoregressive Model with Measurement Error
    DATA:
      FILE = __DATA__;
    VARIABLE:
      NAMES = ID TIME Y1 Y2;
      USEVARIABLES = Y1 Y2;
      CLUSTER = ID;
    ANALYSIS:
      TYPE = TWOLEVEL RANDOM;
      ESTIMATOR = BAYES;
      CHAINS = __CHAINS__;
      FBITER = (__FBITER__);
      PROCESSORS = __PROCESSORS__;
    MODEL:
      %WITHIN%
        ETA1 BY Y1@1(&1);
        ETA2 BY Y2@1(&1);
        ! measurement error variances (theta)
        Y1__t11__ (t11);
        Y2__t22__ (t22);
        [ETA1@0];
        [ETA2@0];
        BETA11 | ETA1 ON ETA1&1;
        BETA21 | ETA2 ON ETA1&1;
        BETA12 | ETA1 ON ETA2&1;
        BETA22 | ETA2 ON ETA2&1;
        ! process noise covariance matrix (psi)
        ETA1__p11__ (p11);
        ETA2 WITH ETA1__p21__ (p21);
        ETA2__p22__ (p22);
      %BETWEEN%
        Y1@0;
        Y2@0;
        [Y1@0];
        [Y2@0];
        NU11 BY Y1@1;
        NU21 BY Y2@1;
        ! fixed effects
        !! transition matrix (beta)
        [BETA11__m_b11__] (m_b11);
        [BETA21__m_b21__] (m_b21);
        [BETA12__m_b12__] (m_b12);
        [BETA22__m_b22__] (m_b22);
        !! measurement model intercept (nu)
        [NU11__m_n11__] (m_n11);
        [NU21__m_n21__] (m_n21);
        ! random effects
        BETA11__c_b11b11__ (c_b11b11);
        BETA21 WITH BETA11__c_b21b11__ (c_b21b11);
        BETA12 WITH BETA11__c_b12b11__ (c_b12b11);
        BETA22 WITH BETA11__c_b22b11__ (c_b22b11);
        NU11 WITH BETA11__c_n11b11__ (c_n11b11);
        NU21 WITH BETA11__c_n21b11__ (c_n21b11);
        BETA21__c_b21b21__ (c_b21b21);
        BETA12 WITH BETA21__c_b12b21__ (c_b12b21);
        BETA22 WITH BETA21__c_b22b21__ (c_b22b21);
        NU11 WITH BETA21__c_n11b21__ (c_n11b21);
        NU21 WITH BETA21__c_n21b21__ (c_n21b21);
        BETA12__c_b12b12__ (c_b12b12);
        BETA22 WITH BETA12__c_b22b12__ (c_b22b12);
        NU11 WITH BETA12__c_n11b12__ (c_n11b12);
        NU21 WITH BETA12__c_n21b12__ (c_n21b12);
        BETA22__c_b22b22__ (c_b22b22);
        NU11 WITH BETA22__c_n11b22__ (c_n11b22);
        NU21 WITH BETA22__c_n21b22__ (c_n21b22);
        NU11__c_n11n11__ (c_n11n11);
        NU21 WITH NU11__c_n21n11__ (c_n21n11);
        NU21__c_n21n21__ (c_n21n21);"
  if (!default_priors) {
    priors <- "
    MODEL PRIORS:
      __prior_t11__;
      __prior_t22__;
      __prior_p11__;
      __prior_p21__;
      __prior_p22__;
      __prior_m_b11__;
      __prior_m_b21__;
      __prior_m_b12__;
      __prior_m_b22__;
      __prior_m_n11__;
      __prior_m_n21__;
      __prior_c_b11b11__;
      __prior_c_b21b11__;
      __prior_c_b12b11__;
      __prior_c_b22b11__;
      __prior_c_n11b11__;
      __prior_c_n21b11__;
      __prior_c_b21b21__;
      __prior_c_b12b21__;
      __prior_c_b22b21__;
      __prior_c_n11b21__;
      __prior_c_n21b21__;
      __prior_c_b12b12__;
      __prior_c_b22b12__;
      __prior_c_n11b12__;
      __prior_c_n21b12__;
      __prior_c_b22b22__;
      __prior_c_n11b22__;
      __prior_c_n21b22__;
      __prior_c_n11n11__;
      __prior_c_n21n11__;
      __prior_c_n21n21__;"
    out <- paste0(
      out,
      priors
    )
    for (i in seq_along(prior_value)) {
      out <- sub(
        pattern = paste0(
          "__",
          prior_label[i],
          "__"
        ),
        replacement = prior_value[i],
        x = out
      )
    }
  }
  for (i in seq_along(start_value)) {
    out <- sub(
      pattern = paste0(
        "__",
        start_label[i],
        "__"
      ),
      replacement = paste0(
        "*",
        sprintf(
          fmt = "%.3f",
          start_value[i]
        )
      ),
      x = out
    )
  }
  if (plot) {
    out <- paste0(
      out,
      "\n    PLOT:\n      TYPE = PLOT3;"
    )
  }
  out <- paste0(
    out,
    "
    OUTPUT:
      TECH1 TECH8;
    SAVEDATA:
      BPARAMETERS = __POSTERIOR__;"
  )
  if (!is.null(fscores)) {
    out <- paste0(
      out,
      "
        SAVE = FSCORES(__FSCORES__ 1);
        FILE = __FACTORSCORES__;
        FACTORS = ALL;"
    )
  }
  pattern <- c(
    "__DATA__",
    "__CHAINS__",
    "__FBITER__",
    "__PROCESSORS__",
    "__POSTERIOR__",
    "__FSCORES__",
    "__FACTORSCORES__"
  )
  replacement <- c(
    fn_data,
    as.integer(chains),
    as.integer(iter),
    as.integer(ncores),
    fn_posterior,
    fscores,
    fn_factorscores
  )
  for (i in seq_along(pattern)) {
    out <- sub(
      pattern = pattern[i],
      replacement = replacement[i],
      x = out
    )
  }
  out
}
