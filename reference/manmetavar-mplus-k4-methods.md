# Methods for Objects of Class `manmetavar.mplus.k4`

This page documents the available methods for objects of class
`manmetavar.mplus.k4`.

## Usage

``` r
# S3 method for class 'manmetavar.mplus.k4'
coef(object, median = TRUE, burnin = NULL, ...)

# S3 method for class 'manmetavar.mplus.k4'
vcov(object, burnin = NULL, ...)

# S3 method for class 'manmetavar.mplus.k4'
summary(object, alpha = 0.05, median = TRUE, digits = 4, burnin = NULL, ...)

# S3 method for class 'manmetavar.mplus.k4'
confint(object, parm = NULL, level = 0.95, burnin = NULL, ...)

# S3 method for class 'manmetavar.mplus.k4'
plot(
  x,
  what = "posterior",
  parm = NULL,
  level = 0.95,
  burnin = NULL,
  legend_loc = "topright",
  ...
)
```

## Arguments

- object:

  Object of class `manmetavar.mplus.k4`.

- median:

  Logical. If `median = TRUE`, return median of the posterior. If
  `median = FALSE`, return mean of the posterior.

- burnin:

  Integer indicating initial samples to discard. If `burnin = NULL`, use
  the burn-in stored in `object$burnin`.

- ...:

  additional arguments.

- alpha:

  Numeric vector. Significance level \\\alpha\\.

- digits:

  Integer indicating the number of decimal places to display.

- parm:

  a specification of which parameters are to be given confidence
  intervals, either a vector of numbers or a vector of names. If
  missing, all parameters are considered.

- level:

  the confidence level required.

- x:

  Object of class `manmetavar.mplus.k4`.

- what:

  Character string. If `what = "posterior"`, return posterior
  distribution plots. If `what = "trace"`, return trace plots. If
  `what = "rhat"`, `"ess"`, or `"mcse"`, return the corresponding
  Bayesian diagnostic plot from
  [`FitMplusK4Diagnostics()`](https://github.com/jeksterslab/manMetaVAR/reference/FitMplusK4Diagnostics.md).

- legend_loc:

  Character string. Legend location.

## Author

Ivan Jacob Agaloos Pesigan
