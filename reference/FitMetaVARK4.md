# Multivariate Meta-Analysis for the Four-Variable Model

The function performs multivariate meta-analysis for the four-variable
feasibility model using the
[metaDyn](https://github.com/jeksterslab/metaDyn/reference/metaDyn-package.html)
package. The random-effects covariance matrix is diagonal, consistent
with the population specification in `modelk4`.

## Usage

``` r
FitMetaVARK4(fit, ncores = NULL, seed = NULL)
```

## Arguments

- fit:

  R object. Output of the
  [`FitDTVARK4()`](https://github.com/jeksterslab/manMetaVAR/reference/FitDTVARK4.md)
  function.

- ncores:

  Positive integer. Number of cores to use.

- seed:

  Integer. Random seed.

## See also

Other Model Fitting Functions:
[`FitDTVAR()`](https://github.com/jeksterslab/manMetaVAR/reference/FitDTVAR.md),
[`FitDTVARK4()`](https://github.com/jeksterslab/manMetaVAR/reference/FitDTVARK4.md),
[`FitMetaVAR()`](https://github.com/jeksterslab/manMetaVAR/reference/FitMetaVAR.md),
[`FitMplus()`](https://github.com/jeksterslab/manMetaVAR/reference/FitMplus.md),
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
data <- GenDataK4(taskid = 1, seed = seed)
fit <- FitDTVARK4(data = data, seed = seed)
meta <- FitMetaVARK4(fit = fit, seed = seed)
summary(meta)
print(meta)
coef(meta)
vcov(meta)
} # }
```
