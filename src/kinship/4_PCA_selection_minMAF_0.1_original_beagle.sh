#!/bin/bash

#SBATCH --partition=general
#SBATCH --time=2-00:00:00
#SBATCH --nodes=1
#SBATCH --ntasks-per-node=1
#SBATCH --cpus-per-task=5
#request memory for entire job
#SBATCH --mem=500G
# (optional) --mem-per-cpu: requests memory per core (CPU)
#SBATCH --mail-user=ap1@uvm.edu
#SBATCH --mail-type=ALL
#SBATCH --job-name=run2_pcangsd


WD="/netfiles02/kellrlab/Anoob/Polygenic_Adaptation/ANALYSIS/filtering_the_snps_across_REGION"
# PCANGSD="/users/a/p/ap1/Software/pcangsd/"

cd $WD


module load pcangsd/1.36.1

echo eigen 1 run started
pcangsd -b minMAF_filtering/Full_Sampling_minMAF_filtering_run2_0.1.beagle.gz -o $WD/selection/Full_Sampling_minMAF_filtering_run2_0.1_PCA_eigen1_retest_July2025 --threads 5 --dosage-save --sites-save --maf-save --iter 10000

echo eigen 2 run started
pcangsd -b minMAF_filtering/Full_Sampling_minMAF_filtering_run2_0.1.beagle.gz -o $WD/selection/Full_Sampling_minMAF_filtering_run2_0.1_PCA_eigen2_retest_July2025 --threads 5 --dosage-save --sites-save --maf-save --iter 10000 -e 2

echo eigen 20 run started
# sbatch --dependency=afternotok:1036877 4_PCA_selection_minMAF_0.1_original_beagle.sh
pcangsd -b minMAF_filtering/Full_Sampling_minMAF_filtering_run2_0.1.beagle.gz -o $WD/selection/Full_Sampling_minMAF_filtering_run2_0.1_PCA_eigen20_retest_July2025 --threads 5 --dosage-save --sites-save --maf-save --iter 10000 -e 20
