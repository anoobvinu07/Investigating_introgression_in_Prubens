#!/bin/bash

#SBATCH --partition=short
#SBATCH --time=3:00:00
#SBATCH --nodes=3
#SBATCH --ntasks-per-node=1
#SBATCH --cpus-per-task=24
#request memory for entire job
#SBATCH --mem=900G
# (optional) --mem-per-cpu: requests memory per core (CPU)
#SBATCH --mail-user=ap1@uvm.edu
#SBATCH --mail-type=ALL
#SBATCH --job-name=admix2


WD="/netfiles02/kellrlab/Anoob/Polygenic_Adaptation/ANALYSIS/filtering_the_snps_across_REGION"
# PCANGSD="/users/a/p/ap1/Software/pcangsd/"

module load pcangsd/1.36.1


echo 0#########################################0
echo eigen 2
echo 0#########################################0
pcangsd --beagle ${WD}/minMAF_filtering/minMAF_0.1/Full_Sampling_minMAF_filtering_0.1.beagle.gz -o ${WD}/minMAF_filtering/minMAF_0.1/Full_Sampling_minMAF_filtering_0.1_PCA_admix_K2_eigen2 --threads 24 --sites-save --dosage-save --pi-save --iter 100000 -e 2 --admix --admix-K 2 