#' Load Both Prior Conditions of the Bundled Mplus Diagnostics
#'
#' Loads and combines `diagnostics_default` and `diagnostics_priors` for
#' diagnostic plots and comparisons between prior specifications.
#'
#' @return A `manmetavar.mplus.diagnostics.all` object containing parameter
#'   and run diagnostics for both prior conditions, in the original combined
#'   task, method, replication, and parameter order.
#' @examples
#' \dontrun{
#' diagnostics <- LoadMplusDiagnostics()
#' FigMplusDiagnosticsHeatmap(diagnostics, comparison = "difference")
#' }
#' @keywords data diagnostics simulation
#' @export
LoadMplusDiagnostics <- function() {
  data_environment <- new.env(
    parent = emptyenv()
  )

  utils::data(
    list = c(
      "diagnostics_default",
      "diagnostics_priors"
    ),
    package = "manMetaVAR",
    envir = data_environment
  )

  .CombineMplusDiagnostics(
    data_environment$diagnostics_default,
    data_environment$diagnostics_priors
  )
}

.CombineMplusDiagnostics <- function(default,
                                     priors) {
  bundles <- list(
    default,
    priors
  )

  if (
    !all(
      vapply(
        bundles,
        inherits,
        logical(1),
        what = "manmetavar.mplus.diagnostics.all"
      )
    ) ||
      !identical(
        default$replications,
        priors$replications
      )
  ) {
    stop(
      paste(
        "Both diagnostic bundles must be present and",
        "have matching replication counts."
      ),
      call. = FALSE
    )
  }

  result <- default

  for (
    table in c(
      "parameters",
      "runs"
    )
  ) {
    if (
      !identical(
        names(default[[table]]),
        names(priors[[table]])
      ) ||
        anyNA(default[[table]]$default_priors) ||
        anyNA(priors[[table]]$default_priors) ||
        !all(default[[table]]$default_priors) ||
        any(priors[[table]]$default_priors)
    ) {
      stop(
        paste(
          "Diagnostic bundles have incompatible columns",
          "or prior labels."
        ),
        call. = FALSE
      )
    }

    x <- rbind(
      default[[table]],
      priors[[table]]
    )

    keys <- c(
      "heterogeneity",
      "taskid",
      "method",
      "repid"
    )

    if (table == "parameters") {
      keys <- c(
        keys,
        "par_idx"
      )
    }

    x <- x[
      do.call(
        order,
        unname(x[keys])
      ), ,
      drop = FALSE
    ]

    rownames(x) <- NULL
    result[[table]] <- x
  }

  result
}
