# Compact Bayesian Diagnostic Overview Across Simulation Conditions

Summarize Mplus Bayesian diagnostic failures across all simulation task
IDs at the Innovation, fixed-effect, and random-effect block level. This
compact overview is intended for manuscript figures and
reviewer-oriented prior sensitivity analyses. Use
[`FigMplusDiagnosticsHeatmap()`](https://github.com/jeksterslab/manMetaVAR/reference/FigMplusDiagnosticsHeatmap.md)
for parameter-level drill-down figures.

## Usage

``` r
FigMplusDiagnosticsOverview(
  diagnostics,
  comparison = "difference",
  diagnostic = "Any diagnostic",
  unit = "replication",
  taskid = NULL,
  target = NULL,
  rhat_threshold = 1.01,
  ess_threshold = 400,
  mcse_threshold = 0.05,
  relative_mcse = TRUE,
  grey_scale = FALSE,
  values = FALSE,
  label_threshold = 0.05
)
```

## Arguments

- diagnostics:

  An all-task diagnostics object containing a `parameters` data frame,
  or the parameter-level data frame itself.

- comparison:

  Character string. Use `"levels"` to show diagnostic failure rates
  under each prior specification or `"difference"` to show paired
  user-prior minus default-prior differences.

- diagnostic:

  Diagnostic failure panels to display. Available values are
  `"Any diagnostic"`, `"R-hat"`, `"Bulk ESS"`, `"Tail ESS"`, and
  `"Relative MCSE"` when `relative_mcse = TRUE`.

- unit:

  Character string controlling the unit summarized within each design
  cell. `"replication"` classifies a replication as failed when any
  parameter in the selected parameter block fails. `"parameter"`
  averages failure indicators across parameter-replication pairs.

- taskid:

  Optional positive integer task IDs to include.

- target:

  Optional parameter blocks to include. Available values are
  `"Innovation"`, `"FE"`, and `"RE"`.

- rhat_threshold:

  Numeric R-hat threshold.

- ess_threshold:

  Numeric bulk and tail ESS threshold.

- mcse_threshold:

  Numeric MCSE threshold.

- relative_mcse:

  Logical. If `TRUE`, Monte Carlo standard errors are divided by the
  posterior standard deviation before classifying failures.

- grey_scale:

  Logical. If `TRUE`, use grey-scale fills.

- values:

  Logical. If `TRUE`, print values inside sufficiently large cells.

- label_threshold:

  Numeric value between zero and one. Labels with an absolute value
  smaller than this threshold are omitted. For level plots, the
  threshold applies directly to the failure rate.

## Value

A `ggplot` object. Its `data` element contains the block-level summaries
used in the figure.

## Details

The default `unit = "replication"` answers a reviewer-friendly question:
what proportion of simulation replications had at least one diagnostic
problem within each parameter block? For `comparison = "difference"`,
the function pairs prior specifications within task ID and replication
before calculating user-prior minus default-prior differences. Negative
values indicate fewer failures under user-specified priors.

## See also

Other Figure Functions:
[`FigMetricHeatmap()`](https://github.com/jeksterslab/manMetaVAR/reference/FigMetricHeatmap.md),
[`FigMplusDiagnosticsHeatmap()`](https://github.com/jeksterslab/manMetaVAR/reference/FigMplusDiagnosticsHeatmap.md),
[`FigOverview()`](https://github.com/jeksterslab/manMetaVAR/reference/FigOverview.md)

## Author

Ivan Jacob Agaloos Pesigan

## Examples

``` r
if (FALSE) { # \dontrun{
data(diagnostics, package = "manMetaVAR")

FigMplusDiagnosticsOverview(
  diagnostics = diagnostics,
  comparison = "levels"
)

FigMplusDiagnosticsOverview(
  diagnostics = diagnostics,
  comparison = "difference",
  values = TRUE
)
} # }
```
