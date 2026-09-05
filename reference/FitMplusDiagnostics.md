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
[`FitDTVARK4()`](https://github.com/jeksterslab/manMetaVAR/reference/FitDTVARK4.md),
[`FitMetaVAR()`](https://github.com/jeksterslab/manMetaVAR/reference/FitMetaVAR.md),
[`FitMetaVARK4()`](https://github.com/jeksterslab/manMetaVAR/reference/FitMetaVARK4.md),
[`FitMplus()`](https://github.com/jeksterslab/manMetaVAR/reference/FitMplus.md),
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
data <- GenData(taskid = 1, seed = seed)
fit <- FitMplus(data = data, seed = seed)
diagnostics <- FitMplusDiagnostics(fit)
diagnostics$parameters
diagnostics$run
} # }
```
