#' Create Mplus Input File
#'
#' The function creates an Mplus input file.
#'
#' @inheritParams Template
#'
#' @examples
#' cat(MplusInput())
#'
#' @family Model Fitting Functions
#' @keywords manMetaVAR fit
#' @export
MplusInput <- function(fn_data = NULL,
                       fn_estimates = NULL,
                       fn_results = NULL,
                       fn_posterior = NULL,
                       fn_factorscores = NULL,
                       ncores = NULL) {
  if (is.null(fn_data)) {
    fn_data <- "data.dat"
  }
  if (is.null(fn_estimates)) {
    fn_estimates <- "estimates.dat"
  }
  if (is.null(fn_results)) {
    fn_results <- "results.dat"
  }
  if (is.null(fn_posterior)) {
    fn_posterior <- "posterior.dat"
  }
  if (is.null(fn_factorscores)) {
    fn_factorscores <- "factorscores.dat"
  }
  if (is.null(ncores)) {
    ncores <- 1L
  } else {
    ncores <- as.integer(ncores)
    available_cores <- parallel::detectCores()
    if (ncores > 1) {
      if (ncores >= available_cores) {
        ncores <- available_cores
      }
      if (ncores >= 4) {
        ncores <- 4
      }
    } else {
      stop("'ncores' should be greater than 0.")
    }
  }
  out <- "
    TITLE:
      Multilevel Vector Autoregressive Model with Measurement Error
    DATA:
      FILE = __DATA__;
    DATA IMPUTATION:
      THIN = 100;
    VARIABLE:
      NAMES = ID TIME Y1 Y2;
      USEVARIABLES = Y1 Y2;
      CLUSTER = ID;
    ANALYSIS:
      TYPE = TWOLEVEL RANDOM;
      ESTIMATOR = BAYES;
      CHAINS = 4;
      FBITER = (120000);
      PROCESSORS = __PROCESSORS__;
    MODEL:
      %WITHIN%
        ETA1 BY Y1@1(&1);
        ETA2 BY Y2@1(&1);
        Y1 (t11);                     ! theta_11
        Y2 (t22);                     ! theta_22
        [ETA1@0];
        [ETA2@0];
        BETA11 | ETA1 ON ETA1&1;
        BETA21 | ETA2 ON ETA1&1;
        BETA12 | ETA1 ON ETA2&1;
        BETA22 | ETA2 ON ETA2&1;
        ETA1 WITH ETA1 (p11);         ! psi_11
        ETA2 WITH ETA1 (p21);         ! psi_21
        ETA2 WITH ETA2 (p22);         ! psi_22
      %BETWEEN%
        Y1@0;
        Y2@0;
        [Y1@0];
        [Y2@0];
        NU1 BY Y1@1;
        NU2 BY Y2@1;
        [BETA11] (m_b11);             ! mean(beta_11)
        [BETA21] (m_b21);             ! mean(beta_21)
        [BETA12] (m_b12);             ! mean(beta_12)
        [BETA22] (m_b22);             ! mean(beta_22)
        [NU1] (m_n1);                 ! mean(nu_1)
        [NU2] (m_n2);                 ! mean(nu_2)
        BETA11 WITH BETA11 (c_b1111); ! cov(beta_11, beta_11)
        BETA21 WITH BETA11 (c_b2111); ! cov(beta_21, beta_11)
        BETA12 WITH BETA11 (c_b1211); ! cov(beta_12, beta_11)
        BETA22 WITH BETA11 (c_b2211); ! cov(beta_22, beta_11)
        NU1 WITH BETA11 (c_n1b11);    ! cov(nu_1, beta_11)
        NU2 WITH BETA11 (c_n2b11);    ! cov(nu_2, beta_11)
        BETA21 WITH BETA21 (c_b2121); ! cov(beta_21, beta_21)
        BETA12 WITH BETA21 (c_b1221); ! cov(beta_12, beta_21)
        BETA22 WITH BETA21 (c_b2221); ! cov(beta_22, beta_21)
        NU1 WITH BETA21 (c_n1b21);    ! cov(nu_1, beta_21)
        NU2 WITH BETA21 (c_n2b21);    ! cov(nu_2, beta_21)
        BETA12 WITH BETA12 (c_b1212); ! cov(beta_12, beta_12)
        BETA22 WITH BETA12 (c_b2212); ! cov(beta_22, beta_12)
        NU1 WITH BETA12 (c_n1b12);    ! cov(nu_1, beta_12)
        NU2 WITH BETA12 (c_n2b12);    ! cov(nu_2, beta_12)
        BETA22 WITH BETA22 (c_b2222); ! cov(beta_22, beta_22)
        NU1 WITH BETA22 (c_n1b22);    ! cov(nu_1, beta_22)
        NU2 WITH BETA22 (c_n2b22);    ! cov(nu_2, beta_22)
        NU1 WITH NU1 (c_n11);         ! cov(nu_1, nu_1)
        NU2 WITH NU1 (c_n21);         ! cov(nu_2, nu_1)
        NU2 WITH NU2 (c_n22);         ! cov(nu_2, nu_2)
    MODEL PRIORS:
        t11 ~ IG(8, 3.5);
        t22 ~ IG(8, 3.5);
        c_n1b11 ~ N(0,1);
        c_n2b11 ~ N(0,1);
        c_n1b21 ~ N(0,1);
        c_n2b21 ~ N(0,1);
        c_n1b12 ~ N(0,1);
        c_n2b12 ~ N(0,1);
        c_n1b22 ~ N(0,1);
        c_n2b22 ~ N(0,1);
    PLOT:
      TYPE = PLOT1 PLOT2 PLOT3;
    OUTPUT:
      TECH1 TECH8 TECH9;
    SAVEDATA:
      ESTIMATES = __ESTIMATES__;
      RESULTS = __RESULTS__;
      BPARAMETERS = __POSTERIOR__;
      SAVE = FSCORES(1000);
      FILE = __FACTORSCORES__;
      FACTORS = ALL;
  "
  out <- sub(
    pattern = "__DATA__",
    replacement = fn_data,
    x = out
  )
  out <- sub(
    pattern = "__PROCESSORS__",
    replacement = ncores,
    x = out
  )
  out <- sub(
    pattern = "__ESTIMATES__",
    replacement = fn_estimates,
    x = out
  )
  out <- sub(
    pattern = "__RESULTS__",
    replacement = fn_results,
    x = out
  )
  out <- sub(
    pattern = "__POSTERIOR__",
    replacement = fn_posterior,
    x = out
  )
  out <- sub(
    pattern = "__FACTORSCORES__",
    replacement = fn_factorscores,
    x = out
  )
  out
}
