#' Summary: Calibration of Stage 1 Sampling Variances
#'
#' For each admissible MetaVAR replication of a task, computes the ratio of
#' the between-person variance of the Stage 1 transition estimates to the
#' mean Stage 1 sampling variance.
#' Under zero transition heterogeneity, a ratio of one means that the
#' Stage 1 sampling variances are calibrated;
#' a ratio above one means that they are too small.
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
SumStage1Calibration <- function(taskid,
                                 reps,
                                 output_folder,
                                 overwrite,
                                 integrity,
                                 ncores) {
  # Do not include default arguments here.
  # Do not run on its own. Use the `Sum` function.
  fn_output <- SimFN(
    output_type = "summary-stage-1-calibration",
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
    # Transition parameters are positions 3 to 6 of the Stage 2 data.
    positions <- 3:6
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
      mx <- readRDS(fn_input)$output$output
      observed <- mx$data$observed
      data.frame(
        taskid = taskid,
        repid = repid,
        position = positions,
        between_var = vapply(
          X = positions,
          FUN = function(j) {
            stats::var(observed[[paste0("y", j)]])
          },
          FUN.VALUE = numeric(1)
        ),
        mean_sampling_var = vapply(
          X = positions,
          FUN = function(j) {
            mean(observed[[paste0("v", j, j)]])
          },
          FUN.VALUE = numeric(1)
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
    replications$ratio <- replications$between_var /
      replications$mean_sampling_var
    param <- params[taskid, ]
    means <- stats::aggregate(
      x = replications[
        ,
        c("between_var", "mean_sampling_var", "ratio")
      ],
      by = list(
        position = replications$position
      ),
      FUN = mean
    )
    means <- data.frame(
      taskid = taskid,
      replications = reps,
      replications_used = reps_used,
      n = param$n,
      time = param$time,
      heterogeneity = param$heterogeneity,
      means
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
