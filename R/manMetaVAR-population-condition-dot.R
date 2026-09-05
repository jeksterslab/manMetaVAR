.PopulationCondition <- function(heterogeneity) {
  hit <- vapply(
    X = population$conditions,
    FUN = function(x) {
      isTRUE(
        all.equal(
          x$heterogeneity,
          heterogeneity
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

  population$conditions[[which(hit)]]
}
