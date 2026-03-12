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
#SBATCH --job-name=MAF0.1filter

WD="/netfiles02/kellrlab/Anoob/Polygenic_Adaptation/ANALYSIS/filtering_the_snps_across_REGION"
ref="/netfiles02/kellrlab/datashare/ReferenceGenomes/Picea/Pmarianav1/assembly"
bam="/netfiles02/kellrlab/Anoob/Polygenic_Adaptation/ANALYSIS/black_spruce"
cd $WD

echo minMAF 0.1 filtering
# Estimating genotype likelihood in output .beagle format for the polymorphic sites common in the three regional populations
angsd -b ${bam}/new_324RSfam_bam_VACC.list \
-ref ${ref}/Pmariana1.0-genome_reduced.fa \
-anc ${ref}/Pmariana1.0-genome_reduced.fa \
-fai ${ref}/Pmariana1.0-genome_reduced.fa.fai \
-out ./minMAF_filtering/minMAF_0.1/Full_Sampling_minMAF_filtering_0.1 \
-sites ./REGIONS/intersect.txt \
-nThreads 8 \
-uniqueOnly 1 \
-remove_bads 1 \
-trim 1 \
-C 50 \
-baq 1 \
-minMapQ 20 \
-minQ 20 \
-SNP_pval 1e-6 \
-minInd 2 \
-setMinDepthInd 1 \
-setMaxDepthInd 17 \
-setMinDepth 15 \
-skipTriallelic 1 \
-doCounts 1 \
-minMaf 0.1 \
-GL 1 \
-doMaf 1 \
-doMajorMinor 4 \
-doGlf 2
