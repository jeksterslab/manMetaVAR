.CheckElapsedSeconds <- function(object) {
  if (is.null(object$elapsed)) {
    return(NA_real_)
  }
  out <- tryCatch(
    as.numeric(
      object$elapsed,
      units = "secs"
    ),
    error = function(e) {
      suppressWarnings(
        as.numeric(object$elapsed)
      )
    }
  )
  if (length(out) != 1L || !is.finite(out)) {
    return(NA_real_)
  }
  out
}

#' @keywords manMetaVAR check simulation internal
#' @noRd
.CheckFiniteSummary <- function(object) {
  raw <- tryCatch(
    suppressWarnings(
      summary(object)
    ),
    error = function(e) e
  )
  if (inherits(raw, "error")) {
    return(
      list(
        ok = FALSE,
        message = conditionMessage(raw)
      )
    )
  }
  raw <- as.matrix(raw)
  if (nrow(raw) < 1L || ncol(raw) < 1L) {
    return(
      list(
        ok = FALSE,
        message = "The fitted summary is empty."
      )
    )
  }
  columns <- intersect(
    c(
      "est",
      "se",
      "2.5%",
      "97.5%"
    ),
    colnames(raw)
  )
  if (length(columns) < 1L) {
    numeric_columns <- vapply(
      X = seq_len(ncol(raw)),
      FUN = function(j) {
        is.numeric(raw[, j])
      },
      FUN.VALUE = logical(1)
    )
    if (!any(numeric_columns)) {
      return(
        list(
          ok = FALSE,
          message = "The fitted summary has no numeric columns."
        )
      )
    }
    values <- raw[, numeric_columns, drop = FALSE]
  } else {
    values <- raw[, columns, drop = FALSE]
  }
  ok <- all(is.finite(values))
  list(
    ok = ok,
    message = if (ok) {
      NA_character_
    } else {
      "The fitted summary contains non-finite values."
    }
  )
}
