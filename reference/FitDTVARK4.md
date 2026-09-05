# Fit the Four-Variable Model using the fitVARMxID Package

The function fits the four-variable feasibility model using the
[fitVARMxID](https://github.com/jeksterslab/fitVARMxID/reference/fitVARMxID-package.html)
package.

## Usage

``` r
FitDTVARK4(data, ncores = NULL, seed = NULL)
```

## Arguments

- data:

  R object. Output of the
  [`GenDataK4()`](https://github.com/jeksterslab/manMetaVAR/reference/GenDataK4.md)
  function.

- ncores:

  Positive integer. Number of cores to use.

- seed:

  Integer. Random seed.

## See also

Other Model Fitting Functions:
[`FitDTVAR()`](https://github.com/jeksterslab/manMetaVAR/reference/FitDTVAR.md),
[`FitMetaVAR()`](https://github.com/jeksterslab/manMetaVAR/reference/FitMetaVAR.md),
[`FitMetaVARK4()`](https://github.com/jeksterslab/manMetaVAR/reference/FitMetaVARK4.md),
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
print(fit)
summary(fit)
coef(fit)
vcov(fit)
} # }
```
