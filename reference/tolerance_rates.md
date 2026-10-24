# Tolerance Rates for Transition Heterogeneity

Proportions of replications in which the estimate or interval of a
between-person variance or covariance of the transition parameters falls
within or beyond a tolerance \\(\delta\\), computed with
[`SumTolerance()`](https://github.com/jeksterslab/manMetaVAR/reference/SumTolerance.md)
from the replication-level simulation summaries.

## Usage

``` r
data(tolerance_rates)
```

## Format

A data frame with one row per design condition, method, interval type,
parameter, and tolerance:

- taskid:

  Simulation task ID.

- replications:

  Number of replications.

- replications_used:

  Number of admissible replications.

- method:

  Estimation method, labeled as in
  [results](https://github.com/jeksterslab/manMetaVAR/reference/results.md).

- ci:

  Confidence or credible interval method.

- n:

  Number of persons.

- time:

  Number of measurement occasions; `NA` denotes the unbalanced
  condition.

- heterogeneity:

  Transition-parameter heterogeneity multiplier: 0, 1, or 2.

- parnames:

  Parameter name.

- parameter:

  Population value.

- type:

  `"variance"` or `"covariance"`.

- delta:

  Tolerance.

- est_within:

  Proportion of estimates within the tolerance.

- equivalent:

  Proportion of intervals within the tolerance (practical homogeneity).

- exceed:

  Proportion of intervals beyond the tolerance (heterogeneity beyond the
  tolerance).

## Author

Ivan Jacob Agaloos Pesigan
