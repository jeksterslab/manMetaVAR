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
#' meta <- FitNaive(fit = fit, seed = seed)
#' summary(meta)
#' print(meta)
#' coef(meta)
#' vcov(meta)
#' }
#'
#' @family Model Fitting Functions
#' @keywords manMetaVAR meta
#' @import metaDyn
#' @export
FitNaive <- function(fit) {
  start_time <- Sys.time()
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
  model <- "
    mu11 ~ 1
    mu21 ~ 1
    beta11 ~ 1
    beta21 ~ 1
    beta12 ~ 1
    beta22 ~ 1
    mu11 ~~ mu11
    mu21 ~~ mu11
    beta11 ~~ 0 * mu11
    beta21 ~~ 0 * mu11
    beta12 ~~ 0 * mu11
    beta22 ~~ 0 * mu11
    mu21 ~~ mu21
    beta11 ~~ 0 * mu21
    beta21 ~~ 0 * mu21
    beta12 ~~ 0 * mu21
    beta22 ~~ 0 * mu21
    beta11 ~~ beta11
    beta21 ~~ beta11
    beta12 ~~ beta11
    beta22 ~~ beta11
    beta21 ~~ beta21
    beta12 ~~ beta21
    beta22 ~~ beta21
    beta12 ~~ beta12
    beta22 ~~ beta12
    beta22 ~~ beta22
  "
  output <- lavaan::lavaan(
    model = model,
    data = data
  )
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
