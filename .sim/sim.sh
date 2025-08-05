#!/bin/bash

#SBATCH --job-name=sim
#SBATCH --mail-user=r.jeksterslab@gmail.com
#SBATCH --mail-type=ALL
#SBATCH --nodes=1
#SBATCH --exclusive
#SBATCH --mem=0
#SBATCH --time=2-00:00:00
#SBATCH --output=sim.out
#SBATCH --error=sim.err

# Define project variables
PROJECT=manMetaVAR
SIF=manmetavar.sif

# load parallel module ---------------------------------------------------------
module load parallel

# pre TMP ----------------------------------------------------------------------
mkdir -p /scratch/$USER/${PROJECT}/.sim/tmp
TODAY=$(date +"%Y-%m-%d-%H-%M-%S-%N")
PARALLEL_TMP_FOLDER=$(mktemp -d -q "/scratch/$USER/${PROJECT}/.sim/tmp/$TODAY-sim-XXXXXXXX")
trap 'rm -rf -- "$PARALLEL_TMP_FOLDER"' EXIT
echo "PARALLEL_TMP_FOLDER is $PARALLEL_TMP_FOLDER"
# ------------------------------------------------------------------------------

# indices ----------------------------------------------------------------------
repid_start=1
repid_end=1000

taskid_start=1
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
     Rscript /scratch/\$USER/${PROJECT}/.sim/sim.R {1} {2}; \
     echo sim taskid \$(printf \"%05d\" {2}) repid \$(printf \"%05d\" {1}) date \$(date '+%Y-%m-%d %H:%M:%S')"

parallel --tmpdir "$PARALLEL_TMP_FOLDER" \
    --colsep ' ' "$cmd" :::: "$JOBLIST"
# ------------------------------------------------------------------------------

# done -------------------------------------------------------------------------
echo "sim.sh done"
# ------------------------------------------------------------------------------

# post TMP ---------------------------------------------------------------------
rm -rf -- "$PARALLEL_TMP_FOLDER"
trap - EXIT
exit
# ------------------------------------------------------------------------------
