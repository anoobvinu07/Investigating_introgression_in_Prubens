#!/bin/bash

#SBATCH --partition=bluemoon
#SBATCH --time=30:00:00
#SBATCH --nodes=10
#SBATCH --ntasks-per-node=1
#SBATCH --cpus-per-task=30
#request memory for entire job
#SBATCH --mem=900G
# (optional) --mem-per-cpu: requests memory per core (CPU)
#SBATCH --mail-user=ap1@uvm.edu
#SBATCH --mail-type=ALL
#SBATCH --job-name=pcangsd

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


conda activate pcangsd

module load gcc/10.5.0

echo first run started
# Estimation of the covariance matrix and the genotype scores
# $PCANGSD/pcangsd/
pcangsd -b minMAF_filtering/Full_Sampling_minMAF_filtering_run2_0.1.beagle.gz -o $WD/selection/Full_Sampling_minMAF_filtering_run2_0.1_PCA --selection --threads 30 --dosage_save --sites_save --pi_save --maf_save --snp_weights --pcadapt --iter 1000 --admix

