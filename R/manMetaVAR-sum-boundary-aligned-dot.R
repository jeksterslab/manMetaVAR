.SumBoundaryAligned <- function(object,
                                output_type,
                                heterogeneity) {
  raw <- summary(object)
  if (
    output_type %in% c(
      "fit-mplus",
      "fit-mplus-priors"
    )
  ) {
    return(
      .SumFitMplusPopulation(
        raw = raw,
        heterogeneity = heterogeneity
      )
    )
  }
  .SumAlignPopulation(
    raw = raw,
    heterogeneity = heterogeneity
  )
}
