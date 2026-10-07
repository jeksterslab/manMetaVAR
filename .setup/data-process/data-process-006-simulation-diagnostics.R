data_process_simulation_diagnostics <- function(overwrite = FALSE,
                                                replications = 1000L,
                                                require_complete = TRUE) {
  cat("\ndata_process_simulation_diagnostics\n")
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

  combine_diagnostics <- function(files) {
    objects <- lapply(
      X = files,
      FUN = readRDS
    )
    combine <- function(extract) {
      pieces <- lapply(
        X = objects,
        FUN = extract
      )
      pieces <- Filter(
        f = function(x) {
          is.data.frame(x) && nrow(x) > 0L
        },
        x = pieces
      )
      if (length(pieces) < 1L) {
        return(data.frame())
      }
      out <- do.call(
        what = rbind,
        args = pieces
      )
      rownames(out) <- NULL
      out
    }
    thresholds <- unique(
      lapply(
        X = objects,
        FUN = `[[`,
        "thresholds"
      )
    )
    if (length(thresholds) != 1L) {
      stop(
        "Boundary-diagnostic thresholds differ across summary files.",
        call. = FALSE
      )
    }
    list(
      thresholds = thresholds[[1]],
      status = combine(function(x) x$status),
      status_summary = combine(function(x) x$status_summary),
      boundary_parameter_replications = combine(
        function(x) x$boundary$parameter_replications
      ),
      boundary_parameter_summary = combine(
        function(x) x$boundary$parameter_summary
      ),
      boundary_replication_diagnostics = combine(
        function(x) x$boundary$replication_diagnostics
      ),
      boundary_replication_summary = combine(
        function(x) x$boundary$replication_summary
      ),
      runtime_replications = combine(
        function(x) x$runtime$replications
      ),
      runtime_summary = combine(
        function(x) x$runtime$summary
      )
    )
  }

  parse_taskids <- function(files,
                            prefix) {
    pattern <- paste0(
      "^",
      prefix,
      "([0-9]{5})-",
      sprintf("%05d", replications),
      "\\.Rds$"
    )
    taskids <- sub(
      pattern = pattern,
      replacement = "\\1",
      x = basename(files)
    )
    as.integer(taskids)
  }

  validate_complete <- function(files,
                                expected_taskids,
                                prefix,
                                label) {
    if (!require_complete) {
      return(invisible(NULL))
    }
    if (length(files) < 1L) {
      stop(
        paste0(
          "No ",
          label,
          " diagnostic summaries were found for ",
          replications,
          " replications."
        ),
        call. = FALSE
      )
    }
    observed_taskids <- parse_taskids(
      files = files,
      prefix = prefix
    )
    if (
      anyNA(observed_taskids) ||
        anyDuplicated(observed_taskids) ||
        !setequal(observed_taskids, expected_taskids)
    ) {
      missing_taskids <- setdiff(
        expected_taskids,
        observed_taskids
      )
      extra_taskids <- setdiff(
        observed_taskids,
        expected_taskids
      )
      stop(
        paste0(
          "Incomplete ",
          label,
          " diagnostic summaries. Expected task IDs: ",
          paste(expected_taskids, collapse = ", "),
          ". Missing: ",
          if (length(missing_taskids) > 0L) {
            paste(missing_taskids, collapse = ", ")
          } else {
            "none"
          },
          ". Unexpected/duplicated task IDs: ",
          if (length(extra_taskids) > 0L || anyDuplicated(observed_taskids)) {
            paste(observed_taskids, collapse = ", ")
          } else {
            "none"
          },
          "."
        ),
        call. = FALSE
      )
    }
    invisible(NULL)
  }

  k2_output <- file.path(
    data_folder,
    "simulation_diagnostics.rda"
  )
  if (!file.exists(k2_output) || overwrite) {
    k2_prefix <- "manMetaVAR-summary-diagnostics-"
    k2_pattern <- paste0(
      "^",
      k2_prefix,
      "[0-9]{5}-",
      sprintf("%05d", replications),
      "\\.Rds$"
    )
    k2_files <- list.files(
      path = data_raw_folder,
      pattern = k2_pattern,
      full.names = TRUE
    )
    validate_complete(
      files = k2_files,
      expected_taskids = seq_len(36L),
      prefix = k2_prefix,
      label = "k = 2"
    )
    simulation_diagnostics <- combine_diagnostics(k2_files)
    save(
      simulation_diagnostics,
      file = k2_output,
      compress = "xz"
    )
  }

  invisible(NULL)
}

data_process_simulation_diagnostics()
rm(data_process_simulation_diagnostics)
