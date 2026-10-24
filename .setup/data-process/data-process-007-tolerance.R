data_process_tolerance <- function(overwrite = FALSE,
                                   replications = 1000L) {
  cat("\ndata_process_tolerance\n")
  root <- rprojroot::is_rstudio_project
  data_folder <- root$find_file("data")
  data_external_folder <- root$find_file(
    ".setup",
    "data-external"
  )
  rates_file <- file.path(
    data_folder,
    "tolerance_rates.rda"
  )
  if (file.exists(rates_file) && !overwrite) {
    return(invisible(rates_file))
  }
  # `make data` runs before `make install`, so load the tolerance functions
  # from the project sources rather than from the installed package.
  tolerance_env <- new.env(
    parent = asNamespace("manMetaVAR")
  )
  for (i in c("manMetaVAR-tolerance.R", "manMetaVAR-sum-tolerance.R")) {
    sys.source(
      file = root$find_file("R", i),
      envir = tolerance_env
    )
  }
  params <- manMetaVAR::params
  tolerance_rates <- do.call(
    what = "rbind",
    args = lapply(
      X = params$taskid,
      FUN = function(taskid) {
        tolerance_env$SumTolerance(
          taskid = taskid,
          reps = replications,
          folder = data_external_folder
        )
      }
    )
  )
  # Labels as in `results`.
  method <- tolerance_rates$method
  method[method == "Naive"] <- "Uncorr"
  method[method == "BMLVAR"] <- "BMLVAR-Default"
  tolerance_rates$method <- method
  rownames(tolerance_rates) <- NULL
  save(
    tolerance_rates,
    file = rates_file,
    compress = "xz"
  )
  invisible(rates_file)
}
data_process_tolerance()
rm(data_process_tolerance)
