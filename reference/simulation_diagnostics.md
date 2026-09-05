# Simulation Diagnostics

Simulation diagnostics generated from the machine-readable replication
status manifests. The objects contain convergence/admissibility counts,
boundary or near-zero heterogeneity diagnostics, and runtime summaries.

## Usage

``` r
data(simulation_diagnostics)
```

## Format

A list with components `thresholds`, `status`, `status_summary`,
`boundary_parameter_replications`, `boundary_parameter_summary`,
`boundary_replication_diagnostics`, `boundary_replication_summary`,
`runtime_replications`, and `runtime_summary`.
