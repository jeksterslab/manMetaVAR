#' Identify Replications Eligible for Performance Summaries
#'
#' Identifies the replication IDs that may contribute to numerical recovery
#' summaries for a requested simulation output. A replication is eligible only
#' when every stage required by the method has a present, readable, converged,
#' admissible fit with status `ok`.
#'
#' Genuine estimation outcomes (`estimation_error`, `upstream_failure`,
#' `nonconvergence`, and `inadmissible`) are excluded from numerical recovery
#' summaries but remain represented in the status diagnostics. Repair-required
#' failures (`missing_file`, `unreadable_file`, `infrastructure_error`, and
#' `check_error`) cause an error rather than being silently excluded.
#'
#' For two-stage methods, the returned IDs are the intersection of successful
#' Stage 1 and Stage 2 replications. Thus performance metrics may use fewer
#' replications than the requested simulation denominator, while success and
#' failure rates remain available from the status summaries.
#'
#' @author Ivan Jacob Agaloos Pesigan
#'
#' @inheritParams Template
#' @param k4 Logical. If `TRUE`, use the four-variable status manifests;
#'   otherwise use the two-variable manifests.
#'
#' @return An integer vector of replication IDs eligible for the requested
#'   performance summary. If no status manifests exist, all requested
#'   replications are returned for backward compatibility. Incomplete manifests
#'   or repair-required failures cause an error.
#'
#' @keywords manMetaVAR internal simulation summary diagnostics
#' @noRd
.SumValidRepids <- function(taskid,
                            reps,
                            output_folder,
                            output_type,
                            k4 = FALSE) {
  status <- .SumStatusManifest(
    taskid = taskid,
    reps = reps,
    output_folder = output_folder,
    k4 = k4
  )
  if (is.null(status)) {
    message(
      paste0(
        "No simulation status manifests were found for taskid = ",
        taskid,
        "; using all ",
        reps,
        " replications for backward compatibility."
      )
    )
    return(seq_len(reps))
  }

  required_output_types <- switch(output_type,
    "fit-meta-var-mx" = c(
      "fit-dt-var-mx",
      "fit-meta-var-mx"
    ),
    "fit-naive" = c(
      "fit-dt-var-mx",
      "fit-naive"
    ),
    "fit-meta-var-mx-k4" = c(
      "fit-dt-var-mx-k4",
      "fit-meta-var-mx-k4"
    ),
    output_type
  )

  expected_repids <- seq_len(reps)
  valid_repids <- vector(
    mode = "list",
    length = length(required_output_types)
  )

  for (j in seq_along(required_output_types)) {
    required_output_type <- required_output_types[j]
    status_j <- status[
      status$output_type == required_output_type, ,
      drop = FALSE
    ]

    if (nrow(status_j) != reps) {
      stop(
        paste0(
          "Expected ",
          reps,
          " status rows for output type '",
          required_output_type,
          "' but found ",
          nrow(status_j),
          "."
        ),
        call. = FALSE
      )
    }

    if (anyDuplicated(status_j$repid)) {
      stop(
        paste0(
          "Duplicated status rows were found for output type '",
          required_output_type,
          "'."
        ),
        call. = FALSE
      )
    }

    observed_repids <- sort(as.integer(status_j$repid))
    if (!identical(observed_repids, expected_repids)) {
      stop(
        paste0(
          "Status rows for output type '",
          required_output_type,
          "' do not cover the requested replications 1 through ",
          reps,
          "."
        ),
        call. = FALSE
      )
    }

    infrastructure_failure <- status_j$failure_class %in% c(
      "missing_file",
      "unreadable_file",
      "infrastructure_error",
      "check_error"
    )
    if (any(infrastructure_failure)) {
      failed <- status_j[
        infrastructure_failure, ,
        drop = FALSE
      ]
      failure_text <- paste0(
        failed$repid,
        " (",
        failed$failure_class,
        ")"
      )
      stop(
        paste0(
          "Infrastructure/checking failures were found for output type '",
          required_output_type,
          "' in taskid = ",
          taskid,
          ": ",
          paste(failure_text, collapse = ", "),
          ". Rerun or repair these replications before summarizing."
        ),
        call. = FALSE
      )
    }

    valid <- with(
      status_j,
      exists &
        readable &
        converged &
        admissible &
        status == "ok"
    )
    valid_repids[[j]] <- sort(
      as.integer(
        status_j$repid[valid]
      )
    )
  }

  if (length(valid_repids) == 1L) {
    return(valid_repids[[1]])
  }

  sort(
    Reduce(
      f = intersect,
      x = valid_repids
    )
  )
}
