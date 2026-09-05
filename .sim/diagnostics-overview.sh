#! /bin/bash

#SBATCH --job-name=diag-overview
#SBATCH --mail-user=r.jeksterslab@gmail.com
#SBATCH --mail-type=ALL
#SBATCH --nodes=1
#SBATCH --ntasks=1
#SBATCH --cpus-per-task=1
#SBATCH --mem=8G
#SBATCH --time=02:00:00
#SBATCH --output=diagnostics-overview.out
#SBATCH --error=diagnostics-overview.err

PROJECT=/scratch/$USER/manMetaVAR
SIF=/scratch/$USER/manMetaVAR/.sif/manmetavar.sif

cd ${PROJECT}/.sim || exit
apptainer exec ${SIF} Rscript diagnostics-overview.R
