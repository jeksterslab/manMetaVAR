# Bayesian (Mplus) Diagnostics

    #> Warning in data(diagnostics, package = "manMetaVAR"): data set 'diagnostics'
    #> not found

## Overview

The Bayesian simulation conditions were estimated in Mplus using the
default prior specification and the user-specified prior specification.
The figures below summarize convergence and Monte Carlo performance
across all simulation task IDs.

For the primary summaries, a replication is classified as having a
diagnostic failure within a parameter block when at least one parameter
in that block fails the requested criterion. The three parameter blocks
are the innovation covariance parameters, fixed effects, and random
effects. This block-level summary is more compact than displaying every
parameter in the main figure.

The default diagnostic thresholds are R-hat greater than 1.01, bulk or
tail effective sample size less than 400, and relative Monte Carlo
standard error greater than 0.05. Nonfinite diagnostics are classified
as failures.

## Overall diagnostic failure rates

### Default and user-specified priors

    #> Error:
    #> ! object 'diagnostics' not found

### Prior sensitivity

The following figure reports the paired difference in failure rates:

``` math
\text{user-specified priors} - \text{default priors}.
```

Negative values indicate fewer failures under the user-specified priors,
whereas positive values indicate more failures.

    #> Error:
    #> ! object 'diagnostics' not found

### Simulation-case sensitivity table

The block-level figure emphasizes broad patterns. The following table
retains each simulation case separately and reports the paired
user-prior minus default-prior difference in the percentage of
replications with at least one failed parameter in each block. Positive
values indicate more failures under the user-specified priors, whereas
negative values indicate fewer failures.

    #> Error:
    #> ! object 'diagnostics' not found
    #> Error:
    #> ! object 'diagnostic_sensitivity' not found
    #> Error:
    #> ! object 'diagnostic_sensitivity' not found
    #> Error:
    #> ! object 'diagnostic_sensitivity' not found
    #> Error in `rProject::VignettesPrecompile()`:
    #> ! object 'diagnostic_sensitivity' not found
    #> Error:
    #> ! object 'diagnostic_sensitivity' not found

## Sources of diagnostic failure

The next figure separates failures attributable to R-hat, bulk effective
sample size, tail effective sample size, and relative Monte Carlo
standard error. Cell labels are omitted to emphasize the overall
pattern.

    #> Error:
    #> ! object 'diagnostics' not found

## Alternative diagnostic thresholds

A compact threshold-sensitivity analysis can be produced by changing the
criteria while retaining the same block-level summary. The example below
uses R-hat greater than 1.05, effective sample size less than 200, and
relative Monte Carlo standard error greater than 0.10.

    #> Error:
    #> ! object 'diagnostics' not found

## Parameter-level follow-up figures

The block-level overview is intended for the manuscript or response to
reviewers. Parameter-level heatmaps can be used as supplementary
drill-down figures when a block shows meaningful diagnostic sensitivity.
To keep these figures legible, display one parameter family at a time
and omit cell labels.

\
`fixed_effect_parameters`` ``<-`` `[`c`](https://rdrr.io/r/base/c.html)`(`\
`  ``"mean(beta[1,1])"``,`\
`  ``"mean(beta[2,1])"``,`\
`  ``"mean(beta[1,2])"``,`\
`  ``"mean(beta[2,2])"``,`\
`  ``"mean(mu[1,1])"``,`\
`  ``"mean(mu[2,1])"`\
`)`\
\
[`FigMplusDiagnosticsHeatmap`](https://github.com/jeksterslab/manMetaVAR/reference/FigMplusDiagnosticsHeatmap.md)`(`\
`  diagnostics ``=`` ``diagnostics``,`\
`  metric_name ``=`` ``"failure_rate"``,`\
`  comparison ``=`` ``"difference"``,`\
`  diagnostic ``=`` ``"Any diagnostic"``,`\
`  parm ``=`` ``fixed_effect_parameters``,`\
`  values ``=`` ``FALSE`\
`)`

Raw R-hat, effective sample size, and Monte Carlo standard-error
differences are generally less interpretable as primary figures because
they use very different numerical scales. Threshold-based failure rates
provide a common and directly interpretable sensitivity metric. The
continuous diagnostics can still be inspected for selected parameters
when needed.

## Extracting plotted summaries

Each figure retains the values used to construct the heatmap. These
summaries can be used for manuscript tables or reviewer-response text.

    #> Error:
    #> ! object 'diagnostics' not found
    #> Error:
    #> ! object 'diagnostic_plot' not found
