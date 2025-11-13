data_process_results <- function(overwrite = FALSE) {
  cat("\ndata_process_results\n")
  set.seed(42)
  # find root directory
  root <- rprojroot::is_rstudio_project
  data_folder <- root$find_file(
    "data"
  )
  if (!dir.exists(data_folder)) {
    dir.create(
      data_folder,
      recursive = TRUE
    )
  }
  data_raw_folder <- root$find_file(
    ".setup",
    "data-raw"
  )
  if (!dir.exists(data_raw_folder)) {
    dir.create(
      data_raw_folder,
      recursive = TRUE
    )
  }
  results_file <- file.path(
    data_folder,
    "results.rda"
  )
  if (!file.exists(results_file)) {
    write <- TRUE
  } else {
    if (overwrite) {
      write <- TRUE
    } else {
      write <- FALSE
    }
  }
  if (write) {
    results <- do.call(
      what = "rbind",
      args = lapply(
        X = list.files(
          path = data_raw_folder,
          pattern = "^manMetaVAR-summary-.*",
          full.names = TRUE
        ),
        FUN = function(i) {
          readRDS(i)$means
        }
      )
    )
    idx <- c(
      "alpha[1,1]",
      "alpha[2,1]",
      "alpha[3,1]",
      "alpha[4,1]",
      "alpha[5,1]",
      "alpha[6,1]",
      "tau_sqr[1,1]",
      "tau_sqr[2,1]",
      "tau_sqr[3,1]",
      "tau_sqr[4,1]",
      "tau_sqr[5,1]",
      "tau_sqr[6,1]",
      "tau_sqr[2,2]",
      "tau_sqr[3,2]",
      "tau_sqr[4,2]",
      "tau_sqr[5,2]",
      "tau_sqr[6,2]",
      "tau_sqr[3,3]",
      "tau_sqr[4,3]",
      "tau_sqr[5,3]",
      "tau_sqr[6,3]",
      "tau_sqr[4,4]",
      "tau_sqr[5,4]",
      "tau_sqr[6,4]",
      "tau_sqr[5,5]",
      "tau_sqr[6,5]",
      "tau_sqr[6,6]"
    )
    results$par_idx <- results$parnames
    for (i in seq_along(idx)) {
      results$par_idx <- ifelse(
        test = results$par_idx == idx[i],
        yes = i,
        no = results$par_idx
      )
    }
    results$par_idx <- as.integer(results$par_idx)
    # replace relative bias with absolute bias for parameter == 0
    results$rel_bias <- ifelse(
      test = results$rel_bias < -999,
      yes = results$bias,
      no = results$rel_bias
    )
    save(
      results,
      file = results_file,
      compress = "xz"
    )
  }
}
data_process_results()
rm(data_process_results)
