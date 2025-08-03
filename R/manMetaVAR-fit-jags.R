#' Fit the Model using JAGS
#'
#' The function fits the model using JAGS.
#'
#' @inheritParams Template
#' @inheritParams rjags::jags.model
#' @inheritParams rjags::coda.samples
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
                    n.chains = 4,
                    n.adapt = 2000,
                    n.iter = 10000) {
  df <- data$data
  df <- df[order(df$id, df$time), ]
  ids <- unique(df$id)
  times <- unique(df$time)
  N <- length(ids)
  T <- length(times)
  K <- 2
  y_array <- array(NA, dim = c(N, T, K))
  for (i in seq_len(N)) {
    rows <- which(df$id == ids[i])
    y_array[i, , 1] <- df$y1[rows]
    y_array[i, , 2] <- df$y2[rows]
  }
  data_for_jags <- list(
    N = N,
    T = T,
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
  if (interactive()) {
    progress.bar <- "text"
    quiet <- FALSE
  } else {
    progress.bar <- "none"
    quiet <- TRUE
  }
  model <- rjags::jags.model(
    file = model_file,
    data = data_for_jags,
    n.chains = n.chains,
    n.adapt = n.adapt,
    quiet = quiet
  )
  update(
    object = model,
    n.iter = n.iter,
    progress.bar = progress.bar
  )
  samples <- rjags::coda.samples(
    model = model,
    variable.names = c(
      "mu_alpha",
      "mu_beta",
      "sigma_alpha",
      "sigma_beta",
      "psi",
      "theta"
    ),
    n.iter = n.iter,
    progress.bar = progress.bar
  )
  out <- list(
    model = model,
    samples = samples
  )
  class(out) <- c(
    "fitjags",
    class(out)
  )
  out
}
