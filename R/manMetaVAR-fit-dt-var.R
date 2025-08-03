#' Fit the Model using the fitDTVARMx Package
#'
#' The function fits the model using the [fitDTVARMx] package.
#'
#' @inheritParams Template
#'
#' @examples
#' \dontrun{
#' set.seed(42)
#' data <- GenData(taskid = 1)
#' fit <- FitDTVAR(
#'   data = data,
#'   ncores = parallel::detectCores()
#' )
#' summary(fit)
#' }
#' @family Model Fitting Functions
#' @keywords manMetaVAR fit
#' @import OpenMx
#' @import fitDTVARMx
#' @export
FitDTVAR <- function(data,
                     ncores = NULL) {
  fitDTVARMx::FitDTVARIDMx(
    data = data$data,
    observed = paste0("y", seq_len(model$k)),
    id = "id",
    alpha_fixed = FALSE,
    alpha_values = model$alpha_mu,
    beta_values = model$beta_mu,
    psi_diag = FALSE,
    psi_values = model$psi,
    theta_fixed = FALSE,
    theta_values = model$theta,
    mu0_fixed = TRUE,
    mu0_values = model$mu0,
    sigma0_fixed = TRUE,
    sigma0_diag = FALSE,
    sigma0_values = model$sigma0,
    try = 10000,
    ncores = ncores
  )
}
