#' Fit the Model using the fitDTVARMx Package
#'
#' The function fits the model using the [fitDTVARMx] package.
#'
#' @inheritParams Template
#'
#' @examples
#' \dontrun{
#' set.seed(42)
#' data <- GenData(n = 50, time = 100, theta = 0.2)
#' FitDTVARMx(data)
#' }
#' @family Model Fitting Functions
#' @keywords manMetaVAR fit
#' @import OpenMx
#' @import fitDTVARMx
#' @export
FitDTVARMx <- function(data) {
  return(
    fitDTVARMx::FitDTVARIDMx(
      data = as.data.frame(data),
      observed = paste0("y", seq_len(model$k)),
      id = "id",
      alpha_fixed = TRUE,
      beta_start = model$beta_mu,
      beta_lbound = model$beta_lbound,
      beta_ubound = model$beta_ubound,
      psi_start = model$psi,
      psi_lbound = model$psi_lbound,
      psi_ubound = model$psi_ubound,
      psi_diag = FALSE,
      theta = TRUE,
      theta_start = model$theta,
      theta_lbound = model$theta_lbound,
      theta_ubound = model$theta_ubound,
      try = 10000,
      ncores = NULL
    )
  )
}
