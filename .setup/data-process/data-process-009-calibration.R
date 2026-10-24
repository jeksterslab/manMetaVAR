data_process_calibration <- function(overwrite = FALSE,
                                     replications = 1000L) {
  cat("\ndata_process_calibration\n")
  root <- rprojroot::is_rstudio_project
  data_folder <- root$find_file("data")
  data_external_folder <- root$find_file(
    ".setup",
    "data-external"
  )
  calibration_file <- file.path(
    data_folder,
    "calibration.rda"
  )
  if (file.exists(calibration_file) && !overwrite) {
    return(invisible(calibration_file))
  }
  summary_files <- list.files(
    path = data_external_folder,
    pattern = paste0(
      "^manMetaVAR-summary-stage-1-calibration-[0-9]{5}-",
      sprintf("%05d", replications),
      "\\.Rds$"
    ),
    full.names = TRUE
  )
  if (length(summary_files) == 0L) {
    message(
      "No calibration summaries in .setup/data-external; ",
      "`calibration` not written."
    )
    return(invisible(NULL))
  }
  calibration <- do.call(
    what = "rbind",
    args = lapply(
      X = summary_files,
      FUN = function(i) {
        readRDS(i)$means
      }
    )
  )
  calibration <- calibration[
    order(calibration$taskid, calibration$position), ,
    drop = FALSE
  ]
  rownames(calibration) <- NULL
  save(
    calibration,
    file = calibration_file,
    compress = "xz"
  )
  invisible(calibration_file)
}
data_process_calibration()
rm(data_process_calibration)
