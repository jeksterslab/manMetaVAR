# AVOID OVER SUBSCRIPTION ------------------------------------------------------
Sys.setenv(
  OMP_NUM_THREADS = "1",
  MKL_NUM_THREADS = "1",
  OPENBLAS_NUM_THREADS = "1"
)

suppressMessages(
  suppressWarnings(
    library(manMetaVAR)
  )
)

# USE THE K = 2 ARGUMENT FILE AS THE AUTHORITATIVE REPLICATION COUNT -----------
source(
  file.path(
    "/scratch",
    Sys.getenv("USER"),
    "manMetaVAR",
    ".sim",
    "sim-args.R"
  )
)

k2_taskids <- seq_len(tasks)
k4_taskids <- 9L

# HELPERS ---------------------------------------------------------------------
.bind_rows <- function(x) {
  x <- Filter(
    f = function(i) {
      is.data.frame(i) && nrow(i) > 0L
    },
    x = x
  )
  if (length(x) < 1L) {
    return(data.frame())
  }
  out <- do.call(
    what = rbind,
    args = x
  )
  rownames(out) <- NULL
  out
}

.task_folder <- function(taskid,
                         k4 = FALSE) {
  file.path(
    output_folder,
    paste0(
      SimProj(),
      if (k4) "-k4-" else "-",
      sprintf("%05d", taskid)
    )
  )
}

.summary_file <- function(taskid,
                          output_type,
                          k4 = FALSE) {
  SimFN(
    output_type = output_type,
    output_folder = .task_folder(
      taskid = taskid,
      k4 = k4
    ),
    suffix = paste0(
      sprintf("%05d", taskid),
      "-",
      sprintf("%05d", reps),
      ".Rds"
    )
  )
}

.read_required <- function(fn) {
  if (!file.exists(fn)) {
    stop(
      paste0(
        "Required summary file is missing: ",
        fn,
        "."
      ),
      call. = FALSE
    )
  }
  readRDS(fn)
}

.read_optional <- function(fn) {
  if (!file.exists(fn)) {
    return(NULL)
  }
  readRDS(fn)
}

.collect_diagnostics <- function(taskids,
                                 k4 = FALSE) {
  output_type <- if (k4) {
    "summary-diagnostics-k4"
  } else {
    "summary-diagnostics"
  }
  objects <- lapply(
    X = taskids,
    FUN = function(taskid) {
      .read_required(
        .summary_file(
          taskid = taskid,
          output_type = output_type,
          k4 = k4
        )
      )
    }
  )
  list(
    thresholds = lapply(objects, `[[`, "thresholds"),
    status_summary = .bind_rows(
      lapply(objects, `[[`, "status_summary")
    ),
    boundary_parameter = .bind_rows(
      lapply(
        objects,
        function(x) x$boundary$parameter_summary
      )
    ),
    boundary_replication = .bind_rows(
      lapply(
        objects,
        function(x) x$boundary$replication_summary
      )
    ),
    runtime = .bind_rows(
      lapply(
        objects,
        function(x) x$runtime$summary
      )
    )
  )
}

.collect_performance <- function(taskids,
                                 specifications,
                                 k4 = FALSE) {
  rows <- list()
  for (taskid in taskids) {
    for (output_type in specifications) {
      object <- .read_optional(
        .summary_file(
          taskid = taskid,
          output_type = output_type,
          k4 = k4
        )
      )
      if (
        !is.null(object) &&
          is.data.frame(object$means) &&
          nrow(object$means) > 0L
      ) {
        x <- object$means
        x$summary_output_type <- output_type
        rows[[length(rows) + 1L]] <- x
      }
    }
  }
  .bind_rows(rows)
}

.collect_mplus_diagnostics <- function(taskids,
                                       specifications,
                                       k4 = FALSE) {
  parameter_rows <- list()
  run_rows <- list()
  for (taskid in taskids) {
    for (output_type in specifications) {
      object <- .read_optional(
        .summary_file(
          taskid = taskid,
          output_type = output_type,
          k4 = k4
        )
      )
      if (is.null(object)) {
        next
      }
      if (
        is.data.frame(object$means) &&
          nrow(object$means) > 0L
      ) {
        x <- object$means
        x$summary_output_type <- output_type
        parameter_rows[[length(parameter_rows) + 1L]] <- x
      }
      if (
        is.data.frame(object$run_means) &&
          nrow(object$run_means) > 0L
      ) {
        x <- object$run_means
        x$summary_output_type <- output_type
        run_rows[[length(run_rows) + 1L]] <- x
      }
    }
  }
  list(
    parameter = .bind_rows(parameter_rows),
    run = .bind_rows(run_rows)
  )
}

