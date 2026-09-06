#' Align a Four-Variable Mplus Summary with Population Parameters
#'
#' @param raw Mplus summary matrix.
#' @param heterogeneity Numeric scalar.
#' @param population_object Four-variable population data object.
#'
#' @return A list containing the aligned summary matrix, population vector,
#'   and population condition.
#'
#' @keywords manMetaVAR summary simulation internal
#' @noRd
.SumFitMplusPopulationK4 <- function(raw,
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
      "The Mplus summary does not have parameter names.",
      call. = FALSE
    )
  }
  raw_names <- gsub(
    pattern = "[[:space:]]+",
    replacement = "",
    x = rownames(raw)
  )
  if (anyDuplicated(raw_names)) {
    stop(
      "The Mplus summary has duplicated parameter names.",
      call. = FALSE
    )
  }
  k <- length(condition$mu_mu)
  if (
    length(k) != 1L ||
      is.na(k) ||
      k != 4L ||
      !is.matrix(condition$beta_mu) ||
      nrow(condition$beta_mu) != k ||
      ncol(condition$beta_mu) != k
  ) {
    stop(
      "The four-variable population condition has incompatible dimensions.",
      call. = FALSE
    )
  }
  mu_names <- paste0(
    "mu[",
    seq_len(k),
    ",1]"
  )
  beta_names <- paste0(
    "beta[",
    rep(seq_len(k), times = k),
    ",",
    rep(seq_len(k), each = k),
    "]"
  )
  random_names <- c(
    mu_names,
    beta_names
  )
  mplus_names <- c(
    paste0(
      "mean(",
      random_names,
      ")"
    ),
    paste0(
      "cov(",
      random_names,
      ",",
      random_names,
      ")"
    )
  )
  mplus_names <- gsub(
    pattern = "[[:space:]]+",
    replacement = "",
    x = mplus_names
  )
  if (length(mplus_names) != length(parameter)) {
    stop(
      "The four-variable Mplus mapping and population vector differ in length.",
      call. = FALSE
    )
  }
  location <- match(
    x = mplus_names,
    table = raw_names
  )
  if (anyNA(location)) {
    stop(
      paste0(
        "The following four-variable Mplus parameters were not found: ",
        paste(
          mplus_names[is.na(location)],
          collapse = ", "
        ),
        "."
      ),
      call. = FALSE
    )
  }
  raw <- raw[
    location, ,
    drop = FALSE
  ]
  rownames(raw) <- names(parameter)
  list(
    raw = raw,
    parameter = parameter,
    condition = condition
  )
}
