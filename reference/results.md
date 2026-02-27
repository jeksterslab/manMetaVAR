# Simulation Results

Simulation Results

## Usage

``` r
data(results)
```

## Format

A dataframe with I rows and J columns:

- taskid:

  Simulation Task ID.

- replications:

  Number of replications.

- parnames:

  Parameter names.

- parameter:

  Population parameter value.

- method:

  Method used to fit the data.

- n:

  Sample size.

- time:

  Number of measurement occassions.

- ci:

  Confidence/credible intervals method.

- est:

  Mean parameter estimate.

- se:

  Mean standard error.

- t:

  Mean test statistic.

- p:

  Mean \\p\\-value.

- ll:

  Mean lower limit of the 95% confidence/credible interval.

- ul:

  Mean upper limit of the 95% confidence/credible interval.

- sig:

  Proportion of statistically significant results.

- theta_hit:

  Proportion of replications where the confidence intervals contained
  the population parameter.

- sq_error:

  Mean squared error.

- bias:

  Bias.

- rel_bias:

  Relative bias.

- se_bias:

  Bias in standard error estimate.

- rel_se_bias:

  Relative bias in standard error estimate.

- rmse:

  Root mean square error.

- coverage:

  Coverage probability.

- power:

  Statistical power.

- par_idx:

  Parameter index.

## Author

Ivan Jacob Agaloos Pesigan
