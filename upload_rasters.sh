#!/bin/bash
#SBATCH -J upload
#SBATCH -o %j.out
#SBATCH -e %j.err
#SBATCH --mail-type=END
#SBATCH --mail-user=%u@asu.edu
#SBATCH -t 5-00:00:00
#SBATCH --nodes=1                       # Request a single node
#SBATCH --ntasks=1                      # Run a single task (your R script)
#SBATCH --cpus-per-task=12              # Request 12 CPU cores for the task
#SBATCH --mem=16G                       # Request of memory


export CONDA_PKGS_DIRS="${HOME}/.conda/pkgs"
mkdir -p "${CONDA_PKGS_DIRS}"

module purge

module load mamba/latest
module load r-4.4.2-gcc-12.1.0 raptor2-2.0.15-gcc-12.1.0 redland-1.0.17-gcc-12.1.0 rasqal-0.9.33-gcc-12.1.0

# mamba create -n ood -c conda-forge r=4.4 r-devtools r-eml r-tidyverse r-sf r-rcrossref r-diagrammer r-aws.s3 r-dbi r-raster=3.6_26 r-terra=1.7.78 -y

source activate ood

Rscript upload_rasters.R
