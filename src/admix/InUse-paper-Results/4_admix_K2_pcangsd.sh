#!/bin/bash

#SBATCH --partition=short
#SBATCH --time=0-03:00:00
#SBATCH --nodes=1
#SBATCH --ntasks-per-node=1
#SBATCH --cpus-per-task=24
#request memory for entire job
#SBATCH --mem=800G
# (optional) --mem-per-cpu: requests memory per core (CPU)
#SBATCH --mail-user=ap1@uvm.edu
#SBATCH --mail-type=ALL
#SBATCH --job-name=admix-K2

# installing PCANGSD
# git clone https://github.com/Rosemeis/pcangsd.git
# move into the folder containing setup.py with collowing cd command
# cd pcangsd
#spack load python@3.7.7%gcc@8.4.0
# conda env create -f environment.yml
# conda activate pcangsd
# pip install -e .

# spack load angsd@0.933
#spack load python@3.7.7%gcc@8.4.0


WD="/netfiles02/kellrlab/Anoob/Polygenic_Adaptation/ANALYSIS/filtering_the_snps_across_REGION"
# PCANGSD="/users/a/p/ap1/Software/pcangsd/"

cd $WD

module load pcangsd/1.36.1

echo admix analysis
# Estimation of the covariance matrix and the genotype scores
# $PCANGSD/pcangsd/
pcangsd -b intersect_poly/324RSfam_18BSfam/Full_Sampling_intersect.beagle.gz -o $WD/admix/Full_Sampling_intersect_poly_updated_with_BS_samples_PCA_admix_K2 --threads 24 --dosage-save --sites-save --pi-save --maf-save --iter 100000 --admix --admix-K 2 -e 1

