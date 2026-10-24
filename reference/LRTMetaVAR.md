# Boundary Likelihood Ratio Test for Transition Heterogeneity

Tests whether the between-person covariance matrix of the transition
parameters is zero in a fitted MetaVAR Stage 2 model. The model is
refitted with the transition rows and columns of
\\(\boldsymbol{\tau}^2\\) fixed at zero (variances at the lower bound of
the softplus parameterization), and the likelihood ratio statistic is
referred to a simulated chi-bar-square distribution for the cone of
positive semidefinite matrices, using the Fisher information at the null
fit, and to the naive chi-square distribution.

## Usage

``` r
LRTMetaVAR(
  fit,
  block = 3:6,
  others = 1:2,
  cross = FALSE,
  draws = 2000L,
  seed = NULL
)
```

## Arguments

- fit:

  Fitted MetaVAR Stage 2 model: an object returned by
  [`FitMetaVAR()`](https://github.com/jeksterslab/manMetaVAR/reference/FitMetaVAR.md),
  by
  [`metaDyn::MetaVARMx()`](https://github.com/jeksterslab/metaDyn/reference/MetaVARMx.html),
  or the underlying `MxModel`.

- block:

  Integer vector. Positions of the transition parameters in
  \\(\boldsymbol{\tau}^2\\).

- others:

  Integer vector. Positions of the remaining random effects in
  \\(\boldsymbol{\tau}^2\\).

- cross:

  Logical. If `cross = TRUE`, the covariances between `block` and
  `others` are free in `fit` and are also set to zero under the null
  hypothesis.

- draws:

  Positive integer. Number of draws from the chi-bar-square
  distribution.

- seed:

  Integer. Random seed for the chi-bar-square draws.

## Value

A one-row data frame with the -2 log-likelihoods of the full and null
models, the statistic, the null-fit status code, the number of tested
parameters (`df`), the chi-bar-square p-value and 95% critical value,
and the naive chi-square p-value.

## See also

Other Model Fitting Functions:
[`FitDTVAR()`](https://github.com/jeksterslab/manMetaVAR/reference/FitDTVAR.md),
[`FitMetaVAR()`](https://github.com/jeksterslab/manMetaVAR/reference/FitMetaVAR.md),
[`FitMplus()`](https://github.com/jeksterslab/manMetaVAR/reference/FitMplus.md),
[`FitMplusDiagnostics()`](https://github.com/jeksterslab/manMetaVAR/reference/FitMplusDiagnostics.md),
[`FitNaive()`](https://github.com/jeksterslab/manMetaVAR/reference/FitNaive.md),
[`MplusInput()`](https://github.com/jeksterslab/manMetaVAR/reference/MplusInput.md)

## Author

Ivan Jacob Agaloos Pesigan

## Examples

``` r
if (FALSE) { # \dontrun{
seed <- 42
data <- GenData(taskid = 25, seed = seed)
fit <- FitDTVAR(data = data, seed = seed)
meta <- FitMetaVAR(fit = fit, seed = seed)
LRTMetaVAR(fit = meta, seed = seed)
} # }
```
