# Plot Relative Bias (Standard Errors)

Plot relative bias for the fixed and random effects standard errors.

## Usage

``` r
FigBiasSE(
  results,
  bias = FALSE,
  method = c("BMLVAR", "MetaVAR", "Naive"),
  parameters = "both",
  ylim = c(-0.15, 0.15),
  x_lab_size = 6
)
```

## Arguments

- results:

  `results` data frame.

- bias:

  Logical. If `bias = TRUE`, plot absolute bias. If `bias = FALSE`, plot
  relative bias. Note that when parameter value is equal to zero,
  absolute bias is used instead of relative bias.

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
[`FigPower()`](https://github.com/jeksterslab/manMetaVAR/reference/FigPower.md),
[`FigRMSE()`](https://github.com/jeksterslab/manMetaVAR/reference/FigRMSE.md)

## Author

Ivan Jacob Agaloos Pesigan

## Examples

``` r
if (FALSE) { # \dontrun{
data(results, package = "manMetaVAR")
FigBiasSE(results)
} # }
```
