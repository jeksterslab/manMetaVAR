# Fit the Model using Mplus

The function fits the model using Mplus.

## Usage

``` r
FitMplus(
  data,
  chains = 2L,
  iter = 120000L,
  fscores = NULL,
  plot = FALSE,
  default_priors = TRUE,
  wd = ".",
  mplus_bin = NULL,
  ncores = NULL
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

  Logical. If `default_priors = TRUE`, use default priors.

- wd:

  Character string. Working directory.

- mplus_bin:

  Character string. Path to Mplus binary. If `mplus_bin = NULL`, the
  function will try to find the appropriate binary.

- ncores:

  Positive integer. Number of cores to use.

## See also

Other Model Fitting Functions:
[`FitDTVAR()`](https://github.com/jeksterslab/manMetaVAR/reference/FitDTVAR.md),
[`FitMLVAR()`](https://github.com/jeksterslab/manMetaVAR/reference/FitMLVAR.md),
[`FitMetaVAR()`](https://github.com/jeksterslab/manMetaVAR/reference/FitMetaVAR.md),
[`MplusInput()`](https://github.com/jeksterslab/manMetaVAR/reference/MplusInput.md)

## Examples

``` r
if (FALSE) { # \dontrun{
set.seed(42)
data <- GenData(taskid = 1)
fit <- FitMplus(data = data)
print(fit)
summary(fit)
} # }
```
