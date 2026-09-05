# Simulation Replication - FitMplusK4 Diagnostics

Simulation Replication - FitMplusK4 Diagnostics

## Usage

``` r
SimFitMplusK4Diagnostics(
  taskid,
  repid,
  output_folder,
  seed,
  suffix,
  overwrite,
  integrity
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

## Value

The output is saved as an external file in `output_folder`.

## Details

This function is executed via the `Simk4` function.

## Author

Ivan Jacob Agaloos Pesigan
