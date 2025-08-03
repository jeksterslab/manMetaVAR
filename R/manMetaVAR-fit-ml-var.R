#' Fit the Model using the mlVAR Package
#'
#' The function fits the model using the [mlVAR] package.
#'
#' @inheritParams Template
#'
#' @examples
#' \dontrun{
#' set.seed(42)
#' data <- GenData(taskid = 1)
#' fit <- FitMLVAR(data = data)
#' summary(fit)
#' }
#' @family Model Fitting Functions
#' @keywords manMetaVAR fit
#' @import OpenMx
#' @import fitDTVARMx
#' @export
FitMLVAR <- function(data) {
  mlVAR::mlVAR(
    data = data$data,
    vars = paste0("y", seq_len(model$k)),
    idvar = "id",
    lags = 1,
    estimator = "lmer",
    verbose = FALSE,
    nCores = 1
  )
}
