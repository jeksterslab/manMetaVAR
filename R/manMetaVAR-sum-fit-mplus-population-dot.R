#' Align an Mplus Summary with Population Parameters
#'
#' @param raw Mplus summary matrix.
#' @param heterogeneity Numeric scalar.
#' @param population_object Population data object.
#'
#' @return A list containing the aligned summary matrix and population vector.
#'
#' @keywords manMetaVAR summary simulation internal
#' @noRd
.SumFitMplusPopulation <- function(raw,
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
  beta_k <- nrow(condition$beta_mu)
  if (
    length(beta_k) != 1L ||
      is.na(beta_k) ||
      beta_k != k ||
      ncol(condition$beta_mu) != k
  ) {
    stop(
      "The population beta mean must be a square matrix compatible with mu.",
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
  covariance_names <- function(x) {
    location <- which(
      lower.tri(
        x = matrix(
          data = FALSE,
          nrow = length(x),
          ncol = length(x)
        ),
        diag = TRUE
      ),
      arr.ind = TRUE
    )
    paste0(
      "cov(",
      x[location[, "row"]],
      ",",
      x[location[, "col"]],
      ")"
    )
  }
  mplus_names <- c(
    paste0(
      "mean(",
      c(mu_names, beta_names),
      ")"
    ),
    covariance_names(mu_names),
    covariance_names(beta_names)
  )
  mplus_names <- gsub(
    pattern = "[[:space:]]+",
    replacement = "",
    x = mplus_names
  )
  if (length(mplus_names) != length(parameter)) {
    stop(
      paste0(
        "The Mplus-to-population mapping has ",
        length(mplus_names),
        " parameters, but the population vector has ",
        length(parameter),
        "."
      ),
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
        "The following Mplus parameters were not found: ",
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
