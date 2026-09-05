# Summarize Four-Variable Simulation Diagnostics

Summarizes the machine-readable status manifests, boundary or near-zero
heterogeneity diagnostics, and runtime for a simulation task.

## Usage

``` r
SumDiagnosticsK4(
  taskid,
  reps,
  output_folder,
  overwrite,
  integrity,
  naive,
  metavar,
  mplus,
  variance_tol = 1e-06,
  eigen_tol = 1e-08
)

SumDiagnostics(
  taskid,
  reps,
  output_folder,
  overwrite,
  integrity,
  naive,
  metavar,
  mplus,
  variance_tol = 1e-06,
  eigen_tol = 1e-08
)
```

## Arguments

- taskid:

  Positive integer. Task ID.

- reps:

  Positive integer. Number of replications.

- output_folder:

  Character string. Output folder.

- overwrite:

  Logical. Overwrite existing output in `output_folder`.

- integrity:

  Logical. If `integrity = TRUE`, check for the output file integrity
  when `overwrite = FALSE`.

- naive:

  Logical. If `naive = TRUE`, fit the naive approach.

- metavar:

  Logical. If `metavar = TRUE`, fit the model using the `metaDyn`
  package.

- mplus:

  Logical. If `mplus = TRUE`, fit the model using DSEM in `Mplus`.

- variance_tol:

  Numeric scalar. Variance estimates no greater than this value are
  classified as boundary estimates for ML-based methods and as near-zero
  estimates for Bayesian DSEM.

- eigen_tol:

  Numeric scalar. Estimated heterogeneity covariance matrices with
  minimum eigenvalues no greater than this value are classified as near
  singular.

## Value

The output is saved as an external file in `output_folder` and is
returned invisibly.
