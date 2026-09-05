.SumAlignPopulation <- function(raw,
                                heterogeneity,
                                population_object = population) {
  condition <- .SumPopulationCondition(
    heterogeneity = heterogeneity,
    population_object = population_object
  )
  parameter <- condition$parameter

  if (
    is.null(names(parameter)) ||
      anyDuplicated(names(parameter))
  ) {
    stop(
      "Population parameter names must be present and unique.",
      call. = FALSE
    )
  }

  if (any(!is.finite(parameter))) {
    stop(
      "Population parameter values must be finite.",
      call. = FALSE
    )
  }

  if (is.null(rownames(raw))) {
    stop(
      "The fitted summary does not have parameter names.",
      call. = FALSE
    )
  }

  if (anyDuplicated(rownames(raw))) {
    stop(
      "The fitted summary has duplicated parameter names.",
      call. = FALSE
    )
  }

  missing <- setdiff(
    names(parameter),
    rownames(raw)
  )

  if (length(missing) > 0L) {
    stop(
      paste0(
        "Population parameters were not found in the fitted summary: ",
        paste(missing, collapse = ", "),
        "."
      ),
      call. = FALSE
    )
  }

  raw <- raw[
    names(parameter), ,
    drop = FALSE
  ]

  list(
    raw = raw,
    parameter = parameter,
    condition = condition
  )
}
