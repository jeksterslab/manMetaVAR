#! /bin/bash

#SBATCH --job-name=sum-k4
#SBATCH --mail-user=r.jeksterslab@gmail.com
#SBATCH --mail-type=ALL
#SBATCH --nodes=1
#SBATCH --exclusive
#SBATCH --mem=0
#SBATCH --time=2-00:00:00
#SBATCH --output=sum-k4.out
#SBATCH --error=sum-k4.err

PROJECT=/scratch/$USER/manMetaVAR
SIF=/scratch/$USER/manMetaVAR/.sif/manmetavar.sif

cd ${PROJECT}/.sim || exit
apptainer exec ${SIF} Rscript sum-k4.R
