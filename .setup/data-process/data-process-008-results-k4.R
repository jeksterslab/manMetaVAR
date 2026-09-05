data_process_results_k4 <- function(overwrite = FALSE,
                                    replications = 10L,
                                    taskid = NULL,
                                    include_robust = FALSE,
                                    require_complete = TRUE) {
  cat("\ndata_process_results_k4\n")

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

  if (!is.null(taskid)) {
    if (
      length(taskid) != 1L ||
        !is.numeric(taskid) ||
        !is.finite(taskid) ||
        taskid < 1 ||
        taskid != floor(taskid)
    ) {
      stop(
        "`taskid` should be `NULL` or a single positive integer.",
        call. = FALSE
      )
    }

    taskid <- as.integer(taskid)
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

  data_folder <- root$find_file(
    "data"
  )

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
    "resultsk4.rda"
  )

  write <- !file.exists(results_file) || overwrite

  if (write) {
    required_data <- file.path(
      data_folder,
      c(
        "params.rda",
        "populationk4.rda"
      )
    )

    if (any(!file.exists(required_data))) {
      stop(
        paste(
          "`data/params.rda` and `data/populationk4.rda` must exist",
          "before processing the k = 4 simulation results."
        ),
        call. = FALSE
      )
    }

    load_data_object <- function(file,
                                 candidates) {
      data_environment <- new.env(
        parent = emptyenv()
      )

      object_names <- load(
        file = file,
        envir = data_environment
      )

      selected_object <- intersect(
        candidates,
        object_names
      )

      if (length(selected_object) != 1L) {
        stop(
          paste0(
            "Could not uniquely identify the required object in ",
            basename(file),
            ". Expected one of: ",
            paste(candidates, collapse = ", "),
            ". Found: ",
            paste(object_names, collapse = ", "),
            "."
          ),
          call. = FALSE
        )
      }

      get(
        selected_object,
        envir = data_environment,
        inherits = FALSE
      )
    }

    params <- load_data_object(
      file = required_data[1],
      candidates = c(
        "params_k4",
        "params"
      )
    )

    population <- load_data_object(
      file = required_data[2],
      candidates = c(
        "populationk4",
        "population"
      )
    )

    rm(load_data_object)

    if (
      !is.null(taskid) &&
        !taskid %in% params$taskid
    ) {
      stop(
        paste0(
          "The requested taskid = ",
          taskid,
          " is not defined in `params_k4`."
        ),
        call. = FALSE
      )
    }

    model_pattern <- paste0(
      "(",
      "fit-meta-var-mx-",
      "((normal|robust)-k4|k4-(normal|robust))",
      "|",
      "fit-mplus",
      "((-priors)?-k4|-k4(-priors)?)",
      ")"
    )

    taskid_pattern <- if (is.null(taskid)) {
      "[0-9]{5}"
    } else {
      sprintf(
        "%05d",
        taskid
      )
    }

    summary_files <- list.files(
      path = data_raw_folder,
      pattern = paste0(
        "^manMetaVAR-summary-",
        model_pattern,
        "-",
        taskid_pattern,
        "-",
        sprintf("%05d", replications),
        "\\.Rds$"
      ),
      full.names = TRUE
    )

    if (length(summary_files) == 0L) {
      if (is.null(taskid)) {
        stop(
          paste0(
            "No k = 4 simulation summaries with ",
            replications,
            " replications were found."
          ),
          call. = FALSE
        )
      } else {
        stop(
          paste0(
            "No k = 4 simulation summaries for taskid = ",
            taskid,
            " with ",
            replications,
            " replications were found."
          ),
          call. = FALSE
        )
      }
    }

    resultsk4 <- do.call(
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
      names(resultsk4)
    )

    if (length(missing) > 0L) {
      stop(
        paste0(
          "The combined k = 4 results are missing: ",
          paste(missing, collapse = ", "),
          "."
        ),
        call. = FALSE
      )
    }

    if (
      anyNA(resultsk4$replications) ||
        any(resultsk4$replications != replications)
    ) {
      stop(
        "A k = 4 summary file contains an unexpected replication count.",
        call. = FALSE
      )
    }

    if (
      !is.null(taskid) &&
        any(resultsk4$taskid != taskid)
    ) {
      stop(
        paste0(
          "A summary file contains results for a task other than taskid = ",
          taskid,
          "."
        ),
        call. = FALSE
      )
    }

    if (any(resultsk4$method == "Naive", na.rm = TRUE)) {
      stop(
        "A Naive result was found, but the Naive method is not defined for k = 4.",
        call. = FALSE
      )
    }

    resultsk4$method[
      resultsk4$method == "BMLVAR"
    ] <- "BMLVAR-Default"

    if (!include_robust) {
      resultsk4 <- resultsk4[
        resultsk4$ci != "Robust", ,
        drop = FALSE
      ]
    }

    k <- 4L
    number_alpha <- k + k^2L

    lower_triangle_names <- function(indices) {
      unlist(
        lapply(
          X = indices,
          FUN = function(column) {
            rows <- indices[indices >= column]

            paste0(
              "tau_sqr[",
              rows,
              ",",
              column,
              "]"
            )
          }
        ),
        use.names = FALSE
      )
    }

    parameter_names <- c(
      paste0(
        "alpha[",
        seq_len(number_alpha),
        ",1]"
      ),
      lower_triangle_names(
        seq_len(k)
      ),
      lower_triangle_names(
        (k + 1L):number_alpha
      )
    )

    rm(
      k,
      number_alpha,
      lower_triangle_names
    )

    resultsk4$par_idx <- match(
      resultsk4$parnames,
      parameter_names
    )

    if (anyNA(resultsk4$par_idx)) {
      stop(
        paste0(
          "Unknown k = 4 simulation parameters were found: ",
          paste(
            unique(
              resultsk4$parnames[
                is.na(resultsk4$par_idx)
              ]
            ),
            collapse = ", "
          ),
          "."
        ),
        call. = FALSE
      )
    }

    zero_truth <- !is.na(resultsk4$parameter) &
      resultsk4$parameter == 0

    legacy_sentinel <- is.finite(resultsk4$rel_bias) &
      resultsk4$rel_bias < -999

    resultsk4$rel_bias[
      zero_truth | legacy_sentinel
    ] <- NA_real_

    key <- resultsk4[
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
          "were found in the combined k = 4 results."
        ),
        call. = FALSE
      )
    }

    observed_taskid <- sort(
      unique(resultsk4$taskid)
    )

    expected_taskid <- if (is.null(taskid)) {
      sort(
        unique(params$taskid)
      )
    } else {
      taskid
    }

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
            "The k = 4 result task IDs do not match the expected task IDs. ",
            "Missing: ",
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

    for (taskid_i in observed_taskid) {
      task_rows <- which(
        resultsk4$taskid == taskid_i
      )

      param <- .TaskParameters(
        taskid = taskid_i,
        params_object = params
      )

      time_matches <- if (is.na(param$time)) {
        all(
          is.na(resultsk4$time[task_rows])
        )
      } else {
        all(
          !is.na(resultsk4$time[task_rows]) &
            resultsk4$time[task_rows] == param$time
        )
      }

      if (
        any(resultsk4$n[task_rows] != param$n) ||
          any(
            resultsk4$heterogeneity[task_rows] !=
              param$heterogeneity
          ) ||
          !time_matches
      ) {
        stop(
          paste0(
            "Design values do not align with `params_k4` for taskid = ",
            taskid_i,
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
        resultsk4$parnames[task_rows]
      ]

      if (
        anyNA(expected_parameter) ||
          !isTRUE(
            all.equal(
              unname(
                resultsk4$parameter[task_rows]
              ),
              unname(expected_parameter),
              tolerance = sqrt(
                .Machine$double.eps
              )
            )
          )
      ) {
        stop(
          paste0(
            "Population values do not align with the calibrated k = 4 ",
            "target for taskid = ",
            taskid_i,
            "."
          ),
          call. = FALSE
        )
      }
    }

    resultsk4$se_bias <- NULL
    resultsk4$rel_se_bias <- NULL

    resultsk4 <- resultsk4[
      order(
        resultsk4$heterogeneity,
        resultsk4$taskid,
        resultsk4$method,
        resultsk4$ci,
        resultsk4$par_idx
      ), ,
      drop = FALSE
    ]

    rownames(resultsk4) <- NULL

    save(
      resultsk4,
      file = results_file,
      compress = "xz"
    )
  }
}

data_process_results_k4(taskid = 9)

rm(data_process_results_k4)
