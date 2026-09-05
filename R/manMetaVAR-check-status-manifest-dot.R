#' Build and Persist a Simulation Status Manifest
#'
#' Builds the status manifest for one simulation replication by applying
#' [`.CheckStatusRow()`] to every requested method and stage. The manifest is
#' persisted before the higher-level status gate is applied so that diagnostic
#' information remains available even when a repair-required failure is found.
#'
#' @author Ivan Jacob Agaloos Pesigan
#'
#' @inheritParams Template
#' @param k4 Logical. If `TRUE`, build the manifest for the four-variable
#'   feasibility simulation; otherwise build the two-variable manifest.
#'
#' @return The status-manifest data frame, invisibly. Returns `NULL` invisibly
#'   when no methods are requested. The manifest is also saved as the
#'   replication-specific `status` or `status-k4` simulation artifact.
#'
#' @keywords manMetaVAR internal simulation check
#' @noRd
.CheckStatusManifest <- function(taskid,
                                 repid,
                                 output_folder,
                                 suffix,
                                 naive,
                                 metavar,
                                 mplus,
                                 k4 = FALSE) {
  specifications <- list()
  if (metavar || naive) {
    specifications[[length(specifications) + 1L]] <- list(
      output_type = if (k4) {
        "fit-dt-var-mx-k4"
      } else {
        "fit-dt-var-mx"
      },
      method = "Stage 1",
      stage = "Stage 1"
    )
  }
  if (metavar) {
    specifications[[length(specifications) + 1L]] <- list(
      output_type = if (k4) {
        "fit-meta-var-mx-k4"
      } else {
        "fit-meta-var-mx"
      },
      method = "MetaVAR",
      stage = "Stage 2"
    )
  }
  if (naive && !k4) {
    specifications[[length(specifications) + 1L]] <- list(
      output_type = "fit-naive",
      method = "Uncertainty-Uncorrected",
      stage = "Stage 2"
    )
  }
  if (mplus) {
    specifications[[length(specifications) + 1L]] <- list(
      output_type = if (k4) {
        "fit-mplus-k4"
      } else {
        "fit-mplus"
      },
      method = "Mplus DSEM Default",
      stage = "Joint"
    )
    specifications[[length(specifications) + 1L]] <- list(
      output_type = if (k4) {
        "fit-mplus-k4-priors"
      } else {
        "fit-mplus-priors"
      },
      method = "Mplus DSEM Alternative Priors",
      stage = "Joint"
    )
  }
  if (length(specifications) < 1L) {
    return(invisible(NULL))
  }
  status <- do.call(
    what = rbind,
    args = lapply(
      X = specifications,
      FUN = function(specification) {
        .CheckStatusRow(
          taskid = taskid,
          repid = repid,
          output_folder = output_folder,
          suffix = suffix,
          output_type = specification$output_type,
          method = specification$method,
          stage = specification$stage,
          k = if (k4) 4L else 2L
        )
      }
    )
  )
  fn_output <- SimFN(
    output_type = if (k4) {
      "status-k4"
    } else {
      "status"
    },
    output_folder = output_folder,
    suffix = suffix
  )
  saveRDS(
    object = status,
    file = fn_output,
    compress = FALSE
  )
  .SimChMod(fn_output)
  invisible(status)
}
