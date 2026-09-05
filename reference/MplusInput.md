# Create Mplus Input File

The function creates an Mplus input file.

## Usage

``` r
MplusInput(
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
[`MplusInputK4()`](https://github.com/jeksterslab/manMetaVAR/reference/MplusInputK4.md)

## Examples

``` r
cat(
  MplusInput(
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
#>       Multilevel Vector Autoregressive Model
#>     DATA:
#>       FILE = data.dat;
#>     VARIABLE:
#>       NAMES = ID TIME Y1 Y2;
#>       USEVARIABLES = Y1 Y2;
#>       MISSING = ALL (-999);
#>       CLUSTER = ID;
#>       LAGGED = Y1(1) Y2(1);
#>     ANALYSIS:
#>       TYPE = TWOLEVEL RANDOM;
#>       ESTIMATOR = BAYES;
#>       CHAINS = 2;
#>       FBITER = (40000);
#>       PROCESSORS = 1;
#>       BSEED = 42;
#>     MODEL:
#>       %WITHIN%
#>         ! transition matrix
#>         BETA11 | Y1 ON Y1&1;
#>         BETA21 | Y2 ON Y1&1;
#>         BETA12 | Y1 ON Y2&1;
#>         BETA22 | Y2 ON Y2&1;
#> 
#>         ! within-person innovation covariance
#>         Y1 (W1);
#>         Y2 WITH Y1 (W2);
#>         Y2 (W3);
#> 
#>       %BETWEEN%
#>         ! population means of person-specific set points
#>         [Y1] (FM1);
#>         [Y2] (FM2);
#> 
#>         ! between-person covariance of set points
#>         Y1 (M1);
#>         Y2 WITH Y1 (M2);
#>         Y2 (M3);
#> 
#>         ! population-average transition coefficients
#>         [BETA11] (FB1);
#>         [BETA21] (FB2);
#>         [BETA12] (FB3);
#>         [BETA22] (FB4);
#> 
#>         ! between-person covariance of transition coefficients
#>         BETA11 (B1);
#>         BETA21 WITH BETA11 (B2);
#>         BETA12 WITH BETA11 (B3);
#>         BETA22 WITH BETA11 (B4);
#> 
#>         BETA21 (B5);
#>         BETA12 WITH BETA21 (B6);
#>         BETA22 WITH BETA21 (B7);
#> 
#>         BETA12 (B8);
#>         BETA22 WITH BETA12 (B9);
#> 
#>         BETA22 (B10);
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
