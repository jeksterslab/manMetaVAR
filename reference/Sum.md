# Summary

Summary

## Usage

``` r
Sum(
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

  Logical. If `naive = TRUE`, summarize naive estimates.

- metavar_normal:

  Logical. If `metavar_normal = TRUE`, summarize metaVAR model using
  normal confidence intervals.

- metavar_robust:

  Logical. If `metavar_robust = TRUE`, summarize metaVAR model using
  robust (sandwich) confidence intervals.

- mplus:

  Logical. If `mplus = TRUE`, summarize the DSEM model.

- ncores:

  Positive integer. Number of cores to use.

## Value

The output is saved as an external file in `output_folder`.

## Author

Anonymous
