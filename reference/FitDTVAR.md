# Fit the Model using the fitVARMxID Package

The function fits the model using the
[fitVARMxID::fitVARMxID](https://github.com/jeksterslab/fitVARMxID/reference/fitVARMxID-package.html)
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
[`FitMetaVAR()`](https://github.com/jeksterslab/manMetaVAR/reference/FitMetaVAR.md),
[`FitMplus()`](https://github.com/jeksterslab/manMetaVAR/reference/FitMplus.md),
[`MplusInput()`](https://github.com/jeksterslab/manMetaVAR/reference/MplusInput.md)

## Examples

``` r
if (FALSE) { # \dontrun{
seed <- 42
data <- GenData(taskid = 1, seed = seed)
fit <- FitDTVAR(data = data, seed = seed)
print(fit)
summary(fit)
coef(fit)
vcov(fit)
} # }
```
