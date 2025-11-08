# Create Mplus Input File

The function creates an Mplus input file.

## Usage

``` r
MplusInput(
  dynamics,
  fn_data,
  fn_posterior,
  fn_factorscores,
  chains,
  iter,
  fscores,
  plot,
  default_priors,
  ncores = NULL
)
```

## Arguments

- dynamics:

  `1`, `2`, or `3`. `1` for stable reciprocal regulation, `2` for
  escalating co-activation, and `3` for adaptive recovery.

- fn_data:

  Character string. Filename for data file.

- fn_posterior:

  Character string. Filename for posterior output.

- fn_factorscores:

  Character string. Filename for factor scores output.

- chains:

  Integer. Number of chains.

- iter:

  Integer. Number of iterations.

- fscores:

  Integer. Number of iterations for factor scores.

- plot:

  Logical. If `plot = TRUE`, add `PLOT: TYPE = PLOT3;` to `Mplus` input
  file.

- default_priors:

  Logical. If `default_priors = TRUE`, use default priors.

- ncores:

  Positive integer. Number of cores to use.

## See also

Other Model Fitting Functions:
[`FitDTVAR()`](https://github.com/jeksterslab/manMetaVAR/reference/FitDTVAR.md),
[`FitMLVAR()`](https://github.com/jeksterslab/manMetaVAR/reference/FitMLVAR.md),
[`FitMetaVAR()`](https://github.com/jeksterslab/manMetaVAR/reference/FitMetaVAR.md),
[`FitMplus()`](https://github.com/jeksterslab/manMetaVAR/reference/FitMplus.md)

## Examples

``` r
cat(
  MplusInput(
    dynamics = 1,
    fn_data = "data.dat",
    fn_posterior = "posterior.dat",
    fn_factorscores = "factorscores.dat",
    chains = 2L,
    iter = 60000L,
    fscores = 1000L,
    plot = TRUE,
    default_priors = TRUE,
    ncores = NULL
  )
)
#> 
#>     TITLE:
#>       Multilevel Vector Autoregressive Model with Measurement Error
#>     DATA:
#>       FILE = data.dat;
#>     VARIABLE:
#>       NAMES = ID TIME Y1 Y2;
#>       USEVARIABLES = Y1 Y2;
#>       CLUSTER = ID;
#>     ANALYSIS:
#>       TYPE = TWOLEVEL RANDOM;
#>       ESTIMATOR = BAYES;
#>       CHAINS = 2;
#>       FBITER = (60000);
#>       PROCESSORS = 1;
#>     MODEL:
#>       %WITHIN%
#>         ETA1 BY Y1@1(&1);
#>         ETA2 BY Y2@1(&1);
#>         ! measurement error variances (theta)
#>         Y1*0.500 (t11);
#>         Y2*0.500 (t22);
#>         [ETA1@0];
#>         [ETA2@0];
#>         BETA11 | ETA1 ON ETA1&1;
#>         BETA21 | ETA2 ON ETA1&1;
#>         BETA12 | ETA1 ON ETA2&1;
#>         BETA22 | ETA2 ON ETA2&1;
#>         ! process noise covariance matrix (psi)
#>         ETA1*0.200 (p11);
#>         ETA2 WITH ETA1*-0.050 (p21);
#>         ETA2*0.180 (p22);
#>       %BETWEEN%
#>         Y1@0;
#>         Y2@0;
#>         [Y1@0];
#>         [Y2@0];
#>         NU11 BY Y1@1;
#>         NU21 BY Y2@1;
#>         ! fixed effects
#>         !! transition matrix (beta)
#>         [BETA11*0.700] (m_b11);
#>         [BETA21*-0.150] (m_b21);
#>         [BETA12*-0.200] (m_b12);
#>         [BETA22*0.650] (m_b22);
#>         !! measurement model intercept (nu)
#>         [NU11*0.500] (m_n11);
#>         [NU21*-0.500] (m_n21);
#>         ! random effects
#>         BETA11*0.020 (c_b11b11);
#>         BETA21 WITH BETA11*0.010 (c_b21b11);
#>         BETA12 WITH BETA11*0.000 (c_b12b11);
#>         BETA22 WITH BETA11*0.000 (c_b22b11);
#>         NU11 WITH BETA11*0.000 (c_n11b11);
#>         NU21 WITH BETA11*0.000 (c_n21b11);
#>         BETA21*0.015 (c_b21b21);
#>         BETA12 WITH BETA21*0.000 (c_b12b21);
#>         BETA22 WITH BETA21*0.000 (c_b22b21);
#>         NU11 WITH BETA21*0.000 (c_n11b21);
#>         NU21 WITH BETA21*0.000 (c_n21b21);
#>         BETA12*0.010 (c_b12b12);
#>         BETA22 WITH BETA12*0.005 (c_b22b12);
#>         NU11 WITH BETA12*0.000 (c_n11b12);
#>         NU21 WITH BETA12*0.000 (c_n21b12);
#>         BETA22*0.015 (c_b22b22);
#>         NU11 WITH BETA22*0.000 (c_n11b22);
#>         NU21 WITH BETA22*0.000 (c_n21b22);
#>         NU11*0.100 (c_n11n11);
#>         NU21 WITH NU11*-0.050 (c_n21n11);
#>         NU21*0.100 (c_n21n21);
#>     PLOT:
#>       TYPE = PLOT3;
#>     OUTPUT:
#>       TECH1 TECH8;
#>     SAVEDATA:
#>       BPARAMETERS = posterior.dat;
#>       SAVE = FSCORES(1000 1);
#>       FILE = factorscores.dat;
#>       FACTORS = ALL;
```
