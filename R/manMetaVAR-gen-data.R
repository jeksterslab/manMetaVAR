#' Simulate Data
#'
#' The function simulates data using
#' the [simStateSpace::SimSSMIVary()] function.
#'
#' @inheritParams Template
#'
#' @examples
#' \dontrun{
#' set.seed(42)
#' data <- GenData(n = 50, time = 100, theta = 0.2)
#' plot(data)
#' }
#' @family Data Generation Functions
#' @keywords manMetaVAR gendata
#' @import simStateSpace
#' @export
GenData <- function(n,
                    time,
                    theta) {
  return(
    simStateSpace::SimSSMIVary(
      n = n,
      time = time,
      mu0 = list(model$mu0),
      sigma0_l = list(model$sigma0_l),
      alpha = list(model$alpha),
      beta = simStateSpace::SimBetaN(
        n = n,
        beta = model$beta_mu,
        vcov_beta_vec_l = model$beta_sigma_l
      ),
      psi_l = list(model$psi_l),
      nu = list(model$nu),
      lambda = list(model$lambda),
      theta_l = list(t(chol(theta * diag(2)))),
      type = 0,
      x = NULL,
      gamma = NULL,
      kappa = NULL
    )
  )
}
