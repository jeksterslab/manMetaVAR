# Plot Statistical Power

Plot statistical power probabilities for the fixed and random effects.

## Usage

``` r
FigPower(
  results,
  dynamics = 1,
  method = c("MetaVAR", "SeqVAR", "BMLVAR"),
  parameters = "both",
  ylim = c(0, 1),
  x_lab_size = 7.5
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

- parameters:

  Character string. Parameters to plot. Valid values include `"fixed"`,
  `"random"`, and `"both"`.

- ylim:

  Numeric vector of length 2. Lower and upper limits for the y-axis.

- x_lab_size:

  Numeric. x-axis label size.

## See also

Other Figure Functions:
[`FigBias()`](https://github.com/jeksterslab/manMetaVAR/reference/FigBias.md),
[`FigCoverage()`](https://github.com/jeksterslab/manMetaVAR/reference/FigCoverage.md),
[`FigRMSE()`](https://github.com/jeksterslab/manMetaVAR/reference/FigRMSE.md),
[`FigType1Error()`](https://github.com/jeksterslab/manMetaVAR/reference/FigType1Error.md)

## Author

Ivan Jacob Agaloos Pesigan

## Examples

``` r
if (FALSE) { # \dontrun{
data(results, package = "manMetaVAR")
FigPower(results)
} # }
```
