# Simulation Results

Simulation Results

## Usage

``` r
data(results)
```

## Format

A data frame with one row per design condition, method, interval type,
and parameter:

- taskid:

  Simulation task ID.

- replications:

  Number of replications.

- replications_used:

  Number of admissible replications contributing to the summary.

- success_rate:

  Proportion of requested replications that were admissible and
  contributed to the summary.

- parnames:

  Parameter name.

- parameter:

  Calibrated population parameter value. For transition parameters under
  stability rejection, this is the realized truncated population value
  rather than the nominal untruncated value.

- method:

  Estimation method: MetaVAR, BMLVAR with default priors, BMLVAR with
  user-defined priors, or the uncertainty-uncorrected method.

- n:

  Number of persons.

- time:

  Number of measurement occasions; `NA` denotes the unbalanced
  condition.

- heterogeneity:

  Transition-parameter heterogeneity multiplier: 0, 1, or 2.

- ci:

  Confidence or credible interval method.

- est:

  Mean parameter estimate.

- se:

  Mean standard error or posterior standard deviation.

- z:

  Mean test statistic when available.

- p:

  Mean p-value when available.

- ll:

  Mean lower interval limit.

- ul:

  Mean upper interval limit.

- sig:

  Proportion statistically significant when available.

- zero_hit:

  Proportion of intervals containing zero.

- theta_hit:

  Proportion of intervals containing the calibrated population value.

- sq_error:

  Mean squared error.

- bias:

  Mean estimate minus the calibrated population value.

- rel_bias:

  Relative bias for nonzero population values and `NA` when the
  population value is zero.

- rmse:

  Root mean squared error.

- n_bias:

  Number of finite replication-level bias values used to calculate the
  Monte Carlo standard error of bias.

- n_rmse:

  Number of finite replication-level squared errors used to calculate
  the Monte Carlo standard error of RMSE.

- n_coverage:

  Number of finite coverage indicators used to calculate the Monte Carlo
  standard error of coverage.

- n_rejection:

  Number of finite rejection indicators used to calculate the Monte
  Carlo standard error of the rejection rate.

- mcse_bias:

  Monte Carlo standard error of bias.

- mcse_rmse:

  Delta-method Monte Carlo standard error of RMSE, obtained from the
  Monte Carlo standard error of mean squared error.

- coverage:

  Coverage probability.

- mcse_coverage:

  Binomial Monte Carlo standard error of coverage.

- rejection_rate:

  Proportion of intervals excluding zero.

- mcse_rejection_rate:

  Binomial Monte Carlo standard error of the rejection rate.

- power:

  Rejection rate for nonzero population values and `NA` for zero
  population values.

- mcse_power:

  Monte Carlo standard error of power for nonzero population values and
  `NA` for zero population values.

- type1_error:

  Rejection rate for zero population values and `NA` for nonzero
  population values.

- mcse_type1_error:

  Monte Carlo standard error of the Type I error rate for zero
  population values and `NA` for nonzero population values.

- par_idx:

  Parameter display index.

## Author

Ivan Jacob Agaloos Pesigan
