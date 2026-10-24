data_analysis_adid2010_lrt <- function(overwrite = FALSE) {
  # Boundary LRT for the empirical example. The Stage 2 covariance matrix
  # is unstructured (9 x 9), so the null hypothesis also sets the
  # covariances between the transition parameters (positions 3 to 6) and
  # the set points and innovation parameters (1, 2, 7, 8, 9) to zero.
  root <- rprojroot::is_rstudio_project
  data_private <- root$find_file(
    ".setup",
    "data-private"
  )
  output <- file.path(
    data_private,
    "adid2010-lrt.Rds"
  )
  if (file.exists(output) && !overwrite) {
    return(invisible(output))
  }
  # The fit is private: skip where it is missing (the public repo).
  if (
    !file.exists(
      file.path(
        data_private,
        "adid2010-stage-2-random.Rds"
      )
    )
  ) {
    return(invisible(NULL))
  }
  # The stored model's algebra calls OpenMx functions (mxRobustLog), which
  # are found only when OpenMx is attached.
  library(OpenMx)
  fit <- readRDS(
    file.path(
      data_private,
      "adid2010-stage-2-random.Rds"
    )
  )
  lrt <- manMetaVAR::LRTMetaVAR(
    fit = fit,
    block = 3:6,
    others = c(1, 2, 7, 8, 9),
    cross = TRUE,
    draws = 20000L,
    seed = 42
  )
  saveRDS(
    object = lrt,
    file = output,
    compress = "xz"
  )
  invisible(output)
}
data_analysis_adid2010_lrt()
rm(data_analysis_adid2010_lrt)
