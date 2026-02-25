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
        ! transition matrix (beta)
        BETA11 | Y1 ON Y1&1;
        BETA21 | Y2 ON Y1&1;
        BETA12 | Y1 ON Y2&1;
        BETA22 | Y2 ON Y2&1;
        ! process noise covariance matrix (psi)
        Y1;
        Y2 WITH Y1;
        Y2;
      %BETWEEN%
        ! person-specific means (mu)
        [Y1];
        [Y2];
        Y1;
        Y2 WITH Y1;
        Y2;
        ! person-specific lagged effects (beta)
        [BETA11];
        [BETA21];
        [BETA12];
        [BETA22];
        BETA11;
        BETA21 WITH BETA11;
        BETA12 WITH BETA11;
        BETA22 WITH BETA11;
        BETA21;
        BETA12 WITH BETA21;
        BETA22 WITH BETA21;
        BETA12;
        BETA22 WITH BETA12;
        BETA22;"
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
