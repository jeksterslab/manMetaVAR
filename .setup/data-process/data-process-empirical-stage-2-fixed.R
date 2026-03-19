data_process_adid2010_stage_2_fixed <- function(overwrite = FALSE) {
  set.seed(42)
  # find root directory
  root <- rprojroot::is_rstudio_project
  input <- root$find_file(
    ".setup",
    "data-raw",
    "adid2010-stage-1.Rds"
  )
  output <- root$find_file(
    ".setup",
    "data-raw",
    "adid2010-stage-2-fixed.Rds"
  )
  source(
    root$find_file(
      ".setup",
      "data-process",
      "data-process-empirical-stage-1.R"
    )
  )
  raw_data <- root$find_file(
    ".setup",
    "data-raw",
    "adid2010-ema.txt"
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
  if (!file.exists(raw_data)) {
    write <- FALSE
  }
  if (write) {
    cat("\ndata_process_adid2010_stage_2_fixed\n")
    Sys.setenv(
      OMP_NUM_THREADS = paste0(parallel::detectCores()),
      MKL_NUM_THREADS = paste0(parallel::detectCores()),
      OPENBLAS_NUM_THREADS = paste0(parallel::detectCores())
    )
    stage1 <- readRDS(
      input
    )
    library(OpenMx)
    library(fitVARMxID)
    library(metaDyn)
    stage2 <- MetaVARMx(
      object = stage1,
      random = FALSE,
      ncores = parallel::detectCores()
    )
    saveRDS(
      object = stage2,
      file = output
    )
  }
}
data_process_adid2010_stage_2_fixed()
rm(data_process_adid2010_stage_2_fixed)
