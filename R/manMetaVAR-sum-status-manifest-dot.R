.SumStatusManifest <- function(taskid,
                               reps,
                               output_folder,
                               k4 = FALSE) {
  reps <- .SumValidateReps(reps)
  output_type <- if (k4) {
    "status-k4"
  } else {
    "status"
  }
  files <- vapply(
    X = seq_len(reps),
    FUN = function(repid) {
      SimFN(
        output_type = output_type,
        output_folder = output_folder,
        suffix = .SimSuffix(
          taskid = taskid,
          repid = repid
        )
      )
    },
    FUN.VALUE = character(1)
  )
  exists <- file.exists(files)
  if (!any(exists)) {
    return(NULL)
  }
  if (!all(exists)) {
    missing_repids <- which(!exists)
    stop(
      paste0(
        "Simulation status manifests are incomplete for taskid = ",
        taskid,
        ". Missing replications: ",
        paste(missing_repids, collapse = ", "),
        ". Run Check/CheckK4 for all requested replications before summarizing."
      ),
      call. = FALSE
    )
  }
  status_rows <- lapply(
    X = files,
    FUN = readRDS
  )
  status_rows <- lapply(
    X = status_rows,
    FUN = function(x) {
      if (!"attempt_recorded" %in% names(x)) {
        x$attempt_recorded <- FALSE
      }
      if (!"estimation_attempted" %in% names(x)) {
        x$estimation_attempted <- x$exists
      }
      x
    }
  )
  status <- do.call(
    what = rbind,
    args = status_rows
  )
  rownames(status) <- NULL
  status
}
