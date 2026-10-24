data_process_lrt <- function(overwrite = FALSE,
                             replications = 1000L) {
  cat("\ndata_process_lrt\n")
  root <- rprojroot::is_rstudio_project
  data_folder <- root$find_file("data")
  data_external_folder <- root$find_file(
    ".setup",
    "data-external"
  )
  lrt_file <- file.path(
    data_folder,
    "lrt.rda"
  )
  if (file.exists(lrt_file) && !overwrite) {
    return(invisible(lrt_file))
  }
  summary_files <- list.files(
    path = data_external_folder,
    pattern = paste0(
      "^manMetaVAR-summary-fit-meta-var-mx-lrt-[0-9]{5}-",
      sprintf("%05d", replications),
      "\\.Rds$"
    ),
    full.names = TRUE
  )
  if (length(summary_files) == 0L) {
    message("No LRT summaries in .setup/data-external; `lrt` not written.")
    return(invisible(NULL))
  }
  lrt <- do.call(
    what = "rbind",
    args = lapply(
      X = summary_files,
      FUN = function(i) {
        readRDS(i)$means
      }
    )
  )
  lrt <- lrt[order(lrt$taskid), , drop = FALSE]
  rownames(lrt) <- NULL
  save(
    lrt,
    file = lrt_file,
    compress = "xz"
  )
  invisible(lrt_file)
}
data_process_lrt()
rm(data_process_lrt)
