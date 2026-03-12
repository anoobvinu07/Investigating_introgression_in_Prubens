#!/bin/bash

#SBATCH --partition=bluemoon
#SBATCH --time=30:00:00
#SBATCH --nodes=10
#SBATCH --ntasks-per-node=2
#SBATCH --cpus-per-task=2
#request memory for entire job
#SBATCH --mem=900G
# (optional) --mem-per-cpu: requests memory per core (CPU)
#SBATCH --mail-user=ap1@uvm.edu
#SBATCH --mail-type=ALL
#SBATCH --job-name=MAF0.1filter_run2

spack load angsd@0.933

WD="/netfiles02/kellrlab/Anoob/Polygenic_Adaptation/ANALYSIS/filtering_the_snps_across_REGION"
ref="/netfiles02/kellrlab/datashare/ReferenceGenomes/Picea/Pmarianav1/assembly"
bam="/netfiles02/kellrlab/Anoob/Polygenic_Adaptation/ANALYSIS/black_spruce"
cd $WD

echo minMAF 0.2 filtering run2 
# Estimating genotype likelihood in output .beagle format for the polymorphic sites common in the three regional populations
count=`cat ${bam}/new_324RSfam_bam_VACC.list | wc -l`
angsd -b ${bam}/new_324RSfam_bam_VACC.list \
-ref ${ref}/Pmariana1.0-genome_reduced.fa \
-anc ${ref}/Pmariana1.0-genome_reduced.fa \
-fai ${ref}/Pmariana1.0-genome_reduced.fa.fai \
-out ./minMAF_filtering/Full_Sampling_minMAF_filtering_run2_0.1 \
-sites ./REGIONS/intersect.txt \
-rf ./REGIONS/intersect.chrs \
-nThreads 10 \
-uniqueOnly 1 \
-remove_bads 1 \
-trim 1 \
-C 50 \
-baq 1 \
-minMapQ 20 \
-minQ 20 \
-skipTriallelic 1 \
-SNP_pval 1e-6 \
-minMaf 0.1 \
-GL 1 \
-doHWE 1 \
-doGeno 32 \
-doPost 1 \
-doCounts 1 \
-doMaf 1 \
-doMajorMinor 1 \
-doGlf 2 \
-dobcf 1 \
-doSaf 1 \
-nInd ${count} \
-pest ./minMAF_filtering/Full_Sampling_minMAF_filtering_run1_0.1.sfs
