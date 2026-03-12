#!/bin/bash

#SBATCH --partition=short
#SBATCH --time=0-03:00:00
#SBATCH --nodes=1
#SBATCH --ntasks-per-node=1
#SBATCH --cpus-per-task=5
#request memory for entire job
#SBATCH --mem=500G
# (optional) --mem-per-cpu: requests memory per core (CPU)
#SBATCH --mail-user=ap1@uvm.edu
#SBATCH --mail-type=ALL
#SBATCH --job-name=pcangsd


WD="/netfiles02/kellrlab/Anoob/Polygenic_Adaptation/ANALYSIS/filtering_the_snps_across_REGION"

cd $WD

module load pcangsd/1.36.1

# Estimation of the covariance matrix and the genotype scores
# echo eigen 1 run started
# pcangsd -b minMAF_filtering/Full_Sampling_minMAF_filtering_run2_MAF0.1_July2025.beagle.gz -o $WD/selection/Full_Sampling_minMAF_filtering_run2_MAF0.1_eigen1_v2_July2025 --threads 5 --dosage-save --sites-save --maf-save --iter 10000 -e 1

# echo eigen 2 run started
# pcangsd -b minMAF_filtering/Full_Sampling_minMAF_filtering_run2_MAF0.1_July2025.beagle.gz -o $WD/selection/Full_Sampling_minMAF_filtering_run2_MAF0.1_eigen2_July2025 --threads 5 --dosage-save --sites-save --maf-save --iter 10000 -e 2


