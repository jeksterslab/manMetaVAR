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
  sim_1 <- tryCatch(
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
      return(TRUE)
    },
    error = function(cond) {
      message(paste("error:", "SimGenData"))
      message("Here's the original error message:")
      message(conditionMessage(cond))
      return(FALSE)
    },
    warning = function(cond) {
      message(paste("warning:", "SimGenData"))
      message("Here's the original warning message:")
      message(conditionMessage(cond))
      return(FALSE)
    }
  )
  sim_2 <- tryCatch(
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
      return(TRUE)
    },
    error = function(cond) {
      message(paste("error:", "SimFitDTVARMx"))
      message("Here's the original error message:")
      message(conditionMessage(cond))
      return(FALSE)
    },
    warning = function(cond) {
      message(paste("warning:", "SimFitDTVARMx"))
      message("Here's the original warning message:")
      message(conditionMessage(cond))
      return(FALSE)
    }
  )
  sim_3 <- tryCatch(
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
      return(TRUE)
    },
    error = function(cond) {
      message(paste("error:", "SimFitMLVAR"))
      message("Here's the original error message:")
      message(conditionMessage(cond))
      return(FALSE)
    },
    warning = function(cond) {
      message(paste("warning:", "SimFitMLVAR"))
      message("Here's the original warning message:")
      message(conditionMessage(cond))
      return(FALSE)
    }
  )
  sim_4 <- tryCatch(
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
      return(TRUE)
    },
    error = function(cond) {
      message(paste("error:", "SimFitMetaVARMx"))
      message("Here's the original error message:")
      message(conditionMessage(cond))
      return(FALSE)
    },
    warning = function(cond) {
      message(paste("warning:", "SimFitMetaVARMx"))
      message("Here's the original warning message:")
      message(conditionMessage(cond))
      return(FALSE)
    }
  )
  stopifnot(
    all(
      sim_1,
      sim_2,
      sim_3,
      sim_4
    )
  )
}
