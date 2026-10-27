# Boundary Likelihood Ratio Test in the Simulation

Rejection rates of the MetaVAR boundary likelihood ratio test
([`LRTMetaVAR()`](https://github.com/jeksterslab/manMetaVAR/reference/LRTMetaVAR.md))
of zero transition heterogeneity in each simulation condition, at
\\(\alpha = .05\\), with the simulated chi-bar-square and the naive
chi-square references. At zero heterogeneity, the rejection rates are
Type I error rates; otherwise, they are power.

## Usage

``` r
data(lrt)
```

## Format

A data frame with one row per task ID:

- taskid:

  Simulation task ID.

- replications:

  Number of replications.

- replications_used:

  Number of admissible MetaVAR replications.

- method:

  `"MetaVAR"`.

- n:

  Number of persons.

- time:

  Number of measurement occasions; `NA` denotes the unbalanced
  condition.

- heterogeneity:

  Transition-parameter heterogeneity multiplier.

- df:

  Number of tested parameters.

- negative_stat:

  Number of replications with a statistic below \\(-10^{-6}\\).

- null_status_nonzero:

  Number of replications whose null fit had a nonzero status code.

- reject_chibar:

  Rejection rate with the chi-bar-square reference.

- reject_chisq:

  Rejection rate with the chi-square reference.

- crit_chibar:

  Median simulated 95th percentile of the chi-bar-square reference.

## Author

Ivan Jacob Agaloos Pesigan
