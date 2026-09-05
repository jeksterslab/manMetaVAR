.SumBoundaryDiagnostics <- function(taskid,
                                    reps,
                                    output_folder,
                                    naive,
                                    metavar,
                                    mplus,
                                    variance_tol,
                                    eigen_tol,
                                    k4 = FALSE) {
  param <- .TaskParameters(taskid = taskid)
  heterogeneity <- param$heterogeneity
  specifications <- list()
  if (metavar) {
    specifications[[length(specifications) + 1L]] <- list(
      output_type = if (k4) {
        "fit-meta-var-mx-k4"
      } else {
        "fit-meta-var-mx"
      },
      method = "MetaVAR"
    )
  }
  if (naive && !k4) {
    specifications[[length(specifications) + 1L]] <- list(
      output_type = "fit-naive",
      method = "Uncertainty-Uncorrected"
    )
  }
  if (mplus) {
    specifications[[length(specifications) + 1L]] <- list(
      output_type = if (k4) {
        "fit-mplus-k4"
      } else {
        "fit-mplus"
      },
      method = "Mplus DSEM Default"
    )
    specifications[[length(specifications) + 1L]] <- list(
      output_type = if (k4) {
        "fit-mplus-k4-priors"
      } else {
        "fit-mplus-priors"
      },
      method = "Mplus DSEM Alternative Priors"
    )
  }
  parameter_rows <- list()
  replication_rows <- list()
  for (specification in specifications) {
    repids <- .SumValidRepids(
      taskid = taskid,
      reps = reps,
      output_folder = output_folder,
      output_type = specification$output_type,
      k4 = k4
    )
    if (length(repids) < 1L) {
      next
    }
    results <- lapply(
      X = repids,
      FUN = function(repid) {
        .SumBoundaryReplication(
          taskid = taskid,
          repid = repid,
          output_folder = output_folder,
          output_type = specification$output_type,
          method = specification$method,
          heterogeneity = heterogeneity,
          variance_tol = variance_tol,
          eigen_tol = eigen_tol,
          k4 = k4
        )
      }
    )
    results <- Filter(
      f = Negate(is.null),
      x = results
    )
    if (length(results) < 1L) {
      next
    }
    parameter_rows[[length(parameter_rows) + 1L]] <- do.call(
      what = rbind,
      args = lapply(results, `[[`, "parameter")
    )
    replication_rows[[length(replication_rows) + 1L]] <- do.call(
      what = rbind,
      args = lapply(results, `[[`, "replication")
    )
  }
  parameter_replications <- if (length(parameter_rows) > 0L) {
    do.call(rbind, parameter_rows)
  } else {
    data.frame()
  }
  replication_diagnostics <- if (length(replication_rows) > 0L) {
    do.call(rbind, replication_rows)
  } else {
    data.frame()
  }
  parameter_summary <- data.frame()
  if (nrow(parameter_replications) > 0L) {
    groups <- split(
      x = parameter_replications,
      f = interaction(
        parameter_replications$output_type,
        parameter_replications$parnames,
        drop = TRUE,
        lex.order = TRUE
      )
    )
    parameter_summary <- do.call(
      what = rbind,
      args = lapply(
        X = groups,
        FUN = function(x) {
          data.frame(
            taskid = x$taskid[1],
            output_type = x$output_type[1],
            method = x$method[1],
            parnames = x$parnames[1],
            parameter = x$parameter[1],
            classification = x$classification[1],
            replications_used = nrow(x),
            near_zero_rate = mean(x$near_zero),
            mcse_near_zero_rate = sqrt(
              mean(x$near_zero) *
                (1 - mean(x$near_zero)) /
                nrow(x)
            ),
            boundary_rate = if (all(is.na(x$boundary))) {
              NA_real_
            } else {
              mean(x$boundary, na.rm = TRUE)
            },
            mcse_boundary_rate = if (all(is.na(x$boundary))) {
              NA_real_
            } else {
              sqrt(
                mean(x$boundary, na.rm = TRUE) *
                  (1 - mean(x$boundary, na.rm = TRUE)) /
                  sum(!is.na(x$boundary))
              )
            },
            stringsAsFactors = FALSE
          )
        }
      )
    )
    rownames(parameter_summary) <- NULL
  }
  replication_summary <- data.frame()
  if (nrow(replication_diagnostics) > 0L) {
    groups <- split(
      x = replication_diagnostics,
      f = replication_diagnostics$output_type,
      drop = TRUE
    )
    replication_summary <- do.call(
      what = rbind,
      args = lapply(
        X = groups,
        FUN = function(x) {
          data.frame(
            taskid = x$taskid[1],
            output_type = x$output_type[1],
            method = x$method[1],
            replications_used = nrow(x),
            near_singular_rate = if (all(is.na(x$near_singular))) {
              NA_real_
            } else {
              mean(x$near_singular, na.rm = TRUE)
            },
            mcse_near_singular_rate = if (all(is.na(x$near_singular))) {
              NA_real_
            } else {
              sqrt(
                mean(x$near_singular, na.rm = TRUE) *
                  (1 - mean(x$near_singular, na.rm = TRUE)) /
                  sum(!is.na(x$near_singular))
              )
            },
            non_psd_rate = if (all(is.na(x$positive_semidefinite))) {
              NA_real_
            } else {
              mean(!x$positive_semidefinite, na.rm = TRUE)
            },
            any_near_zero_variance_rate = mean(x$any_near_zero_variance),
            any_boundary_variance_rate = if (
              all(is.na(x$any_boundary_variance))
            ) {
              NA_real_
            } else {
              mean(x$any_boundary_variance, na.rm = TRUE)
            },
            median_min_eigenvalue = if (all(is.na(x$min_eigenvalue))) {
              NA_real_
            } else {
              stats::median(
                x$min_eigenvalue,
                na.rm = TRUE
              )
            },
            stringsAsFactors = FALSE
          )
        }
      )
    )
    rownames(replication_summary) <- NULL
  }
  list(
    parameter_replications = parameter_replications,
    parameter_summary = parameter_summary,
    replication_diagnostics = replication_diagnostics,
    replication_summary = replication_summary
  )
}
