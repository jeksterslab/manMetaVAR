## ---- test-manMetaVAR-lrt-meta-var
lapply(
  X = 1,
  FUN = function(i,
                 text) {
    message(text)
    testthat::test_that(
      paste(text, "vech order"),
      {
        testthat::expect_equal(
          unname(.LRTVechIndex(3)),
          matrix(
            data = c(1, 2, 3, 2, 3, 3, 1, 1, 1, 2, 2, 3),
            ncol = 2
          )
        )
      }
    )
    testthat::test_that(
      paste(text, "chi-bar k = 1"),
      {
        # For one variance the projection is max(z, 0), so the statistic
        # is m * max(z, 0)^2: a 50:50 mixture of chi-square 0 and 1.
        z <- matrix(
          data = c(-1.5, -0.2, 0.3, 1.2, 2.5),
          nrow = 1
        )
        m <- matrix(2)
        testthat::expect_equal(
          .ChiBarDraws(
            zu = z,
            m = m,
            k = 1L,
            maxit = 2000L,
            tol = 1e-12
          ),
          c(2 * pmax(z, 0)^2),
          tolerance = 1e-8
        )
      }
    )
    testthat::test_that(
      paste(text, "chi-bar p-value"),
      {
        out <- .LRTChiBar(
          stat = 2.705543,
          info = matrix(1),
          k = 1L,
          draws = 20000L,
          seed = 42
        )
        testthat::expect_equal(
          out$crit,
          stats::qchisq(0.90, df = 1),
          tolerance = 0.05
        )
        testthat::expect_equal(
          out$p,
          0.05,
          tolerance = 0.1
        )
      }
    )
  },
  text = "test-manMetaVAR-lrt-meta-var"
)
