# Summary: Calibration of Stage 1 Sampling Variances

For each admissible MetaVAR replication of a task, computes the ratio of
the between-person variance of the Stage 1 transition estimates to the
mean Stage 1 sampling variance. Under zero transition heterogeneity, a
ratio of one means that the Stage 1 sampling variances are calibrated; a
ratio above one means that they are too small.

## Usage

``` r
SumStage1Calibration(taskid, reps, output_folder, overwrite, integrity, ncores)
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

- ncores:

  Positive integer. Number of cores to use.

## Value

The output is saved as an external file in `output_folder`.

## Details

This function is executed via the `Sum` function.

## Author

Ivan Jacob Agaloos Pesigan
