data_analysis_benchmark <- function(overwrite = FALSE) {
  set.seed(42)
  # find root directory
  root <- rprojroot::is_rstudio_project
  output <- root$find_file(
    ".setup",
    "data-raw",
    "benchmark.Rds"
  )
  vignette <- root$find_file(
    "vignettes",
    "benchmark.Rmd"
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
  if (file.exists(vignette)) {
    write <- FALSE
  }
  if (write) {
    cat("\ndata_analysis_benchmark\n")
    library(OpenMx)
    library(fitVARMxID)
    library(metaDyn)
    library(manMetaVAR)
    taskid <- 9
    seed <- 42
    set.seed(seed)
    data <- GenData(
      taskid = taskid,
      seed = seed
    )
    MetaVAR <- function(data,
                        seed) {
      FitMetaVAR(
        fit = FitDTVAR(
          data = data,
          seed = seed,
          ncores = parallel::detectCores()
        ),
        seed = seed,
        ncores = parallel::detectCores()
      )
    }
    Naive <- function(data,
                      seed) {
      FitNaive(
        fit = FitDTVAR(
          data = data,
          seed = seed,
          ncores = parallel::detectCores()
        )
      )
    }
    BMLVAR <- function(data,
                       seed) {
      FitMplus(
        data = data,
        seed = seed,
        ncores = parallel::detectCores()
      )
    }
    benchmark <- microbenchmark::microbenchmark(
      MetaVAR = MetaVAR(
        data = data,
        seed = seed
      ),
      Naive = Naive(
        data = data,
        seed = seed
      ),
      BMLVAR = BMLVAR(
        data = data,
        seed = seed
      ),
      times = 10
    )
    saveRDS(
      object = benchmark,
      file = con
    )
  }
}
data_analysis_benchmark()
rm(data_analysis_benchmark)
