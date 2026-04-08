# Results Heatmap

Plot results heatmap.

## Usage

``` r
FigMetricHeatmap(results, metric_name, grey_scale = FALSE, values = FALSE)
```

## Arguments

- results:

  `results` data frame.

- metric_name:

  Character string. `"coverage"` for coverage probability,
  `"abs_rel_bias"` for absolute value of the relative bias, `"rmse"` for
  RMSE, and `"power"` for statistical power.

- grey_scale:

  Logical. If `TRUE`, use a grey-scale fill suitable for black-and-white
  printing.

- values:

  Logical. If `TRUE`, display values inside tiles.

## See also

Other Figure Functions:
[`FigOverview()`](https://github.com/jeksterslab/manMetaVAR/reference/FigOverview.md)

## Author

Ivan Jacob Agaloos Pesigan

## Examples

``` r
if (FALSE) { # \dontrun{
data(results, package = "manMetaVAR")
FigMetricHeatmap(
  results = results,
  metric_name = "coverage"
)
} # }
```
