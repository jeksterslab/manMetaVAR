#' Create Mplus Input File
#'
#' The function creates an Mplus input file.
#'
#' @inheritParams Template
#'
#' @examples
#' cat(
#'   MplusInput(
#'     fn_data = "data.dat",
#'     fn_posterior = "posterior.dat",
#'     fn_factorscores = "factorscores.dat",
#'     chains = 2L,
#'     iter = 40000L,
#'     fscores = 1000L,
#'     plot = TRUE,
#'     default_priors = TRUE,
#'     ncores = NULL,
#'     seed = 42
#'   )
#' )
#'
#' @family Model Fitting Functions
#' @keywords manMetaVAR fit
#' @export
MplusInput <- function(fn_data,
                       fn_posterior,
                       fn_factorscores,
                       chains,
                       iter,
                       fscores,
                       plot,
                       default_priors = TRUE,
                       ncores = NULL,
                       seed = NULL) {
  stopifnot(
    chains > 1,
    iter > 1
  )
  if (is.null(seed)) {
    seed <- 42
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
  out <- "
    TITLE:
      Multilevel Vector Autoregressive Model
    DATA:
      FILE = __DATA__;
    VARIABLE:
      NAMES = ID TIME Y1 Y2;
      USEVARIABLES = Y1 Y2;
      MISSING = ALL (-999);
      CLUSTER = ID;
      LAGGED = Y1(1) Y2(1);
    ANALYSIS:
      TYPE = TWOLEVEL RANDOM;
      ESTIMATOR = BAYES;
      CHAINS = __CHAINS__;
      FBITER = (__FBITER__);
      PROCESSORS = __PROCESSORS__;
      BSEED = __BSEED__;
    MODEL:
      %WITHIN%
        ! transition matrix
        BETA11 | Y1 ON Y1&1;
        BETA21 | Y2 ON Y1&1;
        BETA12 | Y1 ON Y2&1;
        BETA22 | Y2 ON Y2&1;

        ! within-person innovation covariance
        Y1 (W1);
        Y2 WITH Y1 (W2);
        Y2 (W3);

      %BETWEEN%
        ! population means of person-specific set points
        [Y1] (FM1);
        [Y2] (FM2);

        ! between-person covariance of set points
        Y1 (M1);
        Y2 WITH Y1 (M2);
        Y2 (M3);

        ! population-average transition coefficients
        [BETA11] (FB1);
        [BETA21] (FB2);
        [BETA12] (FB3);
        [BETA22] (FB4);

        ! between-person covariance of transition coefficients
        BETA11 (B1);
        BETA21 WITH BETA11 (B2);
        BETA12 WITH BETA11 (B3);
        BETA22 WITH BETA11 (B4);

        BETA21 (B5);
        BETA12 WITH BETA21 (B6);
        BETA22 WITH BETA21 (B7);

        BETA12 (B8);
        BETA22 WITH BETA12 (B9);

        BETA22 (B10);"
  if (!default_priors) {
    priors <- "
    MODEL PRIORS:
      ! relatively weakly informative, scale-aware fixed-effect priors
      FM1-FM2 ~ N(0, 25);
      FB1-FB4 ~ N(0, 0.25);

      ! proper inverse-Wishart prior for innovation covariance
      W1 ~ IW(1, 3);
      W2 ~ IW(0, 3);
      W3 ~ IW(1, 3);

      ! proper inverse-Wishart prior for set-point heterogeneity
      M1 ~ IW(1, 3);
      M2 ~ IW(0, 3);
      M3 ~ IW(1, 3);

      ! scale-calibrated inverse-Wishart prior for
      ! transition heterogeneity
      B1    ~ IW(0.004, 5);
      B2-B4 ~ IW(0, 5);
      B5    ~ IW(0.004, 5);
      B6-B7 ~ IW(0, 5);
      B8    ~ IW(0.004, 5);
      B9    ~ IW(0, 5);
      B10   ~ IW(0.004, 5);"
    out <- paste0(
      out,
      "\n",
      priors
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
  pattern <- c(
    "__DATA__",
    "__CHAINS__",
    "__FBITER__",
    "__PROCESSORS__",
    "__POSTERIOR__",
    "__BSEED__"
  )
  replacement <- c(
    as.character(fn_data),
    as.character(as.integer(chains)),
    as.character(as.integer(iter)),
    as.character(as.integer(ncores)),
    as.character(fn_posterior),
    as.character(as.integer(seed))
  )
  if (!is.null(fscores)) {
    out <- paste0(
      out,
      "
      SAVE = FSCORES(__FSCORES__ 1);
      FILE = __FACTORSCORES__;
      FACTORS = ALL;"
    )
    pattern <- c(
      pattern,
      "__FSCORES__",
      "__FACTORSCORES__"
    )
    replacement <- c(
      replacement,
      as.character(as.integer(fscores)),
      as.character(fn_factorscores)
    )
  }
  for (i in seq_along(pattern)) {
    out <- sub(
      pattern = pattern[i],
      replacement = replacement[i],
      x = out
    )
  }
  out
}
