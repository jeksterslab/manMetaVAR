# Plot RMSE

Plot RMSE for the fixed and random effects.

## Usage

``` r
FigRMSE(
  results,
  method = c("BMLVAR", "MetaVAR", "Naive"),
  parameters = "both",
  ylim = c(0, 0.25),
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
[`FigCoverage()`](https://github.com/jeksterslab/manMetaVAR/reference/FigCoverage.md),
[`FigPower()`](https://github.com/jeksterslab/manMetaVAR/reference/FigPower.md)

## Author

Ivan Jacob Agaloos Pesigan

## Examples

``` r
if (FALSE) { # \dontrun{
data(results, package = "manMetaVAR")
FigRMSE(results)
} # }
```
