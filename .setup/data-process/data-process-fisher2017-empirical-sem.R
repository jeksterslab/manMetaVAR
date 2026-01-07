data_process_fisher2017_empirical_sem <- function(overwrite = FALSE) {
  cat("\ndata_process_fisher2017_empirical_sem\n")
  set.seed(42)
  # find root directory
  root <- rprojroot::is_rstudio_project
  output <- root$find_file(
    ".setup",
    "data-raw",
    "fisher2017-empirical-sem.Rds"
  )
  source(
    root$find_file(
      ".setup",
      "data-process",
      "data-process-fisher2017-empirical-dynamics.R"
    )
  )
  if (!file.exists(output)) {
    write <- TRUE
  } else {
    if (overwrite) {
      write <- TRUE
    } else {
      write <- FALSE
    }
  }
  if (write) {
    library(OpenMx)
    library(fitDTVARMxID)
    library(metaVAR)
    fit <- readRDS(
      root$find_file(
        ".setup",
        "data-raw",
        "fisher2017-empirical-dynamics.Rds"
      )
    )
    between <- readRDS(
      root$find_file(
        ".setup",
        "data-raw",
        "fisher2017-between.Rds"
      )
    )
    n <- dim(between)[1]
    data_covariate <- lapply(
      X = seq_len(n),
      FUN = function(i) {
        between[i, "diagnosis"]
      }
    )
    data_distal <- lapply(
      X = seq_len(n),
      FUN = function(i) {
        between[i, c("dep", "anx")]
      }
    )
    meta <- MetaVARMx(
      fit,
      x = data_covariate,
      z = data_distal,
      int_meas = TRUE,
      tau_sqr_diag = TRUE,
      tries_explore = 1000,
      tries_local = 1000,
      max_attempts = 100
    )
    summary(meta)
    saveRDS(
      object = meta,
      file = output
    )
  }
}
data_process_fisher2017_empirical_sem()
rm(data_process_fisher2017_empirical_sem)
