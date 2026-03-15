# Plot Coverage Probabilities

Plot coverage probabilities for the fixed and random effects.

## Usage

``` r
FigCoverage(
  results,
  method = c("BMLVAR", "MetaVAR", "Naive"),
  parameters = "both",
  ylim = c(0.5, 1),
  x_lab_size = 6
)
```

## Arguments

- results:

  `results` data frame.

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
[`FigBiasSE()`](https://github.com/jeksterslab/manMetaVAR/reference/FigBiasSE.md),
[`FigPower()`](https://github.com/jeksterslab/manMetaVAR/reference/FigPower.md),
[`FigRMSE()`](https://github.com/jeksterslab/manMetaVAR/reference/FigRMSE.md)

## Author

Ivan Jacob Agaloos Pesigan

## Examples

``` r
if (FALSE) { # \dontrun{
data(results, package = "manMetaVAR")
FigCoverage(results)
} # }
```
