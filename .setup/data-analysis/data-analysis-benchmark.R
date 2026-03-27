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
      set.seed(seed)
      Sys.setenv(
        OMP_NUM_THREADS = "1",
        MKL_NUM_THREADS = "1",
        OPENBLAS_NUM_THREADS = "1"
      )
      fit <- FitDTVAR(
        data = data,
        seed = seed,
        ncores = parallel::detectCores()
      )
      Sys.setenv(
        OMP_NUM_THREADS = paste0(parallel::detectCores()),
        MKL_NUM_THREADS = paste0(parallel::detectCores()),
        OPENBLAS_NUM_THREADS = paste0(parallel::detectCores())
      )
      FitMetaVAR(
        fit = fit,
        seed = seed,
        ncores = parallel::detectCores()
      )
      Sys.setenv(
        OMP_NUM_THREADS = "1",
        MKL_NUM_THREADS = "1",
        OPENBLAS_NUM_THREADS = "1"
      )
    }
    Naive <- function(data,
                      seed) {
      set.seed(seed)
      Sys.setenv(
        OMP_NUM_THREADS = "1",
        MKL_NUM_THREADS = "1",
        OPENBLAS_NUM_THREADS = "1"
      )
      fit <- FitDTVAR(
        data = data,
        seed = seed,
        ncores = parallel::detectCores()
      )
      FitNaive(
        fit = fit,
        seed = seed
      )
    }
    BMLVAR <- function(data,
                       seed) {
      set.seed(seed)
      Sys.setenv(
        OMP_NUM_THREADS = "1",
        MKL_NUM_THREADS = "1",
        OPENBLAS_NUM_THREADS = "1"
      )
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
      file = output
    )
  }
}
data_analysis_benchmark()
rm(data_analysis_benchmark)
