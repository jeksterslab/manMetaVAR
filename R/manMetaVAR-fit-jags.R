#' Fit the Model using JAGS
#'
#' The function fits the model using JAGS.
#'
#' @inheritParams Template
#'
#' @examples
#' \dontrun{
#' set.seed(42)
#' data <- GenData(taskid = 1)
#' fit <- FitJAGS(data = data)
#' summary(fit)
#' }
#' @family Model Fitting Functions
#' @keywords manMetaVAR fit
#' @import rjags
#' @import coda
#' @importFrom stats update
#' @export
FitJAGS <- function(data,
                    n_chains = 4,
                    n_adapt = 1000,
                    n_iter = 10000,
                    thin = 1,
                    ess_crit = 1000,
                    max_iter = 1000,
                    seed = NULL) {
  args <- list(
    data = data,
    n_chains = n_chains,
    n_adapt = n_adapt,
    n_iter = n_iter,
    max_iter = max_iter,
    seed = seed
  )
  df <- data$data
  df <- df[order(df$id, df$time), ]
  ids <- unique(df$id)
  times <- unique(df$time)
  N <- length(ids)
  M <- length(times)
  K <- 2
  y_array <- array(NA, dim = c(N, M, K))
  for (i in seq_len(N)) {
    rows <- which(df$id == ids[i])
    y_array[i, , 1] <- df$y1[rows]
    y_array[i, , 2] <- df$y2[rows]
  }
  data_for_jags <- list(
    N = N,
    M = M,
    K = K,
    y = y_array,
    mu0 = model$mu0,
    tau_sigma0 = model$tau_sigma0,
    r_alpha = diag(K),
    r_beta = diag(K * K),
    r_psi = diag(K),
    r_theta = diag(K)
  )
  model_file <- system.file(
    "models",
    "rjags_model.bug",
    package = "manMetaVAR"
  )
  if (!is.null(seed)) {
    set.seed(seed)
  }
  inits <- lapply(
    X = seq_len(n_chains),
    FUN = function(i) {
      list(
        beta_mu = model$beta_mu,
        alpha_mu = model$alpha_mu,
        beta_sigma = model$beta_sigma,
        alpha_sigma = model$alpha_sigma,
        psi = model$psi,
        theta = model$theta,
        .RNG.name = "base::Mersenne-Twister",
        .RNG.seed = sample.int(
          n = .Machine$integer.max,
          size = 1
        )
      )
    }
  )
  model <- rjags::jags.model(
    file = model_file,
    data = data_for_jags,
    n.chains = n_chains,
    n.adapt = n_adapt,
    quiet = TRUE
  )
  # repeat until ESS >= ess_crit for all parameters
  ess <- 0
  samples <- NULL
  iter <- 0
  while (
    any(ess < ess_crit) && iter < max_iter
  ) {
    update(
      object = model,
      n.iter = n_iter
    )
    samples <- rjags::coda.samples(
      model = model,
      variable.names = c(
        "beta_mu",
        "alpha_mu",
        "beta_sigma",
        "alpha_sigma",
        "psi",
        "theta"
      ),
      n.iter = n_iter,
      thin = thin
    )
    ess <- coda::effectiveSize(
      x = samples
    )
    iter <- iter + 1
  }
  out <- list(
    args = args,
    inits = inits,
    model = model,
    samples = samples,
    iter = iter,
    ess = ess
  )
  class(out) <- c(
    "fitjags",
    class(out)
  )
  out
}
