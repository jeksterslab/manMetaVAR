data_process_adid2010_stage_2_random_block_diag <- function(overwrite = FALSE) {
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
    "adid2010-stage-2-random-block-diag.Rds"
  )
  source(
    root$find_file(
      ".setup",
      "data-process",
      "data-process-empirical-stage-1.R"
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
    cat("\ndata_process_adid2010_stage_2_random_block_diag\n")
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
      random = TRUE,
      tau_sqr_l_free = matrix(
        data = c(
          FALSE, FALSE, FALSE, FALSE, FALSE, FALSE, FALSE, FALSE, FALSE,
          TRUE, FALSE, FALSE, FALSE, FALSE, FALSE, FALSE, FALSE, FALSE,
          FALSE, FALSE, FALSE, FALSE, FALSE, FALSE, FALSE, FALSE, FALSE,
          FALSE, FALSE, TRUE, FALSE, FALSE, FALSE, FALSE, FALSE, FALSE,
          FALSE, FALSE, TRUE, TRUE, FALSE, FALSE, FALSE, FALSE, FALSE,
          FALSE, FALSE, TRUE, TRUE, TRUE, FALSE, FALSE, FALSE, FALSE,
          FALSE, FALSE, FALSE, FALSE, FALSE, FALSE, FALSE, FALSE, FALSE,
          FALSE, FALSE, FALSE, FALSE, FALSE, FALSE, TRUE, FALSE, FALSE,
          FALSE, FALSE, FALSE, FALSE, FALSE, FALSE, TRUE, TRUE, FALSE
        ),
        byrow = TRUE,
        nrow = 9,
        ncol = 9
      ),
      tau_sqr_l_values = matrix(
        data = 0,
        nrow = 9,
        ncol = 9
      ),
      ncores = parallel::detectCores()
    )
    saveRDS(
      object = stage2,
      file = output
    )
  }
}
data_process_adid2010_stage_2_random_block_diag()
rm(data_process_adid2010_stage_2_random_block_diag)
