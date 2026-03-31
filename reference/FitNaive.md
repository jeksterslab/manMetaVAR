# Naive

The function performs the naive “fit-many-then-summarize”.

## Usage

``` r
FitNaive(fit, seed = NULL)
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
[`FitMetaVAR()`](https://github.com/jeksterslab/manMetaVAR/reference/FitMetaVAR.md),
[`FitMplus()`](https://github.com/jeksterslab/manMetaVAR/reference/FitMplus.md),
[`MplusInput()`](https://github.com/jeksterslab/manMetaVAR/reference/MplusInput.md)

## Examples

``` r
if (FALSE) { # \dontrun{
seed <- 42
data <- GenData(taskid = 1, seed = seed)
fit <- FitDTVAR(data = data, seed = seed)
naive <- FitNaive(fit = fit, seed = seed)
summary(naive)
print(naive)
coef(naive)
vcov(naive)
} # }
```
