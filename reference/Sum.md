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
  metavar,
  mlvar,
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

- metavar:

  Logical. If `metavar = TRUE`, fit the model using the `metaVAR`
  package.

- mlvar:

  Logical. If `mlvar = TRUE`, fit the model using the `mlVAR` package.

- mplus:

  Logical. If `mplus = TRUE`, fit the model using DSEM in `Mplus`.

- ncores:

  Positive integer. Number of cores to use.

## Value

The output is saved as an external file in `output_folder`.

## Author

Ivan Jacob Agaloos Pesigan
