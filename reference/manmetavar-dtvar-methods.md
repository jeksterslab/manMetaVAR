# Methods for Objects of Class `manmetavar.dtvar`

This page documents the available methods for objects of class
`manmetavar.dtvar`.

## Usage

``` r
# S3 method for class 'manmetavar.dtvar'
coef(
  object,
  mu = TRUE,
  alpha = TRUE,
  beta = TRUE,
  nu = TRUE,
  psi = TRUE,
  theta = TRUE,
  ncores = NULL,
  ...
)

# S3 method for class 'manmetavar.dtvar'
vcov(
  object,
  mu = TRUE,
  alpha = TRUE,
  beta = TRUE,
  nu = TRUE,
  psi = TRUE,
  theta = TRUE,
  robust = FALSE,
  ncores = NULL,
  ...
)

# S3 method for class 'manmetavar.dtvar'
print(
  x,
  means = FALSE,
  mu = TRUE,
  alpha = TRUE,
  beta = TRUE,
  nu = TRUE,
  psi = TRUE,
  theta = TRUE,
  digits = 4,
  ncores = NULL,
  ...
)

# S3 method for class 'manmetavar.dtvar'
summary(
  object,
  means = FALSE,
  mu = TRUE,
  alpha = TRUE,
  beta = TRUE,
  nu = TRUE,
  psi = TRUE,
  theta = TRUE,
  digits = 4,
  ncores = NULL,
  ...
)
```

## Arguments

- object:

  Object of class `manmetavar.dtvar`.

- mu:

  Logical. If `mu = TRUE`, include estimates of the `mu` vector, if
  available. If `mu = FALSE`, exclude estimates of the `mu` vector.

- alpha:

  Logical. If `alpha = TRUE`, include estimates of the `alpha` vector,
  if available. If `alpha = FALSE`, exclude estimates of the `alpha`
  vector.

- beta:

  Logical. If `beta = TRUE`, include estimates of the `beta` matrix, if
  available. If `beta = FALSE`, exclude estimates of the `beta` matrix.

- nu:

  Logical. If `nu = TRUE`, include estimates of the `nu` vector, if
  available. If `nu = FALSE`, exclude estimates of the `nu` vector.

- psi:

  Logical. If `psi = TRUE`, include estimates of the `psi` matrix, if
  available. If `psi = FALSE`, exclude estimates of the `psi` matrix.

- theta:

  Logical. If `theta = TRUE`, include estimates of the `theta` matrix,
  if available. If `theta = FALSE`, exclude estimates of the `theta`
  matrix.

- ncores:

  Positive integer. Number of cores to use.

- ...:

  additional arguments.

- robust:

  Logical. If `TRUE`, use robust (sandwich) sampling variance-covariance
  matrix. If `FALSE`, use normal theory sampling variance-covariance
  matrix.

- x:

  Object of class `manmetavar.dtvar`.

- means:

  Logical. If `means = TRUE`, return means. Otherwise, the function
  returns raw estimates.

- digits:

  Integer indicating the number of decimal places to display.

## Author

Ivan Jacob Agaloos Pesigan
