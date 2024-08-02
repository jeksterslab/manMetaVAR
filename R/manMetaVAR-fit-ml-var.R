#' Fit the Model using the mlVAR Package
#'
#' The function fits the model using the [mlVAR] package.
#'
#' @inheritParams Template
#'
#' @examples
#' \dontrun{
#' set.seed(42)
#' data <- GenData(n = 50, time = 100, theta = 0.2)
#' FitMLVAR(data)
#' }
#' @family Model Fitting Functions
#' @keywords manMetaVAR fit
#' @import OpenMx
#' @import fitDTVARMx
#' @export
FitMLVAR <- function(data) {
  return(
    mlVAR::mlVAR(
      data = as.data.frame(data),
      vars = paste0("y", seq_len(model$k)),
      idvar = "id",
      lags = 1,
      estimator = "lmer",
      verbose = FALSE,
      nCores = 1
    )
  )
}
