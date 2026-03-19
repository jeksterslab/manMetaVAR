data_process_adid2010_stage_1 <- function(overwrite = FALSE) {
  set.seed(42)
  # find root directory
  root <- rprojroot::is_rstudio_project
  output <- root$find_file(
    ".setup",
    "data-raw",
    "adid2010-stage-1.Rds"
  )
  source(
    root$find_file(
      ".setup",
      "data-process",
      "data-process-empirical-data-ema.R"
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
    cat("\ndata_process_adid2010_stage_1\n")
    Sys.setenv(
      OMP_NUM_THREADS = "1",
      MKL_NUM_THREADS = "1",
      OPENBLAS_NUM_THREADS = "1"
    )
    data <- readRDS(
      root$find_file(
        ".setup",
        "data-raw",
        "adid2010-data-ema.Rds"
      )
    )
    library(OpenMx)
    library(fitVARMxID)
    stage1 <- FitVARMxID(
      data = data,
      observed = c("na", "pa"),
      id = "id",
      center = TRUE,
      ncores = parallel::detectCores()
    )
    saveRDS(
      object = stage1,
      file = output
    )
  }
}
data_process_adid2010_stage_1()
rm(data_process_adid2010_stage_1)
