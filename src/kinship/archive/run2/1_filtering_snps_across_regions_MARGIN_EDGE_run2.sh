#!/bin/bash

#SBATCH --partition=general
#SBATCH --time=2-00:00:00
#SBATCH --nodes=1
#SBATCH --ntasks-per-node=1
#SBATCH --cpus-per-task=8
#request memory for entire job
#SBATCH --mem=800G
# (optional) --mem-per-cpu: requests memory per core (CPU)
#SBATCH --mail-user=ap1@uvm.edu
#SBATCH --mail-type=ALL
#SBATCH --job-name=MARGIN_EDGE_snp_filter

module load gcc/13.3.0-xp3epyt
module load angsd

WD="/netfiles02/kellrlab/Anoob/Polygenic_Adaptation/ANALYSIS/filtering_the_snps_across_REGION"
ref="/netfiles02/kellrlab/datashare/ReferenceGenomes/Picea/Pmarianav1/assembly"

cd $WD

# List of .bam files for each region
cat ./REGIONS/MARGIN_bam.list
cat ./REGIONS/EDGE_bam.list

# Estimating the genotype likelihoods and SFS for each regional population separately with all the sites (both mono- and poly-morphic sites by removing the SNP_val option)
for POP in  MARGIN EDGE
do
    (
	count=`cat ./REGIONS/${POP}_bam.list | wc -l`
	MAX=$(($count+$count+$count+$count+$count))
	angsd -b ./REGIONS/${POP}_bam.list \
	-ref ${ref}/Pmariana1.0-genome_reduced.fa \
	-anc ${ref}/Pmariana1.0-genome_reduced.fa \
	-out ./REGIONS/${POP}/${POP}_run2 \
	-nThreads 8 \
	-uniqueOnly 1 \
	-remove_bads 1 \
	-trim 1 \
	-C 50 \
	-baq 1 \
	-minMapQ 20 \
	-minQ 20 \
	-minInd 2 \
	-doCounts 1 \
	-setMinDepthInd 1 \
	-setMaxDepthInd 17 \
	-setMinDepth 15 \
	-setMaxDepth ${MAX} \
	-skipTriallelic 1  \
	-GL 1 \
	-doMaf 1 \
	-doMajorMinor 1 \
	-doGlf 2
    echo "starting task $POP.."
    ) 
done
