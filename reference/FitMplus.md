# Fit the Model using Mplus

The function fits the model using Mplus.

## Usage

``` r
FitMplus(
  data,
  chains = 2L,
  iter = 40000L,
  fscores = NULL,
  plot = FALSE,
  default_priors = TRUE,
  wd = ".",
  mplus_bin = NULL,
  ncores = NULL,
  seed = NULL
)
```

## Arguments

- data:

  R object. Output of the
  [`GenData()`](https://github.com/jeksterslab/manMetaVAR/reference/GenData.md)
  function.

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

- wd:

  Character string. Working directory.

- mplus_bin:

  Character string. Path to Mplus binary. If `mplus_bin = NULL`, the
  function will try to find the appropriate binary.

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
[`FitMplusDiagnostics()`](https://github.com/jeksterslab/manMetaVAR/reference/FitMplusDiagnostics.md),
[`FitMplusK4()`](https://github.com/jeksterslab/manMetaVAR/reference/FitMplusK4.md),
[`FitMplusK4Diagnostics()`](https://github.com/jeksterslab/manMetaVAR/reference/FitMplusK4Diagnostics.md),
[`FitNaive()`](https://github.com/jeksterslab/manMetaVAR/reference/FitNaive.md),
[`FitNaiveK4()`](https://github.com/jeksterslab/manMetaVAR/reference/FitNaiveK4.md),
[`MplusInput()`](https://github.com/jeksterslab/manMetaVAR/reference/MplusInput.md),
[`MplusInputK4()`](https://github.com/jeksterslab/manMetaVAR/reference/MplusInputK4.md)

## Examples

``` r
if (FALSE) { # \dontrun{
seed <- 42
data <- GenData(taskid = 1, seed = seed)
dsem <- FitMplus(data = data)
print(dsem)
summary(dsem)
coef(dsem)
vcov(dsem)
confint(dsem)
plot(dsem)
plot(dsem, what = "trace")
} # }
```
