# Calibration of Stage 1 Sampling Variances in the Simulation

For each simulation condition and transition parameter, the
between-person variance of the Stage 1 estimates, the mean Stage 1
sampling variance, and their ratio, averaged over admissible MetaVAR
replications
([`SumStage1Calibration()`](https://github.com/jeksterslab/manMetaVAR/reference/SumStage1Calibration.md)).
Under zero transition heterogeneity, a ratio of one means that the Stage
1 sampling variances are calibrated; a ratio above one means that they
are too small.

## Usage

``` r
data(calibration)
```

## Format

A data frame with one row per task ID and transition parameter:

- taskid:

  Simulation task ID.

- replications:

  Number of replications.

- replications_used:

  Number of admissible MetaVAR replications.

- n:

  Number of persons.

- time:

  Number of measurement occasions; `NA` denotes the unbalanced
  condition.

- heterogeneity:

  Transition-parameter heterogeneity multiplier.

- position:

  Position of the transition parameter in the Stage 1 parameter vector
  (3 to 6 for \\(a\_{11}\\), \\(a\_{21}\\), \\(a\_{12}\\),
  \\(a\_{22}\\)).

- between_var:

  Between-person variance of the Stage 1 estimates.

- mean_sampling_var:

  Mean Stage 1 sampling variance.

- ratio:

  `between_var` divided by `mean_sampling_var`.

## Author

Ivan Jacob Agaloos Pesigan
