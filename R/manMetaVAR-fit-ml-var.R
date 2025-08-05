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
FitMLVAR <- function(data,
                     ncores = NULL) {
  start_time <- Sys.time()
  if (is.null(ncores)) {
    ncores <- 1
  }
  output <- mlVAR::mlVAR(
    data = data$data,
    vars = paste0("y", seq_len(model$k)),
    idvar = "id",
    lags = 1,
    estimator = "lmer",
    verbose = FALSE,
    nCores = ncores
  )
  end_time <- Sys.time()
  structure(
    list(
      output = output,
      start_time = start_time,
      end_time = end_time
    ),
    class = "manmetavar_fitmlvar"
  )
}
