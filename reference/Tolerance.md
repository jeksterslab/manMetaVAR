# Tolerance Decisions for Between-Person Variances and Covariances

Classifies estimates and interval limits of between-person variances and
covariances against a tolerance \\(\delta\\) instead of exact zero.
Variances are compared one-sided with \\(\delta\\); covariances
two-sided with \\(\[-\delta, \delta\]\\).

## Usage

``` r
Tolerance(est, ll, ul, variance, delta)
```

## Arguments

- est:

  Numeric vector. Estimates.

- ll:

  Numeric vector. Lower interval limits.

- ul:

  Numeric vector. Upper interval limits.

- variance:

  Logical vector. `TRUE` for variances, `FALSE` for covariances.

- delta:

  Nonnegative numeric value. Tolerance.

## Value

A data frame with logical columns `est_within` (estimate within the
tolerance), `equivalent` (interval within the tolerance: practical
homogeneity), and `exceed` (interval beyond the tolerance: heterogeneity
beyond the tolerance).

## Author

Ivan Jacob Agaloos Pesigan

## Examples

``` r
Tolerance(
  est = c(0.0002, 0.01),
  ll = c(0, 0.004),
  ul = c(0.0008, 0.02),
  variance = c(TRUE, TRUE),
  delta = 0.0009
)
#>   est_within equivalent exceed
#> 1       TRUE       TRUE  FALSE
#> 2      FALSE      FALSE   TRUE
```
