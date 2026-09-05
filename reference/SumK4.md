# Summary for the Four-Variable Simulation

Summary for the Four-Variable Simulation

## Usage

``` r
SumK4(
  taskid,
  reps,
  output_folder,
  overwrite,
  integrity,
  naive,
  metavar_normal,
  metavar_robust,
  mplus,
  ncores
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

  Logical. Retained for consistency with
  [`SimK4()`](https://github.com/jeksterslab/manMetaVAR/reference/SimK4.md).
  The four-variable simulation does not currently fit a naive model.

- metavar_normal:

  Logical. If `TRUE`, summarize the four-variable metaVAR fits using
  normal confidence intervals.

- metavar_robust:

  Logical. If `TRUE`, summarize the four-variable metaVAR fits using
  robust confidence intervals.

- mplus:

  Logical. If `TRUE`, summarize the default- and user-prior
  four-variable DSEM fits and their diagnostics.

- ncores:

  Positive integer. Number of cores to use.

## Value

The output is saved as external files in `output_folder`.

## Author

Ivan Jacob Agaloos Pesigan
