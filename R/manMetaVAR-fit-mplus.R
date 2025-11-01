#' Fit the Model using Mplus
#'
#' The function fits the model using Mplus.
#'
#' @inheritParams Template
#'
#' @examples
#' \dontrun{
#' set.seed(42)
#' data <- GenData(taskid = 1)
#' fit <- FitMplus(data = data)
#' print(fit)
#' summary(fit)
#' }
#'
#' @family Model Fitting Functions
#' @keywords manMetaVAR fit
#' @export
FitMplus <- function(data,
                     wd = ".",
                     mplus_bin = NULL,
                     ncores = NULL,
                     default_priors = FALSE) {
  start_time <- Sys.time()
  dynamics <- data$dynamics
  model <- "mplus"
  old_wd <- getwd()
  on.exit(
    setwd(old_wd)
  )
  new_wd <- .CreateFolder(
    x = normalizePath(
      path = wd,
      mustWork = FALSE
    ),
    prefix = model
  )
  on.exit(
    unlink(
      x = new_wd,
      recursive = TRUE
    ),
    add = TRUE
  )
  setwd(new_wd)
  prefix <- .RandomFile(prefix = model)
  fn_data <- paste0(
    model,
    "_",
    "data.dat"
  )
  fn_inp <- paste0(
    prefix,
    ".inp"
  )
  fn_out <- paste0(
    prefix,
    ".out"
  )
  fn_estimates <- paste0(
    prefix,
    "_",
    "estimates.dat"
  )
  fn_results <- paste0(
    prefix,
    "_",
    "results.dat"
  )
  fn_posterior <- paste0(
    prefix,
    "_",
    "posterior.dat"
  )
  utils::write.table(
    x = data$data,
    file = fn_data,
    row.names = FALSE,
    col.names = FALSE
  )
  writeLines(
    text = MplusInput(
      dynamics = dynamics,
      fn_data = fn_data,
      fn_estimates = fn_estimates,
      fn_results = fn_results,
      fn_posterior = fn_posterior,
      ncores = ncores,
      plot = FALSE,
      default_priors = default_priors
    ),
    con = fn_inp
  )
  if (is.null(mplus_bin)) {
    mplus_bin <- .WhichMplus()
  }
  if (.Platform$OS.type == "windows") {
    nullfile <- "NUL"
  } else {
    nullfile <- "/dev/null"
  }
  if (interactive()) {
    message(
      "Fitting the model...\n"
    )
  }
  system2(
    mplus_bin,
    args = c(
      fn_inp,
      fn_out
    ),
    stdout = nullfile,
    stderr = nullfile
  )
  output <- list(
    data = .ReadLines(
      con = fn_data
    ),
    input = .ReadLines(
      con = fn_inp
    ),
    output = .ReadLines(
      con = fn_out
    ),
    estimates = .ReadLines(
      con = fn_estimates
    ),
    results = .ReadLines(
      con = fn_results
    ),
    posterior = .ReadLines(
      con = fn_posterior
    )
  )
  end_time <- Sys.time()
  elapsed <- end_time - start_time
  structure(
    list(
      data = data,
      output = output,
      elapsed = elapsed
    ),
    class = "manmetavar.mplus"
  )
}
