# Multivariate Meta-Analysis using the metaDyn Package

The function performs multivariate meta-snalysis using the
[metaDyn::metaDyn](https://github.com/jeksterslab/metaDyn/reference/metaDyn-package.html)
package.

## Usage

``` r
FitMetaVAR(fit, ncores = NULL, seed = NULL)
```

## Arguments

- fit:

  R object. Output of the
  [`FitDTVAR()`](https://github.com/jeksterslab/manMetaVAR/reference/FitDTVAR.md)
  function.

- ncores:

  Positive integer. Number of cores to use.

- seed:

  Integer. Random seed.

## See also

Other Model Fitting Functions:
[`FitDTVAR()`](https://github.com/jeksterslab/manMetaVAR/reference/FitDTVAR.md),
[`FitMplus()`](https://github.com/jeksterslab/manMetaVAR/reference/FitMplus.md),
[`FitNaive()`](https://github.com/jeksterslab/manMetaVAR/reference/FitNaive.md),
[`MplusInput()`](https://github.com/jeksterslab/manMetaVAR/reference/MplusInput.md)

## Examples

``` r
if (FALSE) { # \dontrun{
seed <- 42
data <- GenData(taskid = 1, seed = seed)
fit <- FitDTVAR(data = data, seed = seed)
meta <- FitMetaVAR(fit = fit, seed = seed)
summary(meta)
print(meta)
coef(meta)
vcov(meta)
} # }
```
