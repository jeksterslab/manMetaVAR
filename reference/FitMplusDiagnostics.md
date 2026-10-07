# Posterior Diagnostics for FitMplus

The function computes parameter-level posterior summaries and Markov
chain Monte Carlo diagnostics from the posterior draws saved by
[`FitMplus()`](https://github.com/jeksterslab/manMetaVAR/reference/FitMplus.md).

## Usage

``` r
FitMplusDiagnostics(object, burnin = NULL, level = 0.95)
```

## Arguments

- object:

  Object of class `manmetavar.mplus` returned by
  [`FitMplus()`](https://github.com/jeksterslab/manMetaVAR/reference/FitMplus.md).

- burnin:

  Integer indicating the number of initial draws to discard from each
  chain. If `burnin = NULL`, use `object$burnin`.

- level:

  Numeric value indicating the credibility level.

## Value

An object of class `manmetavar.mplus.diagnostics` containing a
parameter-level diagnostics data frame and a run-level diagnostics data
frame.

## See also

Other Model Fitting Functions:
[`FitDTVAR()`](https://github.com/jeksterslab/manMetaVAR/reference/FitDTVAR.md),
[`FitMetaVAR()`](https://github.com/jeksterslab/manMetaVAR/reference/FitMetaVAR.md),
[`FitMplus()`](https://github.com/jeksterslab/manMetaVAR/reference/FitMplus.md),
[`FitNaive()`](https://github.com/jeksterslab/manMetaVAR/reference/FitNaive.md),
[`MplusInput()`](https://github.com/jeksterslab/manMetaVAR/reference/MplusInput.md)

## Examples

``` r
if (FALSE) { # \dontrun{
seed <- 42
data <- GenData(taskid = 1, seed = seed)
fit <- FitMplus(data = data, seed = seed)
diagnostics <- FitMplusDiagnostics(fit)
diagnostics$parameters
diagnostics$run
} # }
```
