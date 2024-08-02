#' Simulation Replication
#'
#' @author Ivan Jacob Agaloos Pesigan
#'
#' @return The output is saved as an external file in `output_folder`.
#'
#' @inheritParams Template
#' @export
#' @keywords manMetaVAR simulation
Sim <- function(taskid,
                repid,
                output_folder,
                overwrite,
                integrity,
                params_taskid) {
  # Do not include default arguments here.
  # All arguments should be set in `sim/sim-args.R`.
  # Add taskid to output_folder
  output_folder <- file.path(
    output_folder,
    paste0(
      SimProj(),
      "-",
      sprintf(
        "%05d",
        taskid
      )
    )
  )
  if (!file.exists(output_folder)) {
    dir.create(
      path = output_folder,
      showWarnings = FALSE,
      recursive = TRUE
    )
    .SimChMod(output_folder)
  }
  seed <- .SimSeed(
    taskid = taskid,
    repid = repid
  )
  suffix <- .SimSuffix(
    taskid = taskid,
    repid = repid
  )
  error <- FALSE
  tryCatch(
    {
      SimGenData(
        taskid = taskid,
        repid = repid,
        output_folder = output_folder,
        params_taskid = params_taskid,
        seed = seed,
        suffix = suffix,
        overwrite = overwrite,
        integrity = integrity
      )
    },
    error = function(cond) {
      message(paste("error:", "SimGenData"))
      message("Here's the original error message:")
      message(conditionMessage(cond))
      error <- TRUE
    },
    warning = function(cond) {
      message(paste("warning:", "SimGenData"))
      message("Here's the original warning message:")
      message(conditionMessage(cond))
    }
  )
  tryCatch(
    {
      SimFitDTVARMx(
        taskid = taskid,
        repid = repid,
        output_folder = output_folder,
        seed = seed,
        suffix = suffix,
        overwrite = overwrite,
        integrity = integrity
      )
    },
    error = function(cond) {
      message(paste("error:", "SimFitDTVARMx"))
      message("Here's the original error message:")
      message(conditionMessage(cond))
      error <- TRUE
    },
    warning = function(cond) {
      message(paste("warning:", "SimFitDTVARMx"))
      message("Here's the original warning message:")
      message(conditionMessage(cond))
    }
  )
  tryCatch(
    {
      SimFitMLVAR(
        taskid = taskid,
        repid = repid,
        output_folder = output_folder,
        seed = seed,
        suffix = suffix,
        overwrite = overwrite,
        integrity = integrity
      )
    },
    error = function(cond) {
      message(paste("error:", "SimFitMLVAR"))
      message("Here's the original error message:")
      message(conditionMessage(cond))
      error <- TRUE
    },
    warning = function(cond) {
      message(paste("warning:", "SimFitMLVAR"))
      message("Here's the original warning message:")
      message(conditionMessage(cond))
    }
  )
  tryCatch(
    {
      SimFitMetaVARMx(
        taskid = taskid,
        repid = repid,
        output_folder = output_folder,
        seed = seed,
        suffix = suffix,
        overwrite = overwrite,
        integrity = integrity
      )
    },
    error = function(cond) {
      message(paste("error:", "SimFitMetaVARMx"))
      message("Here's the original error message:")
      message(conditionMessage(cond))
      error <- TRUE
    },
    warning = function(cond) {
      message(paste("warning:", "SimFitMetaVARMx"))
      message("Here's the original warning message:")
      message(conditionMessage(cond))
    }
  )
  if (error) {
    stop()
  }
}
