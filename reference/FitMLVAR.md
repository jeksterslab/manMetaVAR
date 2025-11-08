# Fit the Model using the mlVAR Package

The function fits the model using the
[mlVAR::mlVAR](https://rdrr.io/pkg/mlVAR/man/mlVAR.html) package.

## Usage

``` r
FitMLVAR(data, ncores = NULL)
```

## Arguments

- data:

  R object. Output of the
  [`GenData()`](https://github.com/jeksterslab/manMetaVAR/reference/GenData.md)
  function.

- ncores:

  Positive integer. Number of cores to use.

## See also

Other Model Fitting Functions:
[`FitDTVAR()`](https://github.com/jeksterslab/manMetaVAR/reference/FitDTVAR.md),
[`FitMetaVAR()`](https://github.com/jeksterslab/manMetaVAR/reference/FitMetaVAR.md),
[`FitMplus()`](https://github.com/jeksterslab/manMetaVAR/reference/FitMplus.md),
[`MplusInput()`](https://github.com/jeksterslab/manMetaVAR/reference/MplusInput.md)

## Examples

``` r
if (FALSE) { # \dontrun{
set.seed(42)
data <- GenData(taskid = 1)
fit <- FitMLVAR(data = data)
print(fit)
summary(fit)
} # }
```
