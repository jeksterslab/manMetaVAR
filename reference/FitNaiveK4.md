# Naive Estimation for the Four-Variable Model

The function performs the naive “fit-many-then-summarize” procedure for
the four-variable feasibility model. The random-effects covariance
matrix is diagonal, consistent with `modelk4`.

## Usage

``` r
FitNaiveK4(fit, seed = NULL)
```

## Arguments

- fit:

  R object. Output of the
  [`FitDTVAR()`](https://github.com/jeksterslab/manMetaVAR/reference/FitDTVAR.md)
  function.

- seed:

  Integer. Random seed.

## See also

Other Model Fitting Functions:
[`FitDTVAR()`](https://github.com/jeksterslab/manMetaVAR/reference/FitDTVAR.md),
[`FitDTVARK4()`](https://github.com/jeksterslab/manMetaVAR/reference/FitDTVARK4.md),
[`FitMetaVAR()`](https://github.com/jeksterslab/manMetaVAR/reference/FitMetaVAR.md),
[`FitMetaVARK4()`](https://github.com/jeksterslab/manMetaVAR/reference/FitMetaVARK4.md),
[`FitMplus()`](https://github.com/jeksterslab/manMetaVAR/reference/FitMplus.md),
[`FitMplusDiagnostics()`](https://github.com/jeksterslab/manMetaVAR/reference/FitMplusDiagnostics.md),
[`FitMplusK4()`](https://github.com/jeksterslab/manMetaVAR/reference/FitMplusK4.md),
[`FitMplusK4Diagnostics()`](https://github.com/jeksterslab/manMetaVAR/reference/FitMplusK4Diagnostics.md),
[`FitNaive()`](https://github.com/jeksterslab/manMetaVAR/reference/FitNaive.md),
[`MplusInput()`](https://github.com/jeksterslab/manMetaVAR/reference/MplusInput.md),
[`MplusInputK4()`](https://github.com/jeksterslab/manMetaVAR/reference/MplusInputK4.md)

## Examples

``` r
if (FALSE) { # \dontrun{
seed <- 42
data <- GenDataK4(taskid = 1, seed = seed)
fit <- FitDTVARK4(data = data, seed = seed)
naive <- FitNaiveK4(fit = fit, seed = seed)
summary(naive)
print(naive)
coef(naive)
vcov(naive)
} # }
```
