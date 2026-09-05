# Calibrated Population Parameters

Population moments implied by the stationary transition-matrix
generator. The moments of the set points are analytical. The moments of
the transition matrices are calculated by Monte Carlo integration over
the stationary region for each nonzero heterogeneity condition.

## Usage

``` r
data(population)
```

## Format

A list with two elements:

- conditions:

  Named list indexed by heterogeneity. Each element contains the
  calibrated means and covariance matrices, a named population parameter
  vector, and Monte Carlo calibration information.

- calibration:

  Metadata describing the generator, package version, random seed,
  population size, batch size, stationarity margin, and generation time.

## Author

Ivan Jacob Agaloos Pesigan
