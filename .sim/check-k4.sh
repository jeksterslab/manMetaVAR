#!/bin/bash


#SBATCH --job-name=check-k4
#SBATCH --mail-user=r.jeksterslab@gmail.com
#SBATCH --mail-type=ALL
#SBATCH --nodes=1
#SBATCH --exclusive
#SBATCH --mem=0
#SBATCH --time=2-00:00:00
#SBATCH --output=check-k4.out
#SBATCH --error=check-k4.err

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
PARALLEL_TMP_FOLDER=$(mktemp -d -q "/scratch/$USER/${PROJECT}/.sim/tmp/$TODAY-check-k4-XXXXXXXX")
trap 'rm -rf -- "$PARALLEL_TMP_FOLDER"' EXIT
echo "PARALLEL_TMP_FOLDER is $PARALLEL_TMP_FOLDER"
# ------------------------------------------------------------------------------

# script -----------------------------------------------------------------------
repid_start=1
repid_end=10
taskid_start=9
taskid_end=9

cmd="apptainer exec \
     --bind /scratch/\$USER/${PROJECT}:/scratch/\$USER/${PROJECT} \
     /scratch/\$USER/${PROJECT}/.sif/${SIF} \
     Rscript /scratch/\$USER/${PROJECT}/.sim/check-k4.R {1} {2} && \
     echo sim taskid \$(printf \"%05d\" {2}) repid \$(printf \"%05d\" {1}) date \$(date '+%Y-%m-%d %H:%M:%S')"

cd /scratch/$USER/${PROJECT} || exit

parallel --tmpdir "$PARALLEL_TMP_FOLDER" \
    --colsep ' ' "$cmd" :::: <(
    for repid in $(seq $repid_start $repid_end); do
        for taskid in $(seq $taskid_start $taskid_end); do
            echo "$repid $taskid"
        done
    done
)
# ------------------------------------------------------------------------------

# done -------------------------------------------------------------------------
echo "check-k4.sh done"
# ------------------------------------------------------------------------------

# post TMP ---------------------------------------------------------------------
rm -rf -- "$PARALLEL_TMP_FOLDER"
trap - EXIT
exit
# ------------------------------------------------------------------------------
