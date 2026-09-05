.TrimMplusFactorScoreRows <- function(draws,
                                      fscores = NULL,
                                      iter = NULL) {
  if (is.null(fscores)) {
    return(draws)
  }
  fscores <- suppressWarnings(
    as.integer(fscores)
  )
  if (length(fscores) != 1L || is.na(fscores) || fscores < 0L) {
    stop(
      "`object$args$fscores` should be a nonnegative integer or `NULL`.",
      call. = FALSE
    )
  }
  if (fscores == 0L) {
    return(draws)
  }
  iter_valid <- !is.null(iter) &&
    length(iter) == 1L &&
    is.numeric(iter) &&
    is.finite(iter) &&
    iter >= 1 &&
    iter == floor(iter)
  if (iter_valid) {
    iter <- as.integer(iter)
    factor_score_rows <- draws[, 2L] > iter
    n_factor_score_rows <- sum(factor_score_rows)
    if (n_factor_score_rows != fscores) {
      stop(
        paste0(
          "Expected ",
          fscores,
          " factor-score iteration rows after iteration ",
          iter,
          " but found ",
          n_factor_score_rows,
          "."
        ),
        call. = FALSE
      )
    }
    return(
      draws[
        !factor_score_rows, ,
        drop = FALSE
      ]
    )
  }
  if (fscores >= nrow(draws)) {
    stop(
      paste(
        "The number of factor-score rows",
        "is not smaller than the number of saved rows."
      ),
      call. = FALSE
    )
  }
  draws[
    seq_len(nrow(draws) - fscores), ,
    drop = FALSE
  ]
}
