#' Create Mplus Input File for the Four-Variable Model
#'
#' The function creates an Mplus input file for the four-variable feasibility
#' model. The between-person random-effects covariance matrix is diagonal,
#' consistent with `modelk4`.
#'
#' @inheritParams Template
#'
#' @examples
#' cat(
#'   MplusInputK4(
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
MplusInputK4 <- function(fn_data,
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
      stop(
        "'ncores' should be greater than 0.",
        call. = FALSE
      )
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
  k <- 4L
  y_names <- paste0(
    "Y",
    seq_len(k)
  )
  # Column-major ordering matches vec(beta) in R:
  # BETA11, BETA21, BETA31, BETA41,
  # BETA12, ..., BETA44.
  beta_outcome <- rep(
    seq_len(k),
    times = k
  )
  beta_predictor <- rep(
    seq_len(k),
    each = k
  )
  beta_names <- paste0(
    "BETA",
    beta_outcome,
    beta_predictor
  )
  transition_lines <- paste0(
    "        ",
    beta_names,
    " | Y",
    beta_outcome,
    " ON Y",
    beta_predictor,
    "&1;"
  )
  # Full within-person innovation covariance matrix.
  innovation_lines <- character(0)
  w <- 1L
  for (i in seq_len(k)) {
    if (i > 1L) {
      for (j in seq_len(i - 1L)) {
        innovation_lines <- c(
          innovation_lines,
          paste0(
            "        Y",
            i,
            " WITH Y",
            j,
            " (W",
            w,
            ");"
          )
        )

        w <- w + 1L
      }
    }
    innovation_lines <- c(
      innovation_lines,
      paste0(
        "        Y",
        i,
        " (W",
        w,
        ");"
      )
    )
    w <- w + 1L
  }
  set_point_mean_lines <- paste0(
    "        [",
    y_names,
    "] (FM",
    seq_len(k),
    ");"
  )
  set_point_variance_lines <- paste0(
    "        ",
    y_names,
    " (M",
    seq_len(k),
    ");"
  )
  # Fix all covariances among the set points to zero.
  set_point_zero_cov_lines <- character(0)
  for (i in seq.int(2L, k)) {
    for (j in seq_len(i - 1L)) {
      set_point_zero_cov_lines <- c(
        set_point_zero_cov_lines,
        paste0(
          "        Y",
          i,
          " WITH Y",
          j,
          "@0;"
        )
      )
    }
  }
  beta_mean_lines <- paste0(
    "        [",
    beta_names,
    "] (FB",
    seq_along(beta_names),
    ");"
  )
  beta_variance_lines <- paste0(
    "        ",
    beta_names,
    " (B",
    seq_along(beta_names),
    ");"
  )
  # Fix all covariances among the transition coefficients to zero.
  beta_zero_covariance_lines <- character(0)
  for (i in seq.int(2L, length(beta_names))) {
    for (j in seq_len(i - 1L)) {
      beta_zero_covariance_lines <- c(
        beta_zero_covariance_lines,
        paste0(
          "        ",
          beta_names[i],
          " WITH ",
          beta_names[j],
          "@0;"
        )
      )
    }
  }
  # Fix all covariances between set points and transition coefficients
  # to zero.
  cross_zero_covariance_lines <- unlist(
    lapply(
      X = beta_names,
      FUN = function(beta_name) {
        paste0(
          "        ",
          beta_name,
          " WITH ",
          y_names,
          "@0;"
        )
      }
    ),
    use.names = FALSE
  )
  out <- paste0(
    "
    TITLE:
      Four-Variable Multilevel Vector Autoregressive Model
    DATA:
    FILE = __DATA__;
    VARIABLE:
      NAMES = ID TIME Y1 Y2 Y3 Y4;
      USEVARIABLES = Y1 Y2 Y3 Y4;
      MISSING = ALL (-999);
      CLUSTER = ID;
      LAGGED = Y1(1) Y2(1) Y3(1) Y4(1);
    ANALYSIS:
      TYPE = TWOLEVEL RANDOM;
      ESTIMATOR = BAYES;
      CHAINS = __CHAINS__;
      FBITER = (__FBITER__);
      PROCESSORS = __PROCESSORS__;
      BSEED = __BSEED__;
    MODEL:
      %WITHIN%
      ! transition matrix\n",
    paste(
      transition_lines,
      collapse = "\n"
    ),
    "

      ! within-person innovation covariance\n",
    paste(
      innovation_lines,
      collapse = "\n"
    ),
    "

      %BETWEEN%
      ! population means of person-specific set points\n",
    paste(
      set_point_mean_lines,
      collapse = "\n"
    ),
    "

      ! between-person variances of set points\n",
    paste(
      set_point_variance_lines,
      collapse = "\n"
    ),
    "

      ! set-point covariances fixed to zero\n",
    paste(
      set_point_zero_cov_lines,
      collapse = "\n"
    ),
    "

      ! population-average transition coefficients\n",
    paste(
      beta_mean_lines,
      collapse = "\n"
    ),
    "

      ! between-person variances of transition coefficients\n",
    paste(
      beta_variance_lines,
      collapse = "\n"
    ),
    "

      ! transition-coefficient covariances fixed to zero\n",
    paste(
      beta_zero_covariance_lines,
      collapse = "\n"
    ),
    "

      ! set-point--transition covariances fixed to zero\n",
    paste(
      cross_zero_covariance_lines,
      collapse = "\n"
    )
  )
  if (!default_priors) {
    priors <- "
    MODEL PRIORS:
      ! relatively weakly informative, scale-aware fixed-effect priors
      FM1-FM4 ~ N(0, 25);
      FB1-FB16 ~ N(0, 0.25);

      ! proper inverse-Wishart prior for the full 4 x 4
      ! within-person innovation covariance matrix.
      ! The 10 lower-triangular scale-matrix elements are specified
      ! individually to define IW(I_4, 5).
      W1  ~ IW(1, 5);
      W2  ~ IW(0, 5);
      W3  ~ IW(1, 5);
      W4  ~ IW(0, 5);
      W5  ~ IW(0, 5);
      W6  ~ IW(1, 5);
      W7  ~ IW(0, 5);
      W8  ~ IW(0, 5);
      W9  ~ IW(0, 5);
      W10 ~ IW(1, 5);

      ! independent inverse-gamma priors for set-point heterogeneity
      M1-M4 ~ IG(2, 0.025);

      ! independent inverse-gamma priors for transition heterogeneity
      B1-B16 ~ IG(2, 0.025);"
    out <- paste0(
      out,
      "\n",
      priors
    )
  }
  if (plot) {
    out <- paste0(
      out,
      "
    PLOT:
      TYPE = PLOT3;"
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
