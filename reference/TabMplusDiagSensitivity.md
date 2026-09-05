# Bayesian Diagnostic Failure-Rate Sensitivity Table

Create a simulation-case-level table of Bayesian Mplus diagnostic
failure rates. Unlike the overview figure, the function retains one row
for every simulation task ID and does not average across simulation
cases.

## Usage

``` r
TabMplusDiagSensitivity(
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
  output = "data.frame",
  scale = "percent",
  digits = 0L
)
```

## Arguments

- diagnostics:

  An all-task diagnostics object containing a `parameters` data frame,
  or the parameter-level data frame itself.

- comparison:

  Character string. `"difference"` returns paired user-prior minus
  default-prior failure-rate differences. `"levels"` returns the two
  prior-specific failure rates. `"all"` returns the default rate,
  user-prior rate, and paired difference.

- diagnostic:

  One or more diagnostic panels. Available values are
  `"Any diagnostic"`, `"R-hat"`, `"Bulk ESS"`, `"Tail ESS"`, and
  `"Relative MCSE"` when `relative_mcse = TRUE`.

- unit:

  Character string controlling the unit classified as failed.
  `"replication"` classifies a replication as failed when any parameter
  in the selected block fails. `"parameter"` averages failures over
  parameter-replication pairs.

- taskid:

  Optional positive integer task IDs to include.

- target:

  Optional parameter blocks to include. Available values are
  `"Innovation"`, `"FE"`, and `"RE"`.

- rhat_threshold:

  Numeric R-hat threshold.

- ess_threshold:

  Numeric bulk and tail effective sample size threshold.

- mcse_threshold:

  Numeric Monte Carlo standard error threshold.

- relative_mcse:

  Logical. If `TRUE`, Monte Carlo standard errors are divided by the
  posterior standard deviation before classifying failures.

- output:

  Character string. `"data.frame"` returns a wide data frame with
  simulation-design columns, `"matrix"` returns only the numeric
  case-by-summary matrix, and `"long"` returns one row per task, block,
  diagnostic, and prior comparison.

- scale:

  Character string. `"proportion"` returns values on the 0-to-1 scale.
  `"percent"` multiplies prior-specific failure rates by 100 and
  expresses differences in percentage points.

- digits:

  Nonnegative integer used to round the returned values.

## Value

A data frame or numeric matrix. For `output = "matrix"`, simulation
design information is stored in the `"case_data"` attribute.

## Details

Failure rates are computed separately within each task ID. For
`comparison = "difference"`, replications are paired before calculating
the user-prior minus default-prior difference. Negative differences
favor the user-specified priors.

The default `unit = "replication"` answers the question: within a given
simulation case, what percentage of replications had at least one failed
parameter in the selected parameter block?

## Author

Ivan Jacob Agaloos Pesigan

## Examples

``` r
if (FALSE) { # \dontrun{
data(diagnostics, package = "manMetaVAR")

# Compact sensitivity matrix: one row per simulation case
TabMplusDiagSensitivity(
  diagnostics = diagnostics,
  comparison = "difference",
  output = "matrix"
)

# Default, user-prior, and difference columns
TabMplusDiagSensitivity(
  diagnostics = diagnostics,
  comparison = "all",
  output = "data.frame"
)

# Diagnostic-specific table
TabMplusDiagSensitivity(
  diagnostics = diagnostics,
  comparison = "difference",
  diagnostic = c("R-hat", "Bulk ESS", "Tail ESS", "Relative MCSE")
)
} # }
```
