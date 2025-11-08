# Fit the Model using the fitDTVARMxID Package

The function fits the model using the
[fitDTVARMxID::fitDTVARMxID](https://github.com/jeksterslab/fitDTVARMxID/reference/fitDTVARMxID-package.html)
package.

## Usage

``` r
FitDTVAR(data, ncores = NULL, seed = NULL)
```

## Arguments

- data:

  R object. Output of the
  [`GenData()`](https://github.com/jeksterslab/manMetaVAR/reference/GenData.md)
  function.

- ncores:

  Positive integer. Number of cores to use.

- seed:

  Integer. Random seed.

## See also

Other Model Fitting Functions:
[`FitMLVAR()`](https://github.com/jeksterslab/manMetaVAR/reference/FitMLVAR.md),
[`FitMetaVAR()`](https://github.com/jeksterslab/manMetaVAR/reference/FitMetaVAR.md),
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
print(fit)
summary(fit)
coef(fit)
vcov(fit)
} # }
```
