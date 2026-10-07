# Load Both Prior Conditions of the Bundled Mplus Diagnostics

Loads and combines `diagnostics_default` and `diagnostics_priors` for
diagnostic plots and comparisons between prior specifications.

## Usage

``` r
LoadMplusDiagnostics()
```

## Value

A `manmetavar.mplus.diagnostics.all` object containing parameter and run
diagnostics for both prior conditions, in the original combined task,
method, replication, and parameter order.

## Examples

``` r
if (FALSE) { # \dontrun{
diagnostics <- LoadMplusDiagnostics()
FigMplusDiagnosticsHeatmap(diagnostics, comparison = "difference")
} # }
```
