# Plot RMSE

Plot RMSE for the fixed and random effects.

## Usage

``` r
FigRMSE(
  results,
  dynamics = 1,
  method = c("MetaVAR", "SeqVAR", "BMLVAR"),
  zero = FALSE,
  ylim = c(0, 0.25)
)
```

## Arguments

- results:

  `results` data frame.

- dynamics:

  `1`, `2`, or `3`. `1` for stable reciprocal regulation, `2` for
  escalating co-activation, and `3` for adaptive recovery.

- method:

  Character vector. Methods to include in the plot.

- zero:

  Logical. Remove cases where the population parameter is equal to zero.

- ylim:

  Numeric vector of length 2. Lower and upper limits for the y-axis.

## See also

Other Figure Functions:
[`FigBias()`](https://github.com/jeksterslab/manMetaVAR/reference/FigBias.md),
[`FigCoverage()`](https://github.com/jeksterslab/manMetaVAR/reference/FigCoverage.md),
[`FigPower()`](https://github.com/jeksterslab/manMetaVAR/reference/FigPower.md),
[`FigType1Error()`](https://github.com/jeksterslab/manMetaVAR/reference/FigType1Error.md)

## Author

Ivan Jacob Agaloos Pesigan

## Examples

``` r
if (FALSE) { # \dontrun{
data(results, package = "manMetaVAR")
FigRMSE(results)
} # }
```
