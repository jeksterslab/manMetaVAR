# Multivariate Meta-Analysis using the metaVAR Package

The function performs multivariate meta-snalysis using the
[metaVAR::metaVAR](https://github.com/jeksterslab/metaVAR/reference/metaVAR-package.html)
package.

## Usage

``` r
FitMetaVAR(data, fit, ncores = NULL)
```

## Arguments

- data:

  R object. Output of the
  [`GenData()`](https://github.com/jeksterslab/manMetaVAR/reference/GenData.md)
  function.

- fit:

  R object. Output of the
  [`FitDTVAR()`](https://github.com/jeksterslab/manMetaVAR/reference/FitDTVAR.md)
  function.

- ncores:

  Positive integer. Number of cores to use.

## See also

Other Model Fitting Functions:
[`FitDTVAR()`](https://github.com/jeksterslab/manMetaVAR/reference/FitDTVAR.md),
[`FitMLVAR()`](https://github.com/jeksterslab/manMetaVAR/reference/FitMLVAR.md),
[`FitMplus()`](https://github.com/jeksterslab/manMetaVAR/reference/FitMplus.md),
[`MplusInput()`](https://github.com/jeksterslab/manMetaVAR/reference/MplusInput.md)

## Examples

``` r
if (FALSE) { # \dontrun{
set.seed(42)
data <- GenData(taskid = 1)
fit <- FitDTVAR(
  data = data,
  ncores = parallel::detectCores()
)
pooled <- FitMetaVAR(
  data = data,
  fit = fit,
  ncores = parallel::detectCores()
)
summary(pooled)
print(pooled)
coef(pooled)
vcov(pooled)
} # }
```
