#' Summary: MetaVAR Boundary Likelihood Ratio Test
#'
#' Applies [LRTMetaVAR()] to every admissible MetaVAR replication of a
#' task and summarizes the rejection rates at \eqn{\alpha = .05}.
#'
#' @details This function is executed via the `Sum` function.
#'
#' @author Ivan Jacob Agaloos Pesigan
#'
#' @return The output is saved as an external file in `output_folder`.
#'
#' @inheritParams Template
#' @export
#' @keywords manMetaVAR summary simulation
SumFitMetaVARLRT <- function(taskid,
                             reps,
                             output_folder,
                             overwrite,
                             integrity,
                             ncores) {
  # Do not include default arguments here.
  # Do not run on its own. Use the `Sum` function.
  fn_output <- SimFN(
    output_type = "summary-fit-meta-var-mx-lrt",
    output_folder = output_folder,
    suffix = paste0(
      sprintf(
        "%05d",
        taskid
      ),
      "-",
      sprintf(
        "%05d",
        reps
      ),
      ".Rds"
    )
  )
  run <- .SimCheck(
    fn = fn_output,
    overwrite = overwrite,
    integrity = integrity
  )
  if (run) {
    repids <- .SumValidRepids(
      taskid = taskid,
      reps = reps,
      output_folder = output_folder,
      output_type = "fit-meta-var-mx"
    )
    reps_used <- length(repids)
    if (reps_used < 2L) {
      stop(
        paste0(
          "At least two admissible replications are required for ",
          "fit-meta-var-mx; found ",
          reps_used,
          "."
        ),
        call. = FALSE
      )
    }
    replication <- function(repid,
                            taskid) {
      fn_input <- SimFN(
        output_type = "fit-meta-var-mx",
        output_folder = output_folder,
        suffix = .SimSuffix(
          taskid = taskid,
          repid = repid
        )
      )
      cbind(
        taskid = taskid,
        repid = repid,
        LRTMetaVAR(
          fit = readRDS(fn_input),
          draws = 2000L,
          seed = taskid * 1e5 + repid
        )
      )
    }
    if (is.null(ncores)) {
      par <- FALSE
    } else {
      ncores <- min(
        as.integer(ncores),
        parallel::detectCores(),
        reps_used
      )
      par <- ncores > 1
    }
    if (par) {
      i <- parallel::mclapply(
        X = repids,
        FUN = replication,
        taskid = taskid,
        mc.cores = ncores
      )
    } else {
      i <- lapply(
        X = repids,
        FUN = replication,
        taskid = taskid
      )
    }
    replications <- do.call(
      what = "rbind",
      args = i
    )
    param <- params[taskid, ]
    means <- data.frame(
      taskid = taskid,
      replications = reps,
      replications_used = reps_used,
      method = "MetaVAR",
      n = param$n,
      time = param$time,
      heterogeneity = param$heterogeneity,
      df = replications$df[1],
      negative_stat = sum(replications$stat < -1e-6),
      null_status_nonzero = sum(replications$status_null != 0),
      reject_chibar = mean(replications$p_chibar < 0.05),
      reject_chisq = mean(replications$p_chisq < 0.05),
      crit_chibar = stats::median(replications$crit_chibar)
    )
    output <- list(
      repids = repids,
      replications = replications,
      means = means
    )
    saveRDS(
      object = output,
      file = fn_output,
      compress = "xz"
    )
    .SimChMod(fn_output)
  }
}
