# Simulation Replication - FitMplusK4 (User Defined Priors)

Simulation Replication - FitMplusK4 (User Defined Priors)

## Usage

``` r
SimFitMplusK4Priors(
  taskid,
  repid,
  output_folder,
  seed,
  suffix,
  overwrite,
  integrity,
  chains,
  iter,
  fscores,
  plot
)
```

## Arguments

- taskid:

  Positive integer. Task ID.

- repid:

  Positive integer. Replication ID.

- output_folder:

  Character string. Output folder.

- seed:

  Integer. Random seed.

- suffix:

  Character string. Simulation file suffix returned by `.SimSuffix()`.

- overwrite:

  Logical. Overwrite existing output in `output_folder`.

- integrity:

  Logical. If `integrity = TRUE`, check for the output file integrity
  when `overwrite = FALSE`.

- chains:

  Integer. Number of chains.

- iter:

  Integer. Number of iterations.

- fscores:

  Integer. Number of iterations for factor scores.

- plot:

  Logical. If `plot = TRUE`, add `PLOT: TYPE = PLOT3;` to `Mplus` input
  file.

## Value

The output is saved as an external file in `output_folder`.

## Details

This function is executed via the `SimK4` function.

## Author

Ivan Jacob Agaloos Pesigan
