.SumBoundaryAligned <- function(object,
                                output_type,
                                heterogeneity,
                                k4 = FALSE) {
  raw <- summary(object)
  if (
    output_type %in% c(
      "fit-mplus",
      "fit-mplus-priors",
      "fit-mplus-k4",
      "fit-mplus-k4-priors"
    )
  ) {
    if (k4) {
      return(
        .SumFitMplusPopulationK4(
          raw = raw,
          heterogeneity = heterogeneity
        )
      )
    }
    return(
      .SumFitMplusPopulation(
        raw = raw,
        heterogeneity = heterogeneity
      )
    )
  }
  if (k4) {
    .SumAlignPopulationK4(
      raw = raw,
      heterogeneity = heterogeneity
    )
  } else {
    .SumAlignPopulation(
      raw = raw,
      heterogeneity = heterogeneity
    )
  }
}
