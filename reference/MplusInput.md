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

- ncores:

  Positive integer. Number of cores to use.

- seed:

  Integer. Random seed.

## See also

Other Model Fitting Functions:
[`FitDTVAR()`](https://github.com/jeksterslab/manMetaVAR/reference/FitDTVAR.md),
[`FitMetaVAR()`](https://github.com/jeksterslab/manMetaVAR/reference/FitMetaVAR.md),
[`FitMplus()`](https://github.com/jeksterslab/manMetaVAR/reference/FitMplus.md)

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
#>         ! transition matrix (beta)
#>         BETA11 | Y1 ON Y1&1;
#>         BETA21 | Y2 ON Y1&1;
#>         BETA12 | Y1 ON Y2&1;
#>         BETA22 | Y2 ON Y2&1;
#>         ! process noise covariance matrix (psi)
#>         Y1;
#>         Y2 WITH Y1;
#>         Y2;
#>       %BETWEEN%
#>         ! person-specific means (mu)
#>         [Y1];
#>         [Y2];
#>         Y1;
#>         Y2 WITH Y1;
#>         Y2;
#>         ! person-specific lagged effects (beta)
#>         [BETA11];
#>         [BETA21];
#>         [BETA12];
#>         [BETA22];
#>         BETA11;
#>         BETA21 WITH BETA11;
#>         BETA12 WITH BETA11;
#>         BETA22 WITH BETA11;
#>         BETA21;
#>         BETA12 WITH BETA21;
#>         BETA22 WITH BETA21;
#>         BETA12;
#>         BETA22 WITH BETA12;
#>         BETA22;
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
