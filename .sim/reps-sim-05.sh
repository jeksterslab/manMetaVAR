#!/bin/bash

#SBATCH --job-name=sim-05
#SBATCH --mail-user=r.jeksterslab@gmail.com
#SBATCH --mail-type=ALL
#SBATCH --nodes=1
#SBATCH --ntasks=4
#SBATCH --cpus-per-task=1
#SBATCH --mem=128G
#SBATCH --time=2-00:00:00
#SBATCH --output=sim-05.out
#SBATCH --error=sim-05.err

# Define project variables
PROJECT=manMetaVAR
SIF=manculta.sif

# load parallel module ---------------------------------------------------------
module load parallel

# pre TMP ----------------------------------------------------------------------
mkdir -p /scratch/$USER/${PROJECT}/.sim/tmp
TODAY=$(date +"%Y-%m-%d-%H-%M-%S-%N")
PARALLEL_TMP_FOLDER=$(mktemp -d -q "/scratch/$USER/${PROJECT}/.sim/tmp/$TODAY-sim-05-XXXXXXXX")
trap 'rm -rf -- "$PARALLEL_TMP_FOLDER"' EXIT
echo "PARALLEL_TMP_FOLDER is $PARALLEL_TMP_FOLDER"
# ------------------------------------------------------------------------------

# indices ----------------------------------------------------------------------
repid_start=500
repid_end=1

taskid_start=1
taskid_end=9

# script -----------------------------------------------------------------------
cd /scratch/$USER/${PROJECT} || exit

# Define ranges manually
JOBLIST="${PARALLEL_TMP_FOLDER}/joblist.txt"
touch "$JOBLIST"

for repid in $(seq $repid_start -1 $repid_end); do
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
echo "sim-05.sh done"
# ------------------------------------------------------------------------------

# post TMP ---------------------------------------------------------------------
rm -rf -- "$PARALLEL_TMP_FOLDER"
trap - EXIT
exit
# ------------------------------------------------------------------------------
