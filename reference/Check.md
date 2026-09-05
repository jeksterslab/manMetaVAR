# Check Replication

Check Replication

## Usage

``` r
Check(taskid, repid, output_folder, naive, metavar, mplus)
```

## Arguments

- taskid:

  Positive integer. Task ID.

- repid:

  Positive integer. Replication ID.

- output_folder:

  Character string. Output folder.

- naive:

  Logical. If `naive = TRUE`, fit the naive approach.

- metavar:

  Logical. If `metavar = TRUE`, fit the model using the `metaDyn`
  package.

- mplus:

  Logical. If `mplus = TRUE`, fit the model using DSEM in `Mplus`.

## Value

The output is saved as an external file in `output_folder`.

## Author

Ivan Jacob Agaloos Pesigan
