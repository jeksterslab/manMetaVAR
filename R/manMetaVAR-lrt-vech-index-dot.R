.LRTVechIndex <- function(p) {
  # Row and column positions of the lower triangle of a p x p matrix,
  # column-wise (the order of vech and of the v columns in metaDyn data).
  idx <- which(
    lower.tri(
      diag(p),
      diag = TRUE
    ),
    arr.ind = TRUE
  )
  idx[order(idx[, "col"], idx[, "row"]), , drop = FALSE]
}
