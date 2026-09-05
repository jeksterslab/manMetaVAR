#' Identify a Population Condition
#'
#' @param heterogeneity Numeric scalar.
#'
#' @param population_object Population data object.
#'
#' @return A condition from the `population` data object.
#'
#' @keywords manMetaVAR summary simulation internal
#' @noRd
.SumPopulationCondition <- function(heterogeneity,
                                    population_object = population) {
  hit <- vapply(
    X = population_object$conditions,
    FUN = function(x) {
      isTRUE(
        all.equal(
          target = x$heterogeneity,
          current = heterogeneity
        )
      )
    },
    FUN.VALUE = logical(1)
  )
  if (sum(hit) != 1L) {
    stop(
      paste0(
        "Could not identify a unique population condition for ",
        "heterogeneity = ",
        heterogeneity,
        "."
      ),
      call. = FALSE
    )
  }
  population_object$conditions[[which(hit)]]
}
