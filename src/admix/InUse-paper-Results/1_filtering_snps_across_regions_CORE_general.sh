#!/bin/bash

#SBATCH --partition=general
#SBATCH --time=2-00
#SBATCH --nodes=1
#SBATCH --ntasks-per-node=1
#SBATCH --cpus-per-task=8
#request memory for entire job
#SBATCH --mem=900G
# (optional) --mem-per-cpu: requests memory per core (CPU)
#SBATCH --mail-user=ap1@uvm.edu
#SBATCH --mail-type=ALL
#SBATCH --job-name=gen_CORE_sites


WD="/netfiles02/kellrlab/Anoob/Polygenic_Adaptation/ANALYSIS/filtering_the_snps_across_REGION"
ref="/netfiles02/kellrlab/datashare/ReferenceGenomes/Picea/Pmarianav1/assembly"

cd $WD

# List of .bam files for each region
cat ./REGIONS/CORE_bam.list

# Estimating the genotype likelihoods for each regional population separately with all the sites (both mono- and poly-morphic sites by removing the SNP_val option)
for POP in CORE
do
    (
	angsd -b ./REGIONS/${POP}_bam.list \
	-ref ${ref}/Pmariana1.0-genome_reduced.fa \
	-anc ${ref}/Pmariana1.0-genome_reduced.fa \
	-out ./REGIONS/${POP}/${POP}_general \
	-nThreads 8 \
	-uniqueOnly 1 \
	-remove_bads 1 \
	-trim 1 \
	-C 50 \
	-baq 1 \
	-minMapQ 20 \
	-minQ 20 \
	-minInd 2 \
	-setMinDepthInd 1 \
	-setMaxDepthInd 17 \
	-setMinDepth 15 \
	-skipTriallelic 1  \
	-GL 1 \
	-doCounts 1 \
	-doMaf 1 \
	-doMajorMinor 4 \
	-doGlf 2 \
	-dumpCounts 2 \
	-doDepth 1
    echo "starting task $POP.."
    ) 
done
