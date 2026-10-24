.LRTChiBar <- function(stat,
                       info,
                       k,
                       draws,
                       seed) {
  # Simulated chi-bar-square reference distribution for the boundary LRT:
  # z ~ N(0, info^{-1}) projected onto PSD(k) x R^(q - k(k + 1) / 2)
  # in the metric `info` (Self & Liang, 1987; Shapiro, 1985).
  if (!is.null(seed)) {
    set.seed(seed)
  }
  vech_block <- .LRTVechIndex(k)
  dvec <- c(
    ifelse(
      test = vech_block[, 1] == vech_block[, 2],
      yes = 1,
      no = sqrt(2)
    ),
    rep(
      x = 1,
      times = nrow(info) - nrow(vech_block)
    )
  )
  z <- t(
    matrix(
      data = stats::rnorm(draws * nrow(info)),
      nrow = draws
    ) %*% chol(solve(info))
  )
  sim <- .ChiBarDraws(
    zu = z * dvec,
    m = info / outer(dvec, dvec),
    k = k,
    maxit = 2000L,
    tol = 1e-10
  )
  list(
    p = (1 + sum(sim >= stat)) / (draws + 1),
    crit = unname(
      stats::quantile(
        x = sim,
        probs = 0.95
      )
    )
  )
}
