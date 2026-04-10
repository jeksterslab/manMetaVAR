# Methods for Objects of Class `manmetavar.metavar`

This page documents the available methods for objects of class
`manmetavar.metavar`.

This page documents the available methods for objects of class
`manmetavar.naive`.

## Usage

``` r
# S3 method for class 'manmetavar.metavar'
coef(object, ...)

# S3 method for class 'manmetavar.metavar'
vcov(object, robust = NULL, ...)

# S3 method for class 'manmetavar.metavar'
print(x, alpha = NULL, robust = NULL, digits = 4, ...)

# S3 method for class 'manmetavar.metavar'
summary(object, alpha = NULL, robust = NULL, digits = 4, ...)

# S3 method for class 'manmetavar.metavar'
confint(object, parm = NULL, level = 0.95, robust = NULL, ...)

# S3 method for class 'manmetavar.naive'
coef(object, ...)

# S3 method for class 'manmetavar.naive'
vcov(object, ...)

# S3 method for class 'manmetavar.naive'
print(x, ...)

# S3 method for class 'manmetavar.naive'
summary(object, alpha = 0.05, digits = 4, ...)
```

## Arguments

- object:

  Object of class `manmetavar.naive`.

- ...:

  additional arguments.

- robust:

  Logical. If `TRUE`, use robust (sandwich) sampling variance-covariance
  matrix. If `FALSE`, use normal theory sampling variance-covariance
  matrix. If `NULL`, the function will check `object` if robust standard
  errors are available.

- x:

  Object of class `manmetavar.naive`.

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

## Author

Anonymous
