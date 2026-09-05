# Four-Variable Model Parameters

Population model parameters for the four-variable VAR(1) simulation
condition.

## Usage

``` r
data(modelk4)
```

## Format

A list with 15 elements:

- k:

  Number of variables, equal to 4.

- mu_mu:

  Mean of the set-point vector \\\boldsymbol{\mu}\\.

- mu_sigma:

  Covariance matrix of the parameter \\\boldsymbol{\mu}\\.

- mu_sigma_l:

  Cholesky factor of the covariance matrix of the parameter
  \\\boldsymbol{\mu}\\.

- beta_mu:

  Mean of the lagged-coefficient matrix \\\boldsymbol{\beta}\\.

- beta_sigma:

  Covariance matrix of the parameter \\\mathrm{vec} \left(
  \boldsymbol{\beta} \right)\\.

- beta_sigma_l:

  Cholesky factor of the covariance matrix of the parameter
  \\\mathrm{vec} \left( \boldsymbol{\beta} \right)\\.

- psi:

  Process-noise covariance matrix \\\boldsymbol{\Psi}\\.

- psi_l:

  Cholesky factor of the process-noise covariance matrix
  \\\boldsymbol{\Psi}\\.

- psi_d_ldl:

  `uc_d` of the LDL' decomposition of the process-noise covariance
  matrix \\\boldsymbol{\Psi}\\. See
  [`fitVARMxID::LDL()`](https://github.com/jeksterslab/fitVARMxID/reference/LDL.html).

- psi_l_ldl:

  `s_l` of the LDL' decomposition of the process-noise covariance matrix
  \\\boldsymbol{\Psi}\\. See
  [`fitVARMxID::LDL()`](https://github.com/jeksterslab/fitVARMxID/reference/LDL.html).

- ma_fixed:

  Vector of fixed effects \\ \boldsymbol{\theta} = \left\[
  \boldsymbol{\mu}, \mathrm{vec} \left( \boldsymbol{\beta} \right)
  \right\]^{\prime}. \\

- ma_random:

  Covariance matrix of the random effects in \\ \boldsymbol{\theta} =
  \left\[ \boldsymbol{\mu}, \mathrm{vec} \left( \boldsymbol{\beta}
  \right) \right\]^{\prime}. \\

- ma_random_d_ldl:

  `uc_d` of the LDL' decomposition of the random-effects covariance
  matrix. See
  [`fitVARMxID::LDL()`](https://github.com/jeksterslab/fitVARMxID/reference/LDL.html).

- ma_random_l_ldl:

  `s_l` of the LDL' decomposition of the random-effects covariance
  matrix. See
  [`fitVARMxID::LDL()`](https://github.com/jeksterslab/fitVARMxID/reference/LDL.html).

## Author

Ivan Jacob Agaloos Pesigan
