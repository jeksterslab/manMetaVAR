## ---- test-manMetaVAR-tolerance
lapply(
  X = 1,
  FUN = function(i,
                 text) {
    message(text)
    out <- Tolerance(
      est = c(0.0002, 0.01, -0.0005, 0.003),
      ll = c(0, 0.004, -0.0008, 0.002),
      ul = c(0.0008, 0.02, 0.0007, 0.004),
      variance = c(TRUE, TRUE, FALSE, FALSE),
      delta = 0.0009
    )
    testthat::test_that(
      paste(text, "variances"),
      {
        testthat::expect_equal(
          out$est_within[1:2],
          c(TRUE, FALSE)
        )
        testthat::expect_equal(
          out$equivalent[1:2],
          c(TRUE, FALSE)
        )
        testthat::expect_equal(
          out$exceed[1:2],
          c(FALSE, TRUE)
        )
      }
    )
    testthat::test_that(
      paste(text, "covariances"),
      {
        testthat::expect_equal(
          out$equivalent[3:4],
          c(TRUE, FALSE)
        )
        testthat::expect_equal(
          out$exceed[3:4],
          c(FALSE, TRUE)
        )
      }
    )
  },
  text = "test-manMetaVAR-tolerance"
)
