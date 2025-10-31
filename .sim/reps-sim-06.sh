#!/bin/bash

#SBATCH --job-name=sim-06
#SBATCH --mail-user=r.jeksterslab@gmail.com
#SBATCH --mail-type=ALL
#SBATCH --nodes=1
#SBATCH --exclusive
#SBATCH --mem=128G
#SBATCH --time=2-00:00:00
#SBATCH --output=sim-06.out
#SBATCH --error=sim-06.err

# Define project variables
PROJECT=manMetaVAR
SIF=manmetavar.sif

# load parallel module ---------------------------------------------------------
module load parallel

# pre TMP ----------------------------------------------------------------------
mkdir -p /scratch/$USER/${PROJECT}/.sim/tmp
TODAY=$(date +"%Y-%m-%d-%H-%M-%S-%N")
PARALLEL_TMP_FOLDER=$(mktemp -d -q "/scratch/$USER/${PROJECT}/.sim/tmp/$TODAY-sim-06-XXXXXXXX")
trap 'rm -rf -- "$PARALLEL_TMP_FOLDER"' EXIT
echo "PARALLEL_TMP_FOLDER is $PARALLEL_TMP_FOLDER"
# ------------------------------------------------------------------------------

# indices ----------------------------------------------------------------------
repid_start_1=526
repid_end_1=550

repid_start_2=626
repid_end_2=650

repid_start_3=726
repid_end_3=750

repid_start_4=826
repid_end_4=850

repid_start_5=926
repid_end_5=950

taskid_start=1
taskid_end=27

# script -----------------------------------------------------------------------
cd /scratch/$USER/${PROJECT} || exit

# Define ranges manually
JOBLIST="${PARALLEL_TMP_FOLDER}/joblist.txt"
touch "$JOBLIST"

for repid in $(seq $repid_start_1 $repid_end_1); do
    for taskid in $(seq $taskid_start $taskid_end); do
        echo "$repid $taskid" >> "$JOBLIST"
    done
done

for repid in $(seq $repid_start_2 $repid_end_2); do
    for taskid in $(seq $taskid_start $taskid_end); do
        echo "$repid $taskid" >> "$JOBLIST"
    done
done

for repid in $(seq $repid_start_3 $repid_end_3); do
    for taskid in $(seq $taskid_start $taskid_end); do
        echo "$repid $taskid" >> "$JOBLIST"
    done
done

for repid in $(seq $repid_start_4 $repid_end_4); do
    for taskid in $(seq $taskid_start $taskid_end); do
        echo "$repid $taskid" >> "$JOBLIST"
    done
done

for repid in $(seq $repid_start_5 $repid_end_5); do
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
echo "sim-06.sh done"
# ------------------------------------------------------------------------------

# post TMP ---------------------------------------------------------------------
rm -rf -- "$PARALLEL_TMP_FOLDER"
trap - EXIT
exit
# ------------------------------------------------------------------------------
