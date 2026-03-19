data_process_adid2010_stage_2_test <- function(overwrite = FALSE) {
  set.seed(42)
  # find root directory
  root <- rprojroot::is_rstudio_project
  fixed <- root$find_file(
    ".setup",
    "data-raw",
    "adid2010-stage-2-fixed.Rds"
  )
  random <- root$find_file(
    ".setup",
    "data-raw",
    "adid2010-stage-2-random.Rds"
  )
  block <- root$find_file(
    ".setup",
    "data-raw",
    "adid2010-stage-2-random-block-diag.Rds"
  )
  output <- root$find_file(
    ".setup",
    "data-raw",
    "adid2010-stage-2-test.Rds"
  )
  source(
    root$find_file(
      ".setup",
      "data-process",
      "data-process-empirical-stage-2-fixed.R"
    )
  )
  source(
    root$find_file(
      ".setup",
      "data-process",
      "data-process-empirical-stage-2-random.R"
    )
  )
  source(
    root$find_file(
      ".setup",
      "data-process",
      "data-process-empirical-stage-2-random-block-diag.R"
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
    cat("\ndata_process_adid2010_stage_2_test\n")
    fixed <- readRDS(
      fixed
    )$output
    random <- readRDS(
      random
    )$output
    block <- readRDS(
      block
    )$output
    library(OpenMx)
    random_fixed <- mxCompare(random, fixed)
    block_fixed <- mxCompare(block, fixed)
    random_block <- mxCompare(random, block)
    saveRDS(
      object = list(
        random_fixed = random_fixed,
        block_fixed = block_fixed,
        random_block = random_block
      ),
      file = output
    )
  }
}
data_process_adid2010_stage_2_test()
rm(data_process_adid2010_stage_2_test)
