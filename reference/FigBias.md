# Plot Relative Bias

Plot relative bias for the fixed and random effects.

## Usage

``` r
FigBias(
  results,
  bias = TRUE,
  dynamics = 1,
  method = c("MetaVAR", "SeqVAR", "BMLVAR"),
  zero = FALSE
)
```

## Arguments

- results:

  `results` data frame.

- bias:

  Logical. If `bias = TRUE`, plot absolute bias. If `bias = FALSE`, plot
  relative bias. Note that when parameter value is equal to zero,
  absolute bias is used instead of relative bias.

- dynamics:

  `1`, `2`, or `3`. `1` for stable reciprocal regulation, `2` for
  escalating co-activation, and `3` for adaptive recovery.

- method:

  Character vector. Methods to include in the plot.

- zero:

  Logical. Remove cases where the population parameter is equal to zero.

## See also

Other Figure Functions:
[`FigCoverage()`](https://github.com/jeksterslab/manMetaVAR/reference/FigCoverage.md),
[`FigPower()`](https://github.com/jeksterslab/manMetaVAR/reference/FigPower.md),
[`FigRMSE()`](https://github.com/jeksterslab/manMetaVAR/reference/FigRMSE.md),
[`FigType1Error()`](https://github.com/jeksterslab/manMetaVAR/reference/FigType1Error.md)

## Author

Ivan Jacob Agaloos Pesigan

## Examples

``` r
if (FALSE) { # \dontrun{
data(results, package = "manMetaVAR")
FigBias(results)
} # }
```
