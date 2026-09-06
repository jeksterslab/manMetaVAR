#' Naive Estimation for the Four-Variable Model
#'
#' The function performs the naive ``fit-many-then-summarize'' procedure for
#' the four-variable feasibility model. The random-effects covariance matrix is
#' diagonal, consistent with `modelk4`.
#'
#' @inheritParams Template
#'
#' @examples
#' \dontrun{
#' seed <- 42
#' data <- GenDataK4(taskid = 1, seed = seed)
#' fit <- FitDTVARK4(data = data, seed = seed)
#' naive <- FitNaiveK4(fit = fit, seed = seed)
#' summary(naive)
#' print(naive)
#' coef(naive)
#' vcov(naive)
#' }
#'
#' @family Model Fitting Functions
#' @keywords manMetaVAR meta
#' @import OpenMx
#' @export
FitNaiveK4 <- function(fit,
                       seed = NULL) {
  start_time <- Sys.time()

  if (!is.null(seed)) {
    set.seed(seed)
  }

  k <- modelk4$k
  q <- k * k
  p <- k + q

  mu_names <- paste0(
    "mu",
    seq_len(k),
    "1"
  )

  # Column-major ordering consistent with c(beta):
  # beta11, beta21, beta31, beta41,
  # beta12, ..., beta44.
  beta_names <- paste0(
    "beta",
    rep(seq_len(k), times = k),
    rep(seq_len(k), each = k)
  )

  parameter_names <- c(
    mu_names,
    beta_names
  )

  data <- as.data.frame(
    summary(
      fit,
      means = FALSE
    )[, seq_len(p), drop = FALSE]
  )

  colnames(data) <- parameter_names

  covariances <- stats::var(data)
  n <- nrow(data)
  covariances <- (n - 1) / n * covariances
  means <- colMeans(data)

  # Match modelk4: estimate variances only.
  # All random-effect covariances are fixed to zero.
  covariances_free <- diag(
    x = TRUE,
    nrow = p,
    ncol = p
  )

  covariances[
    !covariances_free
  ] <- 0

  covariances_labels <- matrix(
    data = NA_character_,
    nrow = p,
    ncol = p
  )

  diag(covariances_labels) <- paste0(
    "sigma_",
    seq_len(p),
    "_",
    seq_len(p)
  )

  mu <- OpenMx::mxMatrix(
    type = "Full",
    nrow = 1,
    ncol = p,
    free = matrix(
      data = TRUE,
      nrow = 1,
      ncol = p
    ),
    values = matrix(
      data = means,
      nrow = 1,
      ncol = p
    ),
    labels = matrix(
      data = paste0(
        "mu_",
        seq_len(p)
      ),
      nrow = 1,
      ncol = p
    ),
    lbound = matrix(
      data = NA,
      nrow = 1,
      ncol = p
    ),
    ubound = matrix(
      data = NA,
      nrow = 1,
      ncol = p
    ),
    byrow = FALSE,
    dimnames = list(
      "mu",
      colnames(data)
    ),
    name = "mu"
  )

  covariances_lbound <- matrix(
    data = NA,
    nrow = p,
    ncol = p
  )

  diag(covariances_lbound) <- 0

  sigma <- OpenMx::mxMatrix(
    type = "Symm",
    nrow = p,
    ncol = p,
    free = covariances_free,
    values = covariances,
    labels = covariances_labels,
    lbound = covariances_lbound,
    ubound = matrix(
      data = NA,
      nrow = p,
      ncol = p
    ),
    byrow = FALSE,
    dimnames = list(
      colnames(data),
      colnames(data)
    ),
    name = "sigma"
  )

  output <- OpenMx::mxModel(
    model = "ModelK4",
    mu,
    sigma,
    OpenMx::mxData(
      type = "raw",
      observed = data
    ),
    OpenMx::mxExpectationNormal(
      covariance = "sigma",
      means = "mu",
      dimnames = colnames(data)
    ),
    OpenMx::mxFitFunctionML()
  )

  # The lower bounds of the free diagonal elements of
  # sigma are admissible boundary solutions corresponding
  # to zero estimated between-unit variance.
  sigma_diag_labels <- diag(
    covariances_labels
  )

  sigma_diag_labels <- sigma_diag_labels[
    !is.na(sigma_diag_labels)
  ]

  allowed_bounds <- list(
    lower = sigma_diag_labels,
    upper = character(0)
  )

  output <- metaDyn:::.MxHelperRun(
    model = output,
    grad_tol = 1e-2,
    ok_codes = 0L,
    require_finite_fit = TRUE,
    hess_tol_abs = 1e-8,
    hess_tol_rel = 1e-10,
    check_condition = FALSE,
    cond_max = 1e12,
    silent = TRUE
  )

  if (
    metaDyn:::.MxHelperNeedsRescue(
      model = output,
      grad_tol = 1e-2,
      ok_codes = 0L,
      require_finite_fit = TRUE,
      hess_tol_abs = 1e-8,
      hess_tol_rel = 1e-10,
      check_condition = FALSE,
      cond_max = 1e12,
      abs_bnd_tol = 1e-6,
      rel_bnd_tol = 1e-4,
      allowed_bounds = allowed_bounds
    )
  ) {
    output <- metaDyn:::.MxHelperEnsureGoodHessian(
      model = output,
      tries_explore = 100,
      tries_local = 100,
      max_attempts = 10,
      grad_tol = 1e-2,
      hess_tol_abs = 1e-8,
      hess_tol_rel = 1e-10,
      check_condition = FALSE,
      cond_max = 1e12,
      abs_bnd_tol = 1e-6,
      rel_bnd_tol = 1e-4,
      factor = 10,
      relax_on_last = TRUE,
      relax_exclude = NULL,
      protect_lb_zero = TRUE,
      ok_codes = 0L,
      require_finite_fit = TRUE,
      rerun_code6 = TRUE,
      relax_streak = 3,
      relax_min_attempt = 3,
      silent = TRUE,
      allowed_bounds = allowed_bounds
    )
  }

  end_time <- Sys.time()
  elapsed <- end_time - start_time

  out <- list(
    output = output,
    elapsed = elapsed
  )

  class(out) <- c(
    "manmetavar.naive.k4",
    class(out)
  )

  out
}
