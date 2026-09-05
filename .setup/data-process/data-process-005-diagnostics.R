data_process_diagnostics <- function(overwrite = FALSE,
                                     replications = 10L,
                                     require_complete = TRUE) {
  cat("\ndata_process_diagnostics\n")
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
  diagnostics_file <- file.path(
    data_folder,
    "diagnostics.rda"
  )
  write <- !file.exists(diagnostics_file) || overwrite
  if (write) {
    params_file <- file.path(
      data_folder,
      "params.rda"
    )
    if (!file.exists(params_file)) {
      stop(
        "`data/params.rda` must exist before processing diagnostics.",
        call. = FALSE
      )
    }
    data_environment <- new.env(
      parent = emptyenv()
    )
    load(
      file = params_file,
      envir = data_environment
    )
    params <- data_environment$params
    rm(data_environment)
    file_pattern <- paste0(
      "^manMetaVAR-summary-fit-mplus",
      "(-priors)?-diagnostics-",
      "([0-9]{5})-",
      sprintf("%05d", replications),
      "\\.Rds$"
    )
    summary_files <- list.files(
      path = data_raw_folder,
      pattern = file_pattern,
      full.names = TRUE
    )
    if (length(summary_files) == 0L) {
      stop(
        paste0(
          "No Mplus diagnostic summaries with ",
          replications,
          " replications were found."
        ),
        call. = FALSE
      )
    }
    parameter_names <- c(
      "psi[1,1]",
      "psi[2,1]",
      "psi[2,2]",
      "mean(beta[1,1])",
      "mean(beta[2,1])",
      "mean(beta[1,2])",
      "mean(beta[2,2])",
      "mean(mu[1,1])",
      "mean(mu[2,1])",
      "cov(beta[1,1],beta[1,1])",
      "cov(beta[2,1],beta[1,1])",
      "cov(beta[2,1],beta[2,1])",
      "cov(beta[1,2],beta[1,1])",
      "cov(beta[1,2],beta[2,1])",
      "cov(beta[1,2],beta[1,2])",
      "cov(beta[2,2],beta[1,1])",
      "cov(beta[2,2],beta[2,1])",
      "cov(beta[2,2],beta[1,2])",
      "cov(beta[2,2],beta[2,2])",
      "cov(mu[1,1],mu[1,1])",
      "cov(mu[2,1],mu[1,1])",
      "cov(mu[2,1],mu[2,1])"
    )
    extract_summary <- function(filename) {
      basename_value <- basename(filename)
      match_value <- regexec(
        pattern = file_pattern,
        text = basename_value
      )
      parts <- regmatches(
        x = basename_value,
        m = match_value
      )[[1]]
      if (length(parts) != 3L) {
        stop(
          paste0(
            "Could not parse the diagnostic summary filename: ",
            basename_value,
            "."
          ),
          call. = FALSE
        )
      }
      default_priors <- !identical(parts[2], "-priors")
      taskid_from_filename <- as.integer(parts[3])
      object <- readRDS(filename)
      if (
        is.null(object$replications) ||
          !is.list(object$replications) ||
          length(object$replications) != replications
      ) {
        stop(
          paste0(
            "The diagnostic summary does not contain ",
            replications,
            " replication objects: ",
            basename_value,
            "."
          ),
          call. = FALSE
        )
      }
      if (
        is.null(object$runs) ||
          !is.data.frame(object$runs) ||
          nrow(object$runs) != replications
      ) {
        stop(
          paste0(
            "The diagnostic summary does not contain ",
            replications,
            " run rows: ",
            basename_value,
            "."
          ),
          call. = FALSE
        )
      }
      required_run <- c(
        "taskid",
        "repid",
        "n",
        "time",
        "default_priors"
      )
      missing_run <- setdiff(
        required_run,
        names(object$runs)
      )
      if (length(missing_run) > 0L) {
        stop(
          paste0(
            "Run diagnostics are missing: ",
            paste(missing_run, collapse = ", "),
            " in ",
            basename_value,
            "."
          ),
          call. = FALSE
        )
      }
      if (
        any(object$runs$taskid != taskid_from_filename) ||
          any(object$runs$default_priors != default_priors)
      ) {
        stop(
          paste0(
            "Run metadata do not match the filename for ",
            basename_value,
            "."
          ),
          call. = FALSE
        )
      }
      param_location <- match(
        taskid_from_filename,
        params$taskid
      )
      if (is.na(param_location)) {
        stop(
          paste0(
            "Unknown task ID in ",
            basename_value,
            "."
          ),
          call. = FALSE
        )
      }
      design <- params[param_location, , drop = FALSE]
      time_matches <- if (is.na(design$time)) {
        all(is.na(object$runs$time))
      } else {
        all(
          !is.na(object$runs$time) &
            object$runs$time == design$time
        )
      }
      if (
        any(object$runs$n != design$n) ||
          !time_matches
      ) {
        stop(
          paste0(
            "Run design values do not align with `params` for taskid = ",
            taskid_from_filename,
            "."
          ),
          call. = FALSE
        )
      }
      method <- if (default_priors) {
        "BMLVAR-Default"
      } else {
        "BMLVAR-Priors"
      }
      parameter_rows <- lapply(
        X = seq_len(replications),
        FUN = function(repid) {
          fit <- object$replications[[repid]]
          if (!inherits(fit, "manmetavar.mplus.diagnostics")) {
            stop(
              paste0(
                "Replication ",
                repid,
                " in ",
                basename_value,
                " is not a `FitMplusDiagnostics()` object."
              ),
              call. = FALSE
            )
          }
          required_parameter <- c(
            "parameter",
            "mean",
            "median",
            "sd",
            "ll",
            "ul",
            "rhat",
            "ess_bulk",
            "ess_tail",
            "mcse_mean",
            "mcse_median",
            "mcse_ll",
            "mcse_ul"
          )
          missing_parameter <- setdiff(
            required_parameter,
            names(fit$parameters)
          )
          if (length(missing_parameter) > 0L) {
            stop(
              paste0(
                "Parameter diagnostics are missing: ",
                paste(missing_parameter, collapse = ", "),
                " in ",
                basename_value,
                ", replication ",
                repid,
                "."
              ),
              call. = FALSE
            )
          }
          if (
            !identical(
              isTRUE(fit$run$default_priors),
              default_priors
            )
          ) {
            stop(
              paste0(
                "Replication ",
                repid,
                " has an unexpected prior condition in ",
                basename_value,
                "."
              ),
              call. = FALSE
            )
          }
          parameter_data <- fit$parameters
          if (!identical(parameter_data$parameter, parameter_names)) {
            stop(
              paste0(
                "Parameter names or ordering differ from the k = 2 ",
                "diagnostic specification in ",
                basename_value,
                ", replication ",
                repid,
                "."
              ),
              call. = FALSE
            )
          }
          data.frame(
            taskid = taskid_from_filename,
            repid = repid,
            replications = replications,
            method = method,
            default_priors = default_priors,
            n = design$n,
            time = design$time,
            heterogeneity = design$heterogeneity,
            par_idx = seq_along(parameter_names),
            parameter_data,
            row.names = NULL,
            check.names = FALSE
          )
        }
      )
      parameter_rows <- do.call(
        what = "rbind",
        args = parameter_rows
      )
      run_rows <- object$runs
      run_rows$replications <- replications
      run_rows$method <- method
      run_rows$heterogeneity <- design$heterogeneity
      run_rows <- run_rows[
        c(
          "taskid",
          "repid",
          "replications",
          "method",
          "default_priors",
          "n",
          "time",
          "heterogeneity",
          setdiff(
            names(run_rows),
            c(
              "taskid",
              "repid",
              "replications",
              "method",
              "default_priors",
              "n",
              "time",
              "heterogeneity"
            )
          )
        )
      ]
      list(
        parameters = parameter_rows,
        runs = run_rows
      )
    }
    extracted <- lapply(
      X = summary_files,
      FUN = extract_summary
    )
    parameter_diagnostics <- do.call(
      what = "rbind",
      args = lapply(
        X = extracted,
        FUN = function(x) {
          x$parameters
        }
      )
    )
    run_diagnostics <- do.call(
      what = "rbind",
      args = lapply(
        X = extracted,
        FUN = function(x) {
          x$runs
        }
      )
    )
    rownames(parameter_diagnostics) <- NULL
    rownames(run_diagnostics) <- NULL
    parameter_key <- parameter_diagnostics[
      c(
        "taskid",
        "repid",
        "method",
        "parameter"
      )
    ]
    if (anyDuplicated(parameter_key)) {
      stop(
        "Duplicate task, replication, prior, and parameter rows were found.",
        call. = FALSE
      )
    }
    run_key <- run_diagnostics[
      c(
        "taskid",
        "repid",
        "method"
      )
    ]
    if (anyDuplicated(run_key)) {
      stop(
        "Duplicate task, replication, and prior run rows were found.",
        call. = FALSE
      )
    }
    observed_taskid <- sort(unique(parameter_diagnostics$taskid))
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
      prior_cells <- unique(
        parameter_diagnostics[
          c(
            "taskid",
            "default_priors"
          )
        ]
      )
      prior_counts <- table(prior_cells$taskid)
      incomplete_priors <- as.integer(
        names(prior_counts)[prior_counts != 2L]
      )
      if (
        length(missing_taskid) > 0L ||
          length(unexpected_taskid) > 0L ||
          length(incomplete_priors) > 0L
      ) {
        stop(
          paste0(
            "The diagnostic task/prior cells are incomplete. Missing task IDs: ",
            paste(missing_taskid, collapse = ", "),
            "; unexpected task IDs: ",
            paste(unexpected_taskid, collapse = ", "),
            "; task IDs without both prior conditions: ",
            paste(incomplete_priors, collapse = ", "),
            "."
          ),
          call. = FALSE
        )
      }
    }
    parameter_diagnostics <- parameter_diagnostics[
      order(
        parameter_diagnostics$heterogeneity,
        parameter_diagnostics$taskid,
        parameter_diagnostics$method,
        parameter_diagnostics$repid,
        parameter_diagnostics$par_idx
      ), ,
      drop = FALSE
    ]
    run_diagnostics <- run_diagnostics[
      order(
        run_diagnostics$heterogeneity,
        run_diagnostics$taskid,
        run_diagnostics$method,
        run_diagnostics$repid
      ), ,
      drop = FALSE
    ]
    rownames(parameter_diagnostics) <- NULL
    rownames(run_diagnostics) <- NULL
    diagnostics <- structure(
      list(
        parameters = parameter_diagnostics,
        runs = run_diagnostics,
        replications = replications
      ),
      class = c(
        "manmetavar.mplus.diagnostics.all",
        "list"
      )
    )
    save(
      diagnostics,
      file = diagnostics_file,
      compress = "xz"
    )
  }
}
data_process_diagnostics()
rm(data_process_diagnostics)
