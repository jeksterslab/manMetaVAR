# Create Mplus Input File for the Four-Variable Model

The function creates an Mplus input file for the four-variable
feasibility model. The between-person random-effects covariance matrix
is diagonal, consistent with `modelk4`.

## Usage

``` r
MplusInputK4(
  fn_data,
  fn_posterior,
  fn_factorscores,
  chains,
  iter,
  fscores,
  plot,
  default_priors = TRUE,
  ncores = NULL,
  seed = NULL
)
```

## Arguments

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

  Logical. If `default_priors = TRUE`, use `Mplus` default priors.

- ncores:

  Positive integer. Number of cores to use.

- seed:

  Integer. Random seed.

## See also

Other Model Fitting Functions:
[`FitDTVAR()`](https://github.com/jeksterslab/manMetaVAR/reference/FitDTVAR.md),
[`FitDTVARK4()`](https://github.com/jeksterslab/manMetaVAR/reference/FitDTVARK4.md),
[`FitMetaVAR()`](https://github.com/jeksterslab/manMetaVAR/reference/FitMetaVAR.md),
[`FitMetaVARK4()`](https://github.com/jeksterslab/manMetaVAR/reference/FitMetaVARK4.md),
[`FitMplus()`](https://github.com/jeksterslab/manMetaVAR/reference/FitMplus.md),
[`FitMplusDiagnostics()`](https://github.com/jeksterslab/manMetaVAR/reference/FitMplusDiagnostics.md),
[`FitMplusK4()`](https://github.com/jeksterslab/manMetaVAR/reference/FitMplusK4.md),
[`FitMplusK4Diagnostics()`](https://github.com/jeksterslab/manMetaVAR/reference/FitMplusK4Diagnostics.md),
[`FitNaive()`](https://github.com/jeksterslab/manMetaVAR/reference/FitNaive.md),
[`FitNaiveK4()`](https://github.com/jeksterslab/manMetaVAR/reference/FitNaiveK4.md),
[`MplusInput()`](https://github.com/jeksterslab/manMetaVAR/reference/MplusInput.md)

## Examples

``` r
cat(
  MplusInputK4(
    fn_data = "data.dat",
    fn_posterior = "posterior.dat",
    fn_factorscores = "factorscores.dat",
    chains = 2L,
    iter = 40000L,
    fscores = 1000L,
    plot = TRUE,
    default_priors = TRUE,
    ncores = NULL,
    seed = 42
  )
)
#> 
#>     TITLE:
#>       Four-Variable Multilevel Vector Autoregressive Model
#>     DATA:
#>     FILE = data.dat;
#>     VARIABLE:
#>       NAMES = ID TIME Y1 Y2 Y3 Y4;
#>       USEVARIABLES = Y1 Y2 Y3 Y4;
#>       MISSING = ALL (-999);
#>       CLUSTER = ID;
#>       LAGGED = Y1(1) Y2(1) Y3(1) Y4(1);
#>     ANALYSIS:
#>       TYPE = TWOLEVEL RANDOM;
#>       ESTIMATOR = BAYES;
#>       CHAINS = 2;
#>       FBITER = (40000);
#>       PROCESSORS = 1;
#>       BSEED = 42;
#>     MODEL:
#>       %WITHIN%
#>       ! transition matrix
#>         BETA11 | Y1 ON Y1&1;
#>         BETA21 | Y2 ON Y1&1;
#>         BETA31 | Y3 ON Y1&1;
#>         BETA41 | Y4 ON Y1&1;
#>         BETA12 | Y1 ON Y2&1;
#>         BETA22 | Y2 ON Y2&1;
#>         BETA32 | Y3 ON Y2&1;
#>         BETA42 | Y4 ON Y2&1;
#>         BETA13 | Y1 ON Y3&1;
#>         BETA23 | Y2 ON Y3&1;
#>         BETA33 | Y3 ON Y3&1;
#>         BETA43 | Y4 ON Y3&1;
#>         BETA14 | Y1 ON Y4&1;
#>         BETA24 | Y2 ON Y4&1;
#>         BETA34 | Y3 ON Y4&1;
#>         BETA44 | Y4 ON Y4&1;
#> 
#>       ! within-person innovation covariance
#>         Y1 (W1);
#>         Y2 WITH Y1 (W2);
#>         Y2 (W3);
#>         Y3 WITH Y1 (W4);
#>         Y3 WITH Y2 (W5);
#>         Y3 (W6);
#>         Y4 WITH Y1 (W7);
#>         Y4 WITH Y2 (W8);
#>         Y4 WITH Y3 (W9);
#>         Y4 (W10);
#> 
#>       %BETWEEN%
#>       ! population means of person-specific set points
#>         [Y1] (FM1);
#>         [Y2] (FM2);
#>         [Y3] (FM3);
#>         [Y4] (FM4);
#> 
#>       ! between-person variances of set points
#>         Y1 (M1);
#>         Y2 (M2);
#>         Y3 (M3);
#>         Y4 (M4);
#> 
#>       ! set-point covariances fixed to zero
#>         Y2 WITH Y1@0;
#>         Y3 WITH Y1@0;
#>         Y3 WITH Y2@0;
#>         Y4 WITH Y1@0;
#>         Y4 WITH Y2@0;
#>         Y4 WITH Y3@0;
#> 
#>       ! population-average transition coefficients
#>         [BETA11] (FB1);
#>         [BETA21] (FB2);
#>         [BETA31] (FB3);
#>         [BETA41] (FB4);
#>         [BETA12] (FB5);
#>         [BETA22] (FB6);
#>         [BETA32] (FB7);
#>         [BETA42] (FB8);
#>         [BETA13] (FB9);
#>         [BETA23] (FB10);
#>         [BETA33] (FB11);
#>         [BETA43] (FB12);
#>         [BETA14] (FB13);
#>         [BETA24] (FB14);
#>         [BETA34] (FB15);
#>         [BETA44] (FB16);
#> 
#>       ! between-person variances of transition coefficients
#>         BETA11 (B1);
#>         BETA21 (B2);
#>         BETA31 (B3);
#>         BETA41 (B4);
#>         BETA12 (B5);
#>         BETA22 (B6);
#>         BETA32 (B7);
#>         BETA42 (B8);
#>         BETA13 (B9);
#>         BETA23 (B10);
#>         BETA33 (B11);
#>         BETA43 (B12);
#>         BETA14 (B13);
#>         BETA24 (B14);
#>         BETA34 (B15);
#>         BETA44 (B16);
#> 
#>       ! transition-coefficient covariances fixed to zero
#>         BETA21 WITH BETA11@0;
#>         BETA31 WITH BETA11@0;
#>         BETA31 WITH BETA21@0;
#>         BETA41 WITH BETA11@0;
#>         BETA41 WITH BETA21@0;
#>         BETA41 WITH BETA31@0;
#>         BETA12 WITH BETA11@0;
#>         BETA12 WITH BETA21@0;
#>         BETA12 WITH BETA31@0;
#>         BETA12 WITH BETA41@0;
#>         BETA22 WITH BETA11@0;
#>         BETA22 WITH BETA21@0;
#>         BETA22 WITH BETA31@0;
#>         BETA22 WITH BETA41@0;
#>         BETA22 WITH BETA12@0;
#>         BETA32 WITH BETA11@0;
#>         BETA32 WITH BETA21@0;
#>         BETA32 WITH BETA31@0;
#>         BETA32 WITH BETA41@0;
#>         BETA32 WITH BETA12@0;
#>         BETA32 WITH BETA22@0;
#>         BETA42 WITH BETA11@0;
#>         BETA42 WITH BETA21@0;
#>         BETA42 WITH BETA31@0;
#>         BETA42 WITH BETA41@0;
#>         BETA42 WITH BETA12@0;
#>         BETA42 WITH BETA22@0;
#>         BETA42 WITH BETA32@0;
#>         BETA13 WITH BETA11@0;
#>         BETA13 WITH BETA21@0;
#>         BETA13 WITH BETA31@0;
#>         BETA13 WITH BETA41@0;
#>         BETA13 WITH BETA12@0;
#>         BETA13 WITH BETA22@0;
#>         BETA13 WITH BETA32@0;
#>         BETA13 WITH BETA42@0;
#>         BETA23 WITH BETA11@0;
#>         BETA23 WITH BETA21@0;
#>         BETA23 WITH BETA31@0;
#>         BETA23 WITH BETA41@0;
#>         BETA23 WITH BETA12@0;
#>         BETA23 WITH BETA22@0;
#>         BETA23 WITH BETA32@0;
#>         BETA23 WITH BETA42@0;
#>         BETA23 WITH BETA13@0;
#>         BETA33 WITH BETA11@0;
#>         BETA33 WITH BETA21@0;
#>         BETA33 WITH BETA31@0;
#>         BETA33 WITH BETA41@0;
#>         BETA33 WITH BETA12@0;
#>         BETA33 WITH BETA22@0;
#>         BETA33 WITH BETA32@0;
#>         BETA33 WITH BETA42@0;
#>         BETA33 WITH BETA13@0;
#>         BETA33 WITH BETA23@0;
#>         BETA43 WITH BETA11@0;
#>         BETA43 WITH BETA21@0;
#>         BETA43 WITH BETA31@0;
#>         BETA43 WITH BETA41@0;
#>         BETA43 WITH BETA12@0;
#>         BETA43 WITH BETA22@0;
#>         BETA43 WITH BETA32@0;
#>         BETA43 WITH BETA42@0;
#>         BETA43 WITH BETA13@0;
#>         BETA43 WITH BETA23@0;
#>         BETA43 WITH BETA33@0;
#>         BETA14 WITH BETA11@0;
#>         BETA14 WITH BETA21@0;
#>         BETA14 WITH BETA31@0;
#>         BETA14 WITH BETA41@0;
#>         BETA14 WITH BETA12@0;
#>         BETA14 WITH BETA22@0;
#>         BETA14 WITH BETA32@0;
#>         BETA14 WITH BETA42@0;
#>         BETA14 WITH BETA13@0;
#>         BETA14 WITH BETA23@0;
#>         BETA14 WITH BETA33@0;
#>         BETA14 WITH BETA43@0;
#>         BETA24 WITH BETA11@0;
#>         BETA24 WITH BETA21@0;
#>         BETA24 WITH BETA31@0;
#>         BETA24 WITH BETA41@0;
#>         BETA24 WITH BETA12@0;
#>         BETA24 WITH BETA22@0;
#>         BETA24 WITH BETA32@0;
#>         BETA24 WITH BETA42@0;
#>         BETA24 WITH BETA13@0;
#>         BETA24 WITH BETA23@0;
#>         BETA24 WITH BETA33@0;
#>         BETA24 WITH BETA43@0;
#>         BETA24 WITH BETA14@0;
#>         BETA34 WITH BETA11@0;
#>         BETA34 WITH BETA21@0;
#>         BETA34 WITH BETA31@0;
#>         BETA34 WITH BETA41@0;
#>         BETA34 WITH BETA12@0;
#>         BETA34 WITH BETA22@0;
#>         BETA34 WITH BETA32@0;
#>         BETA34 WITH BETA42@0;
#>         BETA34 WITH BETA13@0;
#>         BETA34 WITH BETA23@0;
#>         BETA34 WITH BETA33@0;
#>         BETA34 WITH BETA43@0;
#>         BETA34 WITH BETA14@0;
#>         BETA34 WITH BETA24@0;
#>         BETA44 WITH BETA11@0;
#>         BETA44 WITH BETA21@0;
#>         BETA44 WITH BETA31@0;
#>         BETA44 WITH BETA41@0;
#>         BETA44 WITH BETA12@0;
#>         BETA44 WITH BETA22@0;
#>         BETA44 WITH BETA32@0;
#>         BETA44 WITH BETA42@0;
#>         BETA44 WITH BETA13@0;
#>         BETA44 WITH BETA23@0;
#>         BETA44 WITH BETA33@0;
#>         BETA44 WITH BETA43@0;
#>         BETA44 WITH BETA14@0;
#>         BETA44 WITH BETA24@0;
#>         BETA44 WITH BETA34@0;
#> 
#>       ! set-point--transition covariances fixed to zero
#>         BETA11 WITH Y1@0;
#>         BETA11 WITH Y2@0;
#>         BETA11 WITH Y3@0;
#>         BETA11 WITH Y4@0;
#>         BETA21 WITH Y1@0;
#>         BETA21 WITH Y2@0;
#>         BETA21 WITH Y3@0;
#>         BETA21 WITH Y4@0;
#>         BETA31 WITH Y1@0;
#>         BETA31 WITH Y2@0;
#>         BETA31 WITH Y3@0;
#>         BETA31 WITH Y4@0;
#>         BETA41 WITH Y1@0;
#>         BETA41 WITH Y2@0;
#>         BETA41 WITH Y3@0;
#>         BETA41 WITH Y4@0;
#>         BETA12 WITH Y1@0;
#>         BETA12 WITH Y2@0;
#>         BETA12 WITH Y3@0;
#>         BETA12 WITH Y4@0;
#>         BETA22 WITH Y1@0;
#>         BETA22 WITH Y2@0;
#>         BETA22 WITH Y3@0;
#>         BETA22 WITH Y4@0;
#>         BETA32 WITH Y1@0;
#>         BETA32 WITH Y2@0;
#>         BETA32 WITH Y3@0;
#>         BETA32 WITH Y4@0;
#>         BETA42 WITH Y1@0;
#>         BETA42 WITH Y2@0;
#>         BETA42 WITH Y3@0;
#>         BETA42 WITH Y4@0;
#>         BETA13 WITH Y1@0;
#>         BETA13 WITH Y2@0;
#>         BETA13 WITH Y3@0;
#>         BETA13 WITH Y4@0;
#>         BETA23 WITH Y1@0;
#>         BETA23 WITH Y2@0;
#>         BETA23 WITH Y3@0;
#>         BETA23 WITH Y4@0;
#>         BETA33 WITH Y1@0;
#>         BETA33 WITH Y2@0;
#>         BETA33 WITH Y3@0;
#>         BETA33 WITH Y4@0;
#>         BETA43 WITH Y1@0;
#>         BETA43 WITH Y2@0;
#>         BETA43 WITH Y3@0;
#>         BETA43 WITH Y4@0;
#>         BETA14 WITH Y1@0;
#>         BETA14 WITH Y2@0;
#>         BETA14 WITH Y3@0;
#>         BETA14 WITH Y4@0;
#>         BETA24 WITH Y1@0;
#>         BETA24 WITH Y2@0;
#>         BETA24 WITH Y3@0;
#>         BETA24 WITH Y4@0;
#>         BETA34 WITH Y1@0;
#>         BETA34 WITH Y2@0;
#>         BETA34 WITH Y3@0;
#>         BETA34 WITH Y4@0;
#>         BETA44 WITH Y1@0;
#>         BETA44 WITH Y2@0;
#>         BETA44 WITH Y3@0;
#>         BETA44 WITH Y4@0;
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
