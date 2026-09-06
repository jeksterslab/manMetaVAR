#' Align a Four-Variable Summary with Population Parameters
#'
#' @param raw Fitted summary matrix.
#' @param heterogeneity Numeric scalar.
#' @param population_object Four-variable population data object.
#'
#' @return A list containing the aligned summary matrix, population vector,
#'   and population condition.
#'
#' @keywords manMetaVAR summary simulation internal
#' @noRd
.SumAlignPopulationK4 <- function(
    raw,
    heterogeneity,
    population_object = populationk4) {
  condition <- .SumPopulationCondition(
    heterogeneity = heterogeneity,
    population_object = population_object
  )
  parameter <- .SumPopulationParameterK4(
    heterogeneity = heterogeneity,
    population_object = population_object
  )
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
        "Four-variable population parameters were not found in the fitted ",
        "summary: ",
        paste(missing, collapse = ", "),
        "."
      ),
      call. = FALSE
    )
  }
  raw <- raw[
    names(parameter),
    ,
    drop = FALSE
  ]
  list(
    raw = raw,
    parameter = parameter,
    condition = condition
  )
}
