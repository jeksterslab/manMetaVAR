data_process_results <- function(overwrite = FALSE,
                                 replications = 10L,
                                 include_robust = FALSE,
                                 require_complete = TRUE) {
  cat("\ndata_process_results\n")
  if (
    length(replications) != 1L ||
      !is.numeric(replications) ||
      !is.finite(replications) ||
      replications < 1 ||
      replications != floor(replications)
  ) {
    stop(
      "`replications` should be a single positive integer.",
      call. = FALSE
    )
  }
  if (
    length(include_robust) != 1L ||
      is.na(include_robust) ||
      !is.logical(include_robust)
  ) {
    stop(
      "`include_robust` should be `TRUE` or `FALSE`.",
      call. = FALSE
    )
  }
  if (
    length(require_complete) != 1L ||
      is.na(require_complete) ||
      !is.logical(require_complete)
  ) {
    stop(
      "`require_complete` should be `TRUE` or `FALSE`.",
      call. = FALSE
    )
  }
  replications <- as.integer(replications)
  root <- rprojroot::is_rstudio_project
  data_folder <- root$find_file("data")
  data_raw_folder <- root$find_file(
    ".setup",
    "data-raw"
  )
  if (!dir.exists(data_folder)) {
    dir.create(
      data_folder,
      recursive = TRUE
    )
  }
  if (!dir.exists(data_raw_folder)) {
    dir.create(
      data_raw_folder,
      recursive = TRUE
    )
  }
  results_file <- file.path(
    data_folder,
    "results.rda"
  )
  write <- !file.exists(results_file) || overwrite
  if (write) {
    required_data <- file.path(
      data_folder,
      c(
        "params.rda",
        "population.rda"
      )
    )
    if (any(!file.exists(required_data))) {
      stop(
        paste(
          "`data/params.rda` and `data/population.rda` must exist before",
          "processing simulation results."
        ),
        call. = FALSE
      )
    }
    data_environment <- new.env(
      parent = emptyenv()
    )
    load(
      file = required_data[1],
      envir = data_environment
    )
    load(
      file = required_data[2],
      envir = data_environment
    )
    params <- data_environment$params
    population <- data_environment$population
    rm(data_environment)
    summary_files <- list.files(
      path = data_raw_folder,
      pattern = paste0(
        "^manMetaVAR-summary-",
        "(fit-meta-var-mx-(normal|robust|naive)|",
        "fit-mplus(-priors)?)-",
        "[0-9]{5}-",
        sprintf("%05d", replications),
        "\\.Rds$"
      ),
      full.names = TRUE
    )
    if (length(summary_files) == 0L) {
      stop(
        paste0(
          "No simulation summaries with ",
          replications,
          " replications were found."
        ),
        call. = FALSE
      )
    }
    results <- do.call(
      what = "rbind",
      args = lapply(
        X = summary_files,
        FUN = function(i) {
          object <- readRDS(i)
          if (
            is.null(object$means) ||
              !is.data.frame(object$means)
          ) {
            stop(
              paste0(
                "The summary file does not contain a means data frame: ",
                basename(i),
                "."
              ),
              call. = FALSE
            )
          }
          object$means
        }
      )
    )
    required <- c(
      "taskid",
      "replications",
      "parnames",
      "parameter",
      "method",
      "n",
      "time",
      "heterogeneity",
      "ci",
      "bias",
      "rel_bias"
    )
    missing <- setdiff(
      required,
      names(results)
    )
    if (length(missing) > 0L) {
      stop(
        paste0(
          "The combined results are missing: ",
          paste(missing, collapse = ", "),
          "."
        ),
        call. = FALSE
      )
    }
    if (any(results$replications != replications)) {
      stop(
        "A summary file contains an unexpected replication count.",
        call. = FALSE
      )
    }
    results$method[results$method == "Naive"] <- "Uncorr"
    results$method[results$method == "BMLVAR"] <- "BMLVAR-Default"
    if (!include_robust) {
      results <- results[
        results$ci != "Robust", ,
        drop = FALSE
      ]
    }
    parameter_names <- c(
      paste0("alpha[", seq_len(6L), ",1]"),
      "tau_sqr[1,1]",
      "tau_sqr[2,1]",
      "tau_sqr[2,2]",
      "tau_sqr[3,3]",
      "tau_sqr[4,3]",
      "tau_sqr[5,3]",
      "tau_sqr[6,3]",
      "tau_sqr[4,4]",
      "tau_sqr[5,4]",
      "tau_sqr[6,4]",
      "tau_sqr[5,5]",
      "tau_sqr[6,5]",
      "tau_sqr[6,6]"
    )
    results$par_idx <- match(
      results$parnames,
      parameter_names
    )
    if (anyNA(results$par_idx)) {
      stop(
        paste0(
          "Unknown simulation parameters were found: ",
          paste(
            unique(results$parnames[is.na(results$par_idx)]),
            collapse = ", "
          ),
          "."
        ),
        call. = FALSE
      )
    }
    zero_truth <- results$parameter == 0
    legacy_sentinel <- is.finite(results$rel_bias) &
      results$rel_bias < -999
    results$rel_bias[zero_truth | legacy_sentinel] <- NA_real_
    key <- results[
      c(
        "taskid",
        "method",
        "ci",
        "parnames"
      )
    ]
    if (anyDuplicated(key)) {
      stop(
        paste(
          "Duplicate task, method, interval, and parameter rows",
          "were found in the combined results."
        ),
        call. = FALSE
      )
    }
    observed_taskid <- sort(unique(results$taskid))
    expected_taskid <- sort(unique(params$taskid))
    if (require_complete) {
      missing_taskid <- setdiff(
        expected_taskid,
        observed_taskid
      )
      unexpected_taskid <- setdiff(
        observed_taskid,
        expected_taskid
      )
      if (
        length(missing_taskid) > 0L ||
          length(unexpected_taskid) > 0L
      ) {
        stop(
          paste0(
            "The result task IDs do not match `params`. Missing: ",
            paste(missing_taskid, collapse = ", "),
            "; unexpected: ",
            paste(unexpected_taskid, collapse = ", "),
            "."
          ),
          call. = FALSE
        )
      }
    }
    devtools::load_all()
    for (taskid in observed_taskid) {
      task_rows <- which(results$taskid == taskid)
      param <- .TaskParameters(
        taskid = taskid,
        params_object = params
      )
      time_matches <- if (is.na(param$time)) {
        all(is.na(results$time[task_rows]))
      } else {
        all(
          !is.na(results$time[task_rows]) &
            results$time[task_rows] == param$time
        )
      }
      if (
        any(results$n[task_rows] != param$n) ||
          any(results$heterogeneity[task_rows] != param$heterogeneity) ||
          !time_matches
      ) {
        stop(
          paste0(
            "Design values do not align with `params` for taskid = ",
            taskid,
            "."
          ),
          call. = FALSE
        )
      }
      condition <- .SumPopulationCondition(
        heterogeneity = param$heterogeneity,
        population_object = population
      )
      expected_parameter <- condition$parameter[
        results$parnames[task_rows]
      ]
      if (
        anyNA(expected_parameter) ||
          !isTRUE(
            all.equal(
              unname(results$parameter[task_rows]),
              unname(expected_parameter),
              tolerance = sqrt(.Machine$double.eps)
            )
          )
      ) {
        stop(
          paste0(
            "Population values do not align with the calibrated target for ",
            "taskid = ",
            taskid,
            "."
          ),
          call. = FALSE
        )
      }
    }
    results$se_bias <- NULL
    results$rel_se_bias <- NULL
    results <- results[
      order(
        results$heterogeneity,
        results$taskid,
        results$method,
        results$ci,
        results$par_idx
      ), ,
      drop = FALSE
    ]
    rownames(results) <- NULL
    save(
      results,
      file = results_file,
      compress = "xz"
    )
  }
}
data_process_results()
rm(data_process_results)
