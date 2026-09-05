data_analysis_adid2010_dsem_priors <- function(overwrite = FALSE) {
  wd <- getwd()
  on.exit(
    setwd(wd),
    add = TRUE
  )
  set.seed(42)
  # find root directory
  root <- rprojroot::is_rstudio_project
  output <- root$find_file(
    ".setup",
    "data-raw",
    "adid2010-dsem-priors.out"
  )
  source(
    root$find_file(
      ".setup",
      "data-analysis",
      "data-analysis-001-empirical-data-ema.R"
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
    cat("\ndata_analysis_adid2010_dsem_priors\n")
    Sys.setenv(
      OMP_NUM_THREADS = "1",
      MKL_NUM_THREADS = "1",
      OPENBLAS_NUM_THREADS = "1"
    )
    data_raw <- root$find_file(
      ".setup",
      "data-raw"
    )
    setwd(data_raw)
    system(
      paste(
        "mplus",
        "adid2010-dsem-priors.inp",
        "adid2010-dsem-priors.out"
      )
    )
  }
}
data_analysis_adid2010_dsem_priors()
rm(data_analysis_adid2010_dsem_priors)
