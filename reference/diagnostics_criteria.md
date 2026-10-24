# DSEM Posterior-Quality Failure Rates Under Three Criteria

Proportions of DSEM replications that fail the posterior-quality
criteria, by parameter group and prior, computed with
[`TabMplusDiagSensitivity()`](https://github.com/jeksterslab/manMetaVAR/reference/TabMplusDiagSensitivity.md)
under strict (\\(\hat{R} \leq 1.01\\), ESS \\(\geq 400\\), MCSE/SD
\\(\leq .05\\)), moderate (\\(\hat{R} \leq 1.05\\), ESS \\(\geq 100\\),
MCSE/SD \\(\leq .10\\)), and lenient (\\(\hat{R} \leq 1.10\\), ESS
\\(\geq 100\\)) criteria.

## Usage

``` r
data(diagnostics_criteria)
```

## Format

A data frame with one row per design condition and criterion:

- taskid:

  Simulation task ID.

- case_label:

  Design-condition label.

- n:

  Number of persons.

- time:

  Number of measurement occasions; `NA` denotes the unbalanced
  condition.

- heterogeneity:

  Transition-parameter heterogeneity multiplier.

- Innovation covariance \| Default, Innovation covariance \| User, Fixed
  effects \| Default, Fixed effects \| User, Random effects \| Default,
  Random effects \| User:

  Proportion of replications failing the criterion, by parameter group
  and prior.

- criterion:

  `"strict"`, `"moderate"`, or `"lenient"`.

- rhat_threshold, ess_threshold, mcse_threshold:

  Thresholds of the criterion.

## Author

Ivan Jacob Agaloos Pesigan
