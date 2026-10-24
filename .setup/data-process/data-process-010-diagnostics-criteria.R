data_process_diag_criteria <- function(overwrite = FALSE) {
  cat("\ndata_process_diag_criteria\n")
  root <- rprojroot::is_rstudio_project
  data_folder <- root$find_file("data")
  criteria_file <- file.path(
    data_folder,
    "diagnostics_criteria.rda"
  )
  if (file.exists(criteria_file) && !overwrite) {
    return(invisible(criteria_file))
  }
  diagnostics <- manMetaVAR::LoadMplusDiagnostics()
  criteria <- list(
    strict = c(rhat = 1.01, ess = 400, mcse = 0.05),
    moderate = c(rhat = 1.05, ess = 100, mcse = 0.10),
    lenient = c(rhat = 1.10, ess = 100, mcse = Inf)
  )
  diagnostics_criteria <- do.call(
    what = "rbind",
    args = lapply(
      X = names(criteria),
      FUN = function(criterion) {
        threshold <- criteria[[criterion]]
        out <- manMetaVAR::TabMplusDiagSensitivity(
          diagnostics = diagnostics,
          comparison = "levels",
          unit = "replication",
          rhat_threshold = unname(threshold["rhat"]),
          ess_threshold = unname(threshold["ess"]),
          mcse_threshold = unname(threshold["mcse"]),
          output = "data.frame",
          scale = "proportion",
          digits = 6L
        )
        out$criterion <- criterion
        out$rhat_threshold <- unname(threshold["rhat"])
        out$ess_threshold <- unname(threshold["ess"])
        out$mcse_threshold <- unname(threshold["mcse"])
        out
      }
    )
  )
  rownames(diagnostics_criteria) <- NULL
  save(
    diagnostics_criteria,
    file = criteria_file,
    compress = "xz"
  )
  invisible(criteria_file)
}
data_process_diag_criteria()
rm(data_process_diag_criteria)
