#' Fit the Four-Variable Model using Mplus
#'
#' The function fits the four-variable feasibility model using Mplus.
#'
#' @inheritParams Template
#'
#' @examples
#' \dontrun{
#' seed <- 42
#' data <- GenDataK4(taskid = 1, seed = seed)
#' dsem <- FitMplusK4(data = data)
#' print(dsem)
#' summary(dsem)
#' coef(dsem)
#' vcov(dsem)
#' confint(dsem)
#' plot(dsem)
#' plot(dsem, what = "trace")
#' }
#'
#' @family Model Fitting Functions
#' @keywords manMetaVAR fit
#' @export
FitMplusK4 <- function(data,
                       chains = 2L,
                       iter = 40000L,
                       fscores = NULL,
                       plot = FALSE,
                       default_priors = TRUE,
                       wd = ".",
                       mplus_bin = NULL,
                       ncores = NULL,
                       seed = NULL) {
  start_time <- Sys.time()
  args <- list(
    chains = chains,
    iter = iter,
    fscores = fscores,
    plot = plot,
    default_priors = default_priors,
    wd = wd,
    mplus_bin = mplus_bin,
    ncores = ncores,
    seed = seed
  )
  model <- "mplusk4"
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
  prefix <- .RandomFile(
    prefix = model
  )
  fn_data <- paste0(
    prefix,
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
  fn_posterior <- paste0(
    prefix,
    "_",
    "posterior.dat"
  )
  fn_factorscores <- paste0(
    prefix,
    "_",
    "factorscores.dat"
  )
  fn_gh5 <- paste0(
    prefix,
    ".gh5"
  )
  utils::write.table(
    x = data$data,
    file = fn_data,
    row.names = FALSE,
    col.names = FALSE,
    na = "-999"
  )
  writeLines(
    text = MplusInputK4(
      fn_data = fn_data,
      fn_posterior = fn_posterior,
      fn_factorscores = fn_factorscores,
      chains = chains,
      iter = iter,
      fscores = fscores,
      plot = plot,
      default_priors = default_priors,
      ncores = ncores,
      seed = seed
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
      "Fitting the four-variable model...\n"
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
  if (plot) {
    gh5 <- readBin(
      con = fn_gh5,
      what = "raw",
      n = file.info(fn_gh5)$size
    )
  } else {
    gh5 <- NA
  }
  if (is.null(fscores)) {
    factorscores <- NA
  } else {
    factorscores <- .ReadLines(
      con = fn_factorscores
    )
  }
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
    posterior = .ReadLines(
      con = fn_posterior
    ),
    factorscores = factorscores,
    gh5 = gh5
  )
  end_time <- Sys.time()
  elapsed <- end_time - start_time
  out <- list(
    args = args,
    output = output,
    elapsed = elapsed,
    burnin = as.integer(iter %/% 2L)
  )
  class(out) <- c(
    "manmetavar.mplus.k4",
    class(out)
  )
  out
}
