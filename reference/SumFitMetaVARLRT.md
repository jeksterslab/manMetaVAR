# Summary: MetaVAR Boundary Likelihood Ratio Test

Applies
[`LRTMetaVAR()`](https://github.com/jeksterslab/manMetaVAR/reference/LRTMetaVAR.md)
to every admissible MetaVAR replication of a task and summarizes the
rejection rates at \\(\alpha = .05\\).

## Usage

``` r
SumFitMetaVARLRT(taskid, reps, output_folder, overwrite, integrity, ncores)
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
