#! /bin/bash
#SBATCH --nodes=1
#SBATCH --exclusive
#SBATCH --mem=0
#SBATCH --time=2-00:00:00
#SBATCH --output=make.out
#SBATCH --error=make.err

# Define project variables
PROJECT=/scratch/$USER/manMetaVAR
# SIF=/scratch/$USER/manMetaVAR/.sif/manculta.sif
SIF=/scratch/$USER/sif/docs.sif

# clean

## vignettes
rm -rf ${PROJECT}/vignettes/sim-*.Rmd

## data
rm -rf ${PROJECT}/data/*.rda
rm -rf ${PROJECT}/R/*.rda
# rm -rf ${PROJECT}/.setup/data-raw/sim-rep-*.Rds

## latex
rm -rf ${PROJECT}/.setup/latex/figures/pdf/*.pdf
rm -rf ${PROJECT}/.setup/latex/figures/png/*.png

# make

cd ${PROJECT} || exit
apptainer exec ${SIF} make all

# remake

cd ${PROJECT} || exit
cp ${PROJECT}/vignettes/*.png ${PROJECT}/.setup/latex/figures/png
apptainer exec ${SIF} make all

# push

cd ${PROJECT} || exit
apptainer exec ${SIF} make auto
