# DSEM Recovery Over All and Over Converged Replications

Bias, root mean square error, and coverage of the DSEM estimates in each
simulation condition, computed over all replications and over the
replications in which every parameter meets the moderate
posterior-quality criterion (finite diagnostics, \\(\hat{R} \leq
1.05\\), bulk and tail ESS \\(\geq 100\\), each MCSE/SD \\(\leq .10\\)).
The kept replications are a selected subset.

## Usage

``` r
data(dsem_converged)
```

## Format

A data frame with one row per task ID, prior, and parameter:

- taskid:

  Simulation task ID.

- method:

  `"BMLVAR-Default"` or `"BMLVAR-Priors"`.

- n:

  Number of persons.

- time:

  Number of measurement occasions; `NA` denotes the unbalanced
  condition.

- heterogeneity:

  Transition-parameter heterogeneity multiplier.

- replications:

  Number of replications.

- replications_kept:

  Number of replications meeting the moderate criterion.

- parnames:

  Parameter name.

- parameter:

  Calibrated population value.

- bias_all, rmse_all, coverage_all:

  Bias, root mean square error, and coverage of the 95 percent credible
  interval over all replications.

- bias_kept, rmse_kept, coverage_kept:

  The same over the kept replications; `NA` when none is kept.

## Author

Ivan Jacob Agaloos Pesigan
