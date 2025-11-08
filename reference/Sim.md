# Simulation Replication

Simulation Replication

## Usage

``` r
Sim(
  taskid,
  repid,
  output_folder,
  overwrite,
  integrity,
  seed,
  data,
  metavar,
  mlvar,
  mplus,
  chains,
  iter,
  fscores,
  plot,
  default_priors
)
```

## Arguments

- taskid:

  Positive integer. Task ID.

- repid:

  Positive integer. Replication ID.

- output_folder:

  Character string. Output folder.

- overwrite:

  Logical. Overwrite existing output in `output_folder`.

- integrity:

  Logical. If `integrity = TRUE`, check for the output file integrity
  when `overwrite = FALSE`.

- seed:

  Integer. Random seed.

- data:

  Logical. Simulate data.

- metavar:

  Logical. If `metavar = TRUE`, fit the model using the `metaVAR`
  package.

- mlvar:

  Logical. If `mlvar = TRUE`, fit the model using the `mlVAR` package.

- mplus:

  Logical. If `mplus = TRUE`, fit the model using DSEM in `Mplus`.

- chains:

  Integer. Number of chains.

- iter:

  Integer. Number of iterations.

- fscores:

  Integer. Number of iterations for factor scores.

- plot:

  Logical. If `plot = TRUE`, add `PLOT: TYPE = PLOT3;` to `Mplus` input
  file.

- default_priors:

  Logical. If `default_priors = TRUE`, use default priors.

## Value

The output is saved as an external file in `output_folder`.

## Author

Ivan Jacob Agaloos Pesigan