.write_csv <- function(x,
                       fn) {
  if (!is.data.frame(x) || nrow(x) < 1L) {
    return(invisible(NULL))
  }
  utils::write.csv(
    x = x,
    file = fn,
    row.names = FALSE,
    na = ""
  )
  invisible(fn)
}

# COLLECT ---------------------------------------------------------------------
k2 <- .collect_diagnostics(
  taskids = k2_taskids,
  k4 = FALSE
)
k4 <- .collect_diagnostics(
  taskids = k4_taskids,
  k4 = TRUE
)

k2$performance <- .collect_performance(
  taskids = k2_taskids,
  specifications = c(
    "summary-fit-meta-var-mx-normal",
    "summary-fit-meta-var-mx-robust",
    "summary-fit-meta-var-mx-naive",
    "summary-fit-mplus",
    "summary-fit-mplus-priors"
  ),
  k4 = FALSE
)

k4$performance <- .collect_performance(
  taskids = k4_taskids,
  specifications = c(
    "summary-fit-meta-var-mx-k4-normal",
    "summary-fit-meta-var-mx-k4-robust",
    "summary-fit-mplus-k4",
    "summary-fit-mplus-k4-priors"
  ),
  k4 = TRUE
)

k2$mplus_diagnostics <- .collect_mplus_diagnostics(
  taskids = k2_taskids,
  specifications = c(
    "summary-fit-mplus-diagnostics",
    "summary-fit-mplus-priors-diagnostics"
  ),
  k4 = FALSE
)

k4$mplus_diagnostics <- .collect_mplus_diagnostics(
  taskids = k4_taskids,
  specifications = c(
    "summary-fit-mplus-k4-diagnostics",
    "summary-fit-mplus-k4-priors-diagnostics"
  ),
  k4 = TRUE
)

output <- list(
  replications = reps,
  k2_taskids = k2_taskids,
  k4_taskids = k4_taskids,
  k2 = k2,
  k4 = k4
)

# SAVE ------------------------------------------------------------------------
overview_folder <- file.path(
  output_folder,
  "diagnostics-overview"
)
if (!dir.exists(overview_folder)) {
  dir.create(
    overview_folder,
    recursive = TRUE,
    showWarnings = FALSE
  )
}

fn_rds <- file.path(
  overview_folder,
  paste0(
    SimProj(),
    "-diagnostics-overview-",
    sprintf("%05d", reps),
    ".Rds"
  )
)
saveRDS(
  object = output,
  file = fn_rds,
  compress = "xz"
)

# K = 2 TABLES ----------------------------------------------------------------
.write_csv(
  k2$status_summary,
  file.path(overview_folder, "status-summary-k2.csv")
)
.write_csv(
  k2$boundary_parameter,
  file.path(overview_folder, "boundary-parameter-k2.csv")
)
.write_csv(
  k2$boundary_replication,
  file.path(overview_folder, "boundary-replication-k2.csv")
)
.write_csv(
  k2$runtime,
  file.path(overview_folder, "runtime-k2.csv")
)
.write_csv(
  k2$performance,
  file.path(overview_folder, "performance-mcse-k2.csv")
)
.write_csv(
  k2$mplus_diagnostics$parameter,
  file.path(overview_folder, "mplus-diagnostics-parameter-k2.csv")
)
.write_csv(
  k2$mplus_diagnostics$run,
  file.path(overview_folder, "mplus-diagnostics-run-k2.csv")
)

# K = 4 TABLES ----------------------------------------------------------------
.write_csv(
  k4$status_summary,
  file.path(overview_folder, "status-summary-k4.csv")
)
.write_csv(
  k4$boundary_parameter,
  file.path(overview_folder, "boundary-parameter-k4.csv")
)
.write_csv(
  k4$boundary_replication,
  file.path(overview_folder, "boundary-replication-k4.csv")
)
.write_csv(
  k4$runtime,
  file.path(overview_folder, "runtime-k4.csv")
)
.write_csv(
  k4$performance,
  file.path(overview_folder, "performance-mcse-k4.csv")
)
.write_csv(
  k4$mplus_diagnostics$parameter,
  file.path(overview_folder, "mplus-diagnostics-parameter-k4.csv")
)
.write_csv(
  k4$mplus_diagnostics$run,
  file.path(overview_folder, "mplus-diagnostics-run-k4.csv")
)

message(
  "Diagnostics overview written to: ",
  overview_folder
)
