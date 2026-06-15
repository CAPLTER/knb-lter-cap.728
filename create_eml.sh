#!/bin/bash
#SBATCH -c 1
#SBATCH -J create_eml
#SBATCH -o %j.out
#SBATCH -e %j.err
#SBATCH -t 0-01:00:00
#SBATCH --mem=128G
#SBATCH --mail-type=END
#SBATCH --mail-user=%u@asu.edu

export CONDA_PKGS_DIRS="${HOME}/.conda/pkgs"
mkdir -p "${CONDA_PKGS_DIRS}"

module purge

module load mamba/latest
module load r-4.4.2-gcc-12.1.0 raptor2-2.0.15-gcc-12.1.0 redland-1.0.17-gcc-12.1.0 rasqal-0.9.33-gcc-12.1.0

# mamba create -n ood -c conda-forge r=4.4 r-devtools r-eml r-tidyverse r-sf r-rcrossref r-diagrammer r-aws.s3 r-dbi r-raster=3.6_26 r-terra=1.7.78 -y

source activate ood

Rscript knb-lter-cap.728.R
