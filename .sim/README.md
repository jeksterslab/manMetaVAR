# Simulation Workflow

## Project Setup

Clone the repository directly into the scratch filesystem:

```bash
PROJECT=manMetaVAR
git clone "git@github.com:jeksterslab/${PROJECT}.git" \
  "/scratch/$USER/$PROJECT"
chmod -R 755 "/scratch/$USER/$PROJECT"
```

The simulation scripts are located in:

```text
/scratch/$USER/manMetaVAR/.sim
```

Adjust the permissions separately if collaborators require write access to the
project directory.

## Apptainer Image

Build or request `manmetavar.sif`, then place it in:

```text
/scratch/$USER/manMetaVAR/.sif/manmetavar.sif
```

The image used for these simulations is archived on
[OSF](https://osf.io/e4cvz/).

Make the image readable and executable:

```bash
chmod 755 "/scratch/$USER/$PROJECT/.sif/manmetavar.sif"
```

## Production Design

The current production configuration is:

- `k = 2`: task IDs 1 through 36, with 1,000 replications per task;
- `k = 4`: task ID 9 only, with 1,000 replications. This is the prespecified
  higher-dimensional feasibility condition.

The replication count is defined in `sim-args.R` and `sim-k4-args.R`.

## Main Simulation Workflow

Run the simulation, checking, compression, and summarization stages in order.
The commands below use SLURM dependencies so that each stage begins only after
the preceding stage completes successfully.

The ordinary `sum.R` and `sum-k4.R` jobs generate both the performance
summaries and the new diagnostics. Performance summary files include the
simulation-level Monte Carlo standard errors. Diagnostic summary files include
status/full-pipeline information, boundary or near-zero diagnostics, and
runtime summaries.

## Simulation Status and Failure Handling

Simulation outcomes distinguish genuine estimation problems from technical
failures in the simulation infrastructure. This distinction determines whether
a replication is retained as an observed simulation outcome or requires repair
before the workflow can proceed.

The status manifest uses the following failure classes:

| Status | Meaning | Workflow behavior |
|---|---|---|
| `ok` | The fit is readable, converged, and admissible. | Included in numerical performance summaries. |
| `estimation_error` | The estimator was invoked but returned an error rather than a usable fit. | Retained as a genuine estimation outcome; does not cause the check stage to fail. |
| `upstream_failure` | A downstream estimation step could not be attempted because a required upstream estimation step had a recorded genuine failure. | Retained as a genuine pipeline outcome; does not cause the check stage to fail. |
| `nonconvergence` | The estimator returned a readable fit, but the prespecified convergence criterion was not satisfied. | Retained as a genuine estimation outcome; excluded from numerical performance summaries. |
| `inadmissible` | The estimator converged but the resulting fit failed the prespecified admissibility criteria. | Retained as a genuine estimation outcome; excluded from numerical performance summaries. |
| `missing_file` | An expected simulation artifact is absent and no recorded estimation failure explains its absence. | Treated as a repair-required technical failure; the check stage exits with a nonzero status. |
| `unreadable_file` | An expected simulation artifact exists but cannot be read. | Treated as a repair-required technical failure; the check stage exits with a nonzero status. |
| `infrastructure_error` | A technical problem occurred outside the estimator, such as an unavailable executable, unreadable attempt record, or failure to persist an output artifact. | Treated as a repair-required technical failure; the check stage exits with a nonzero status. |
| `check_error` | The diagnostic or status-checking code itself failed while evaluating a simulation artifact. | Treated as a repair-required technical failure; the check stage exits with a nonzero status. |

Thus, `estimation_error`, `upstream_failure`, `nonconvergence`, and
`inadmissible` are outcomes of the simulation and are not automatically rerun
or treated as missing data. Their frequencies are retained in the diagnostic
summaries.

By contrast, `missing_file`, `unreadable_file`, `infrastructure_error`, and
`check_error` indicate that the simulation results cannot yet be interpreted
as complete. The status manifest is written before the check stage fails so
that the affected replications can be identified and repaired.

Numerical performance summaries such as bias, RMSE, coverage, power, and
Type I error are calculated from replications with successful and admissible
estimates for the stages required by the corresponding method. The requested
number of replications and the number actually contributing to each
performance summary are retained separately so that estimator failures are not
silently removed from the simulation denominator.

The SLURM workflow uses `afterok` dependencies. Genuine estimation outcomes do
not make the simulation or check jobs fail, whereas repair-required technical
failures produce a nonzero check-stage exit status and therefore prevent the
compression and summarization stages from starting automatically.

### Two-Variable Simulation

```bash
cd "/scratch/$USER/$PROJECT/.sim"

SIM_JOB=$(sbatch --parsable sim.sh)
CHECK_JOB=$(sbatch --parsable --dependency="afterok:${SIM_JOB}" check.sh)
COMPRESS_JOB=$(sbatch --parsable --dependency="afterok:${CHECK_JOB}" compress.sh)
SUM_JOB=$(sbatch --parsable --dependency="afterok:${COMPRESS_JOB}" sum.sh)
```

### Four-Variable Simulation

```bash
cd "/scratch/$USER/$PROJECT/.sim"

SIM_K4_JOB=$(sbatch --parsable sim-k4.sh)
CHECK_K4_JOB=$(sbatch --parsable --dependency="afterok:${SIM_K4_JOB}" check-k4.sh)
COMPRESS_K4_JOB=$(sbatch --parsable --dependency="afterok:${CHECK_K4_JOB}" compress-k4.sh)
SUM_K4_JOB=$(sbatch --parsable --dependency="afterok:${COMPRESS_K4_JOB}" sum-k4.sh)
```

## Diagnostics-Only Summaries

`Sum()` and `SumK4()` already generate diagnostic summaries. The separate
scripts below are provided so that diagnostics can be regenerated without
rerunning all performance summaries. This is useful after changing a boundary
tolerance, runtime reporting rule, status definition, or diagnostics code.

### Recreate k = 2 diagnostics

```bash
cd "/scratch/$USER/$PROJECT/.sim"
sbatch sum-diagnostics.sh
```

### Recreate k = 4 diagnostics

```bash
cd "/scratch/$USER/$PROJECT/.sim"
sbatch sum-diagnostics-k4.sh
```

By default, an existing valid diagnostic summary is retained. To force the
diagnostic RDS files to be recreated, submit with:

```bash
sbatch --export=ALL,OVERWRITE_DIAGNOSTICS=1 sum-diagnostics.sh
sbatch --export=ALL,OVERWRITE_DIAGNOSTICS=1 sum-diagnostics-k4.sh
```

The default diagnostic thresholds are:

```text
variance_tol = 1e-6
eigen_tol    = 1e-8
```

They can be overridden without editing the R scripts. For example:

```bash
sbatch \
  --export=ALL,OVERWRITE_DIAGNOSTICS=1,VARIANCE_TOL=1e-7,EIGEN_TOL=1e-9 \
  sum-diagnostics.sh
```

Use alternative thresholds only as a sensitivity analysis. The thresholds used
for the manuscript should be prespecified and reported.

## Cross-Task Diagnostics Overview

After both the `k = 2` and `k = 4` summaries exist, create a compact overview:

```bash
cd "/scratch/$USER/$PROJECT/.sim"
sbatch diagnostics-overview.sh
```

If the two main summary jobs are submitted together, the overview can be made
dependent on both jobs:

```bash
OVERVIEW_JOB=$(sbatch --parsable \
  --dependency="afterok:${SUM_JOB}:${SUM_K4_JOB}" \
  diagnostics-overview.sh)
```

The overview job requires all 36 `k = 2` diagnostic summaries and the `k = 4`
task-9 diagnostic summary. It writes an RDS file and CSV tables under:

```text
.sim/manMetaVAR/diagnostics-overview/
```

The exported tables include:

- `status-summary-k2.csv` and `status-summary-k4.csv`;
- `boundary-parameter-k2.csv` and `boundary-parameter-k4.csv`;
- `boundary-replication-k2.csv` and `boundary-replication-k4.csv`;
- `runtime-k2.csv` and `runtime-k4.csv`;
- `performance-mcse-k2.csv` and `performance-mcse-k4.csv`;
- Mplus parameter-level diagnostic summaries; and
- Mplus run-level diagnostic summaries.

The performance CSVs are collected from the ordinary performance summary RDS
files and therefore retain the new simulation-level MCSE columns for bias,
RMSE, coverage, rejection/detection, power, and Type I error.

## Recommended Final Sequence

For a full production run, the final cluster-side sequence is:

```text
simulate
  -> check/status manifests
  -> compress
  -> performance + diagnostics summaries
  -> diagnostics overview
```

The local `.setup/data-process` scripts can then copy/process the final summary
objects into package/manuscript data objects.
