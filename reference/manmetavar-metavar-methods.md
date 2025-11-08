# Methods for Objects of Class `manmetavar.metavar`

This page documents the available methods for objects of class
`manmetavar.metavar`.

## Usage

``` r
# S3 method for class 'manmetavar.metavar'
coef(object, ...)

# S3 method for class 'manmetavar.metavar'
vcov(object, ...)

# S3 method for class 'manmetavar.metavar'
print(x, alpha = 0.05, digits = 4, ...)

# S3 method for class 'manmetavar.metavar'
summary(object, alpha = 0.05, digits = 4, ...)

# S3 method for class 'manmetavar.metavar'
confint(object, parm = NULL, level = 0.95, lb = TRUE, ...)
```

## Arguments

- object:

  Object of class `manmetavar.metavar`.

- ...:

  additional arguments.

- x:

  Object of class `manmetavar.metavar`.

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

- lb:

  Logical. If `TRUE`, returns profile likelihood-based confidence
  intervals. If `FALSE`, returns Wald confidence intervals.

## Author

Ivan Jacob Agaloos Pesigan
