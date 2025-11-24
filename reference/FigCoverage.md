# Plot Coverage Probabilities

Plot coverage probabilities for the fixed and random effects.

## Usage

``` r
FigCoverage(
  results,
  dynamics = 1,
  method = c("MetaVAR", "SeqVAR", "BMLVAR"),
  rm_zero = FALSE,
  ylim = c(0, 1)
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

- rm_zero:

  Logical. Remove cases where the population parameter is equal to zero.

- ylim:

  Numeric vector of length 2. Lower and upper limits for the y-axis.

## See also

Other Figure Functions:
[`FigBias()`](https://github.com/jeksterslab/manMetaVAR/reference/FigBias.md),
[`FigPower()`](https://github.com/jeksterslab/manMetaVAR/reference/FigPower.md),
[`FigRMSE()`](https://github.com/jeksterslab/manMetaVAR/reference/FigRMSE.md),
[`FigType1Error()`](https://github.com/jeksterslab/manMetaVAR/reference/FigType1Error.md)

## Author

Ivan Jacob Agaloos Pesigan

## Examples

``` r
if (FALSE) { # \dontrun{
data(results, package = "manMetaVAR")
FigCoverage(results)
} # }
```
