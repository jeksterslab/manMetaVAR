.LRTInformation <- function(tau_sqr,
                            v,
                            block,
                            others,
                            cross) {
  # Efficient Fisher information of the tested elements of `tau_sqr`
  # (vech of the `block` submatrix, then the block-by-others covariances
  # when `cross = TRUE`), adjusted for vech of the `others` submatrix.
  # The model is y_i ~ N(alpha, tau_sqr + v_i), so
  # I_jk = 0.5 * sum_i tr(S_i^{-1} E_j S_i^{-1} E_k), S_i = tau_sqr + v_i.
  p <- nrow(tau_sqr)
  unit <- function(i, j) {
    e <- matrix(
      data = 0,
      nrow = p,
      ncol = p
    )
    e[i, j] <- 1
    e[j, i] <- 1
    e
  }
  vech_block <- .LRTVechIndex(length(block))
  vech_others <- .LRTVechIndex(length(others))
  e <- c(
    lapply(
      X = seq_len(nrow(vech_others)),
      FUN = function(a) {
        unit(
          others[vech_others[a, 1]],
          others[vech_others[a, 2]]
        )
      }
    ),
    lapply(
      X = seq_len(nrow(vech_block)),
      FUN = function(a) {
        unit(
          block[vech_block[a, 1]],
          block[vech_block[a, 2]]
        )
      }
    )
  )
  if (cross) {
    pairs <- expand.grid(
      i = block,
      j = others
    )
    e <- c(
      e,
      lapply(
        X = seq_len(nrow(pairs)),
        FUN = function(a) {
          unit(
            pairs$i[a],
            pairs$j[a]
          )
        }
      )
    )
  }
  q <- length(e)
  info <- matrix(
    data = 0,
    nrow = q,
    ncol = q
  )
  for (v_i in v) {
    s_inv <- solve(tau_sqr + v_i)
    a <- lapply(
      X = e,
      FUN = function(e_j) {
        s_inv %*% e_j
      }
    )
    for (j in seq_len(q)) {
      for (k in seq_len(j)) {
        info[j, k] <- info[j, k] + 0.5 * sum(a[[j]] * t(a[[k]]))
      }
    }
  }
  info[upper.tri(info)] <- t(info)[upper.tri(info)]
  nuisance <- seq_len(nrow(vech_others))
  info[-nuisance, -nuisance] - info[-nuisance, nuisance] %*%
    solve(info[nuisance, nuisance]) %*% info[nuisance, -nuisance]
}
