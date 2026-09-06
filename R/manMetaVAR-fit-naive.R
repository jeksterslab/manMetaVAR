#' Naive
#'
#' The function performs the naive ``fit-many-then-summarize''.
#'
#' @inheritParams Template
#'
#' @examples
#' \dontrun{
#' seed <- 42
#' data <- GenData(taskid = 1, seed = seed)
#' fit <- FitDTVAR(data = data, seed = seed)
#' naive <- FitNaive(fit = fit, seed = seed)
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
FitNaive <- function(fit,
                     seed = NULL) {
  start_time <- Sys.time()

  if (!is.null(seed)) {
    set.seed(seed)
  }

  data <- as.data.frame(
    summary(
      fit,
      means = FALSE
    )[, 1:6]
  )

  colnames(data) <- c(
    "mu11",
    "mu21",
    "beta11",
    "beta21",
    "beta12",
    "beta22"
  )

  covariances <- stats::var(data)
  n <- nrow(data)
  covariances <- (n - 1) / n * covariances
  means <- colMeans(data)

  covariances_free <- matrix(
    data = c(
      TRUE, TRUE, FALSE, FALSE, FALSE, FALSE,
      TRUE, TRUE, FALSE, FALSE, FALSE, FALSE,
      FALSE, FALSE, TRUE, TRUE, TRUE, TRUE,
      FALSE, FALSE, TRUE, TRUE, TRUE, TRUE,
      FALSE, FALSE, TRUE, TRUE, TRUE, TRUE,
      FALSE, FALSE, TRUE, TRUE, TRUE, TRUE
    ),
    byrow = TRUE,
    nrow = 6,
    ncol = 6
  )

  covariances[!covariances_free] <- 0

  covariances_labels <- matrix(
    data = NA,
    nrow = 6,
    ncol = 6
  )

  for (j in 1:6) {
    for (i in 1:6) {
      covariances_labels[j, i] <-
        covariances_labels[i, j] <- paste0(
          "sigma_",
          i,
          "_",
          j
        )
    }
  }

  covariances_labels[!covariances_free] <- NA

  mu <- OpenMx::mxMatrix(
    type = "Full",
    nrow = 1,
    ncol = 6,
    free = matrix(
      data = TRUE,
      nrow = 1,
      ncol = 6
    ),
    values = matrix(
      data = means,
      nrow = 1,
      ncol = 6
    ),
    labels = matrix(
      data = paste0(
        "mu_",
        1:6
      ),
      nrow = 1,
      ncol = 6
    ),
    lbound = matrix(
      data = NA,
      nrow = 1,
      ncol = 6
    ),
    ubound = matrix(
      data = NA,
      nrow = 1,
      ncol = 6
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
    nrow = 6,
    ncol = 6
  )

  diag(covariances_lbound) <- 0

  sigma <- OpenMx::mxMatrix(
    type = "Symm",
    nrow = 6,
    ncol = 6,
    free = covariances_free,
    values = covariances,
    labels = covariances_labels,
    lbound = covariances_lbound,
    ubound = matrix(
      data = NA,
      nrow = 6,
      ncol = 6
    ),
    byrow = FALSE,
    dimnames = list(
      colnames(data),
      colnames(data)
    ),
    name = "sigma"
  )

  output <- OpenMx::mxModel(
    model = "Model",
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
  # to zero estimated variance.
  free_parameters <- OpenMx::omxGetParameters(
    output
  )

  sigma_diag_labels <- grep(
    pattern = "^sigma_[0-9]+_[0-9]+$",
    x = names(free_parameters),
    value = TRUE
  )

  sigma_diag_labels <- sigma_diag_labels[
    vapply(
      strsplit(
        sub(
          pattern = "^sigma_",
          replacement = "",
          x = sigma_diag_labels
        ),
        split = "_",
        fixed = TRUE
      ),
      FUN = function(x) {
        identical(
          x[[1L]],
          x[[2L]]
        )
      },
      FUN.VALUE = logical(1)
    )
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
    "manmetavar.naive",
    class(out)
  )

  out
}