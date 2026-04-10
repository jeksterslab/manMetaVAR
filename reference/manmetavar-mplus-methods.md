# Methods for Objects of Class `manmetavar.mplus`

This page documents the available methods for objects of class
`manmetavar.mplus`.

## Usage

``` r
# S3 method for class 'manmetavar.mplus'
coef(object, median = TRUE, burnin = NULL, ...)

# S3 method for class 'manmetavar.mplus'
vcov(object, burnin = NULL, ...)

# S3 method for class 'manmetavar.mplus'
summary(object, alpha = 0.05, median = TRUE, digits = 4, burnin = NULL, ...)

# S3 method for class 'manmetavar.mplus'
confint(object, parm = NULL, level = 0.95, burnin = NULL, ...)

# S3 method for class 'manmetavar.mplus'
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

  Object of class `manmetavar.mplus`.

- median:

  Logical. If `median = TRUE`, return median of the posterior. If
  `median = FALSE`, return mean of the posterior.

- burnin:

  Integer indicating initial samples to discard. If `burnin = NULL`, do
  not discard anything.

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

  Object of class `manmetavar.mplus`.

- what:

  Character string. If `what = "posterior"`, return posterior
  distribution plots. If `what = "trace"`, return trace plots.

- legend_loc:

  Character string. Legend location.

## Author

Anonymous
