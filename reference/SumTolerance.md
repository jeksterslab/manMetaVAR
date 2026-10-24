# Summary: Tolerance Rates for Transition Heterogeneity

Reads the replication-level summaries of one task (MetaVAR with normal
and robust intervals, the uncertainty-uncorrected method, and DSEM with
default and user-specified priors) and computes, for each tolerance, the
proportions of replications returned by
[`Tolerance()`](https://github.com/jeksterslab/manMetaVAR/reference/Tolerance.md)
for the between-person variances and covariances of the transition
parameters.

## Usage

``` r
SumTolerance(
  taskid,
  reps,
  folder,
  delta = c(0, 1e-04, 0.00025, 4e-04, 5e-04, 9e-04, 0.001, 0.0025, 0.005, 0.01)
)
```

## Arguments

- taskid:

  Positive integer. Task ID.

- reps:

  Positive integer. Number of replications.

- folder:

  Character string. Folder with the summary files of the task.

- delta:

  Numeric vector. Tolerances.

## Value

A data frame with one row per method, interval type, parameter, and
tolerance.

## Author

Ivan Jacob Agaloos Pesigan
