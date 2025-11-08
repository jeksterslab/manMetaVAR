# Methods for Objects of Class `manmetavar.dtvar`

This page documents the available methods for objects of class
`manmetavar.dtvar`.

## Usage

``` r
# S3 method for class 'manmetavar.dtvar'
coef(
  object,
  alpha = TRUE,
  beta = TRUE,
  nu = TRUE,
  psi = TRUE,
  theta = TRUE,
  converged = TRUE,
  grad_tol = 0.01,
  hess_tol = 1e-08,
  vanishing_theta = TRUE,
  theta_tol = 0.001,
  ...
)

# S3 method for class 'manmetavar.dtvar'
vcov(
  object,
  alpha = TRUE,
  beta = TRUE,
  nu = TRUE,
  psi = TRUE,
  theta = TRUE,
  converged = TRUE,
  grad_tol = 0.01,
  hess_tol = 1e-08,
  vanishing_theta = TRUE,
  theta_tol = 0.001,
  ...
)

# S3 method for class 'manmetavar.dtvar'
print(
  x,
  means = FALSE,
  alpha = TRUE,
  beta = TRUE,
  nu = TRUE,
  psi = TRUE,
  theta = TRUE,
  converged = TRUE,
  grad_tol = 0.01,
  hess_tol = 1e-08,
  vanishing_theta = TRUE,
  theta_tol = 0.001,
  digits = 4,
  ...
)

# S3 method for class 'manmetavar.dtvar'
summary(
  object,
  means = FALSE,
  alpha = TRUE,
  beta = TRUE,
  nu = TRUE,
  psi = TRUE,
  theta = TRUE,
  converged = TRUE,
  grad_tol = 0.01,
  hess_tol = 1e-08,
  vanishing_theta = TRUE,
  theta_tol = 0.001,
  digits = 4,
  ...
)
```

## Arguments

- object:

  Object of class `manmetavar.dtvar`.

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

- converged:

  Logical. Only include converged cases.

- grad_tol:

  Numeric scalar. Tolerance for the maximum absolute gradient if
  `converged = TRUE`.

- hess_tol:

  Numeric scalar. Tolerance for Hessian eigenvalues; eigenvalues must be
  strictly greater than this value if `converged = TRUE`.

- vanishing_theta:

  Logical. Test for measurement error variance going to zero if
  `converged = TRUE`.

- theta_tol:

  Numeric. Tolerance for vanishing theta test if `converged` and
  `theta_tol` are `TRUE`.

- ...:

  additional arguments.

- x:

  Object of class `manmetavar.dtvar`.

- means:

  Logical. If `means = TRUE`, return means. Otherwise, the function
  returns raw estimates.

- digits:

  Integer indicating the number of decimal places to display.

## Author

Ivan Jacob Agaloos Pesigan
