data_process_dsem_converged <- function(overwrite = FALSE,
                                        replications = 1000L) {
  cat("\ndata_process_dsem_converged\n")
  root <- rprojroot::is_rstudio_project
  data_folder <- root$find_file("data")
  data_external_folder <- root$find_file(
    ".setup",
    "data-external"
  )
  converged_file <- file.path(
    data_folder,
    "dsem_converged.rda"
  )
  if (file.exists(converged_file) && !overwrite) {
    return(invisible(converged_file))
  }
  # Moderate criterion of Supplement Table 2: every parameter of the
  # replication has finite diagnostics, R-hat <= 1.05, bulk and tail
  # ESS >= 100, and each MCSE relative to the posterior SD <= .10.
  threshold <- c(
    rhat = 1.05,
    ess = 100,
    mcse = 0.10
  )
  branches <- list(
    `BMLVAR-Default` = c(
      diagnostics = "diagnostics_default.rda",
      summary = "summary-fit-mplus"
    ),
    `BMLVAR-Priors` = c(
      diagnostics = "diagnostics_priors.rda",
      summary = "summary-fit-mplus-priors"
    )
  )
  pass_fn <- function(diagnostics_file) {
    data_environment <- new.env(
      parent = emptyenv()
    )
    load(
      file = file.path(
        data_folder,
        diagnostics_file
      ),
      envir = data_environment
    )
    parameters <- get(
      x = ls(data_environment)[1],
      envir = data_environment
    )$parameters
    rm(data_environment)
    ok <- is.finite(parameters$rhat) &
      parameters$rhat <= threshold["rhat"] &
      is.finite(parameters$ess_bulk) &
      parameters$ess_bulk >= threshold["ess"] &
      is.finite(parameters$ess_tail) &
      parameters$ess_tail >= threshold["ess"]
    for (i in c("mcse_mean", "mcse_median", "mcse_ll", "mcse_ul")) {
      relative <- parameters[[i]] / parameters$sd
      ok <- ok &
        is.finite(parameters$sd) &
        parameters$sd > 0 &
        is.finite(relative) &
        relative <= threshold["mcse"]
    }
    pass <- tapply(
      X = ok,
      INDEX = list(
        parameters$taskid,
        parameters$repid
      ),
      FUN = all
    )
    pass[is.na(pass)] <- FALSE
    pass
  }
  metrics_fn <- function(replication_list, keep) {
    est <- do.call(
      what = "cbind",
      args = lapply(replication_list, function(x) x$est)
    )
    hit <- do.call(
      what = "cbind",
      args = lapply(replication_list, function(x) x$theta_hit)
    )
    truth <- attr(replication_list[[1]], "parameter")
    error <- est - truth
    summarize <- function(columns) {
      if (sum(columns) == 0L) {
        return(
          list(
            bias = rep(NA_real_, length(truth)),
            rmse = rep(NA_real_, length(truth)),
            coverage = rep(NA_real_, length(truth))
          )
        )
      }
      list(
        bias = rowMeans(error[, columns, drop = FALSE], na.rm = TRUE),
        rmse = sqrt(rowMeans(error[, columns, drop = FALSE]^2, na.rm = TRUE)),
        coverage = rowMeans(hit[, columns, drop = FALSE], na.rm = TRUE)
      )
    }
    list(
      truth = truth,
      all = summarize(rep(TRUE, length(keep))),
      kept = summarize(keep)
    )
  }
  dsem_converged <- do.call(
    what = "rbind",
    args = lapply(
      X = names(branches),
      FUN = function(method) {
        pass <- pass_fn(branches[[method]]["diagnostics"])
        do.call(
          what = "rbind",
          args = lapply(
            X = as.integer(rownames(pass)),
            FUN = function(taskid) {
              summary_file <- file.path(
                data_external_folder,
                paste0(
                  "manMetaVAR-",
                  branches[[method]]["summary"],
                  "-",
                  sprintf("%05d", taskid),
                  "-",
                  sprintf("%05d", replications),
                  ".Rds"
                )
              )
              if (!file.exists(summary_file)) {
                stop(
                  paste0(
                    "Missing DSEM summary: ",
                    basename(summary_file),
                    "."
                  ),
                  call. = FALSE
                )
              }
              object <- readRDS(summary_file)
              keep <- unname(
                pass[as.character(taskid), as.character(object$repids)]
              )
              keep[is.na(keep)] <- FALSE
              metrics <- metrics_fn(
                replication_list = object$replications,
                keep = keep
              )
              first <- object$replications[[1]]
              data.frame(
                taskid = taskid,
                method = method,
                n = attr(first, "n"),
                time = attr(first, "time"),
                heterogeneity = attr(first, "heterogeneity"),
                replications = length(keep),
                replications_kept = sum(keep),
                parnames = attr(first, "parnames"),
                parameter = unname(metrics$truth),
                bias_all = unname(metrics$all$bias),
                rmse_all = unname(metrics$all$rmse),
                coverage_all = unname(metrics$all$coverage),
                bias_kept = unname(metrics$kept$bias),
                rmse_kept = unname(metrics$kept$rmse),
                coverage_kept = unname(metrics$kept$coverage),
                stringsAsFactors = FALSE
              )
            }
          )
        )
      }
    )
  )
  dsem_converged <- dsem_converged[
    order(
      dsem_converged$method,
      dsem_converged$heterogeneity,
      dsem_converged$taskid
    ), ,
    drop = FALSE
  ]
  rownames(dsem_converged) <- NULL
  save(
    dsem_converged,
    file = converged_file,
    compress = "xz"
  )
  invisible(converged_file)
}
data_process_dsem_converged()
rm(data_process_dsem_converged)
