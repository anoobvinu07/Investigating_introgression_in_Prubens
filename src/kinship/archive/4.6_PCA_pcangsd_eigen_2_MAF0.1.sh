#!/bin/bash

#SBATCH --partition=general
#SBATCH --time=2-00
#SBATCH --nodes=1
#SBATCH --ntasks-per-node=1
#SBATCH --cpus-per-task=24
#request memory for entire job
#SBATCH --mem=900G
# (optional) --mem-per-cpu: requests memory per core (CPU)
#SBATCH --mail-user=ap1@uvm.edu
#SBATCH --mail-type=ALL
#SBATCH --job-name=kinship_pcangsd


WD="/netfiles02/kellrlab/Anoob/Polygenic_Adaptation/ANALYSIS/filtering_the_snps_across_REGION"
beagle="/netfiles02/kellrlab/Anoob/GWAS/output/red_spruce_beagle/red_spruce_fam324"

# PCANGSD="/users/a/p/ap1/Software/pcangsd/"

module load pcangsd/1.36.1


echo 0#########################################0
echo eigen 2
echo 0#########################################0
pcangsd --beagle ${beagle}/red_spruce_fam324_angsd@0.933.beagle.gz -o ${WD}/kinship_matrix/pcangsd/red_spruce_fam324_eigen2_MAF0.1 --threads 24 --sites-save --dosage-save --pi-save --maf 0.1 --maf-save --iter 100000 -e 2 