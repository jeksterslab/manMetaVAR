#!/bin/bash

#SBATCH --job-name=sim
#SBATCH --mail-user=r.jeksterslab@gmail.com
#SBATCH --mail-type=ALL
#SBATCH --nodes=1
#SBATCH --exclusive
#SBATCH --mem=0
#SBATCH --time=2-00:00:00
#SBATCH --output=/scratch/ibp5092/manMetaVAR/.sim/sim.out
#SBATCH --error=/scratch/ibp5092/manMetaVAR/.sim/sim.err

# load parallel module ---------------------------------------------------------
module load parallel

# pre TMP ----------------------------------------------------------------------
mkdir -p /scratch/ibp5092/manMetaVAR/.sim/tmp
TODAY=$(date +"%Y-%m-%d-%H-%M-%S-%N")
PARALLEL_TMP_FOLDER=$(mktemp -d -q "/scratch/ibp5092/manMetaVAR/.sim/tmp/$TODAY-sim-XXXXXXXX")
trap 'rm -rf -- "$PARALLEL_TMP_FOLDER"' EXIT
# ------------------------------------------------------------------------------

# script -----------------------------------------------------------------------
# {1} = repid
# {2} = taskid
cd /scratch/ibp5092/manMetaVAR
parallel                                                                 \
        --tmpdir "$PARALLEL_TMP_FOLDER"                                  \
        'apptainer exec                                                  \
        /scratch/ibp5092/manMetaVAR/.sif/manmetavar.sif                  \
        Rscript /scratch/ibp5092/manMetaVAR/.sim/sim.R {1} {2};          \
        echo sim taskid $(printf "%05d" {2}) repid $(printf "%05d" {1})' \
        ::: $(seq 1 1000)                                                \
        ::: $(seq 1 160)
echo "sim.sh done"
# ------------------------------------------------------------------------------

# post TMP ---------------------------------------------------------------------
rm -rf -- "$PARALLEL_TMP_FOLDER"
trap - EXIT
exit
# ------------------------------------------------------------------------------
