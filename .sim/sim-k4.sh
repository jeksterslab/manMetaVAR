#!/bin/bash


#SBATCH --job-name=sim-k4
#SBATCH --mail-user=r.jeksterslab@gmail.com
#SBATCH --mail-type=ALL
#SBATCH --nodes=1
#SBATCH --exclusive
#SBATCH --mem=0
#SBATCH --time=2-00:00:00
#SBATCH --output=sim-k4.out
#SBATCH --error=sim-k4.err

set -euo pipefail

# Define project variables
PROJECT=manMetaVAR
SIF=manmetavar.sif

# load parallel module ---------------------------------------------------------
if ! command -v parallel >/dev/null 2>&1; then
    module load parallel
fi
# ------------------------------------------------------------------------------

# pre TMP ----------------------------------------------------------------------
mkdir -p /scratch/$USER/${PROJECT}/.sim/tmp
TODAY=$(date +"%Y-%m-%d-%H-%M-%S-%N")
PARALLEL_TMP_FOLDER=$(mktemp -d -q "/scratch/$USER/${PROJECT}/.sim/tmp/$TODAY-sim-k4-XXXXXXXX")
trap 'rm -rf -- "$PARALLEL_TMP_FOLDER"' EXIT
echo "PARALLEL_TMP_FOLDER is $PARALLEL_TMP_FOLDER"
# ------------------------------------------------------------------------------

# indices ----------------------------------------------------------------------
repid_start=1
repid_end=10

taskid_start=9
taskid_end=9

# script -----------------------------------------------------------------------
cd /scratch/$USER/${PROJECT} || exit

# Define ranges manually
JOBLIST="${PARALLEL_TMP_FOLDER}/joblist.txt"
touch "$JOBLIST"

for repid in $(seq $repid_start $repid_end); do
    for taskid in $(seq $taskid_start $taskid_end); do
        echo "$repid $taskid" >> "$JOBLIST"
    done
done

cmd="apptainer exec \
     --bind /scratch/\$USER/${PROJECT}:/scratch/\$USER/${PROJECT} \
     /scratch/\$USER/${PROJECT}/.sif/${SIF} \
     Rscript /scratch/\$USER/${PROJECT}/.sim/sim-k4.R {1} {2} && \
     echo sim-k4 taskid \$(printf \"%05d\" {2}) repid \$(printf \"%05d\" {1}) date \$(date '+%Y-%m-%d %H:%M:%S')"

parallel --halt soon,fail=1 \
    --tmpdir "$PARALLEL_TMP_FOLDER" \
    --colsep ' ' "$cmd" :::: "$JOBLIST"
# ------------------------------------------------------------------------------

# done -------------------------------------------------------------------------
echo "sim-k4.sh done"
# ------------------------------------------------------------------------------

# post TMP ---------------------------------------------------------------------
rm -rf -- "$PARALLEL_TMP_FOLDER"
trap - EXIT
exit
# ------------------------------------------------------------------------------
