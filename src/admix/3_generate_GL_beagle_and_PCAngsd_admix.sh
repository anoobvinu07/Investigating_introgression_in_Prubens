#!/bin/bash

#SBATCH --partition=general
#SBATCH --time=2-00:00:00
#SBATCH --nodes=1
#SBATCH --ntasks-per-node=1
#SBATCH --cpus-per-task=8
#request memory for entire job
#SBATCH --mem=600G
# (optional) --mem-per-cpu: requests memory per core (CPU)
#SBATCH --mail-user=ap1@uvm.edu
#SBATCH --mail-type=ALL
#SBATCH --job-name=admix_beagle

module load gcc/13.3.0-xp3epyt
module load angsd

WD="/netfiles02/kellrlab/Anoob/Polygenic_Adaptation/ANALYSIS/filtering_the_snps_across_REGION"
ref="/netfiles02/kellrlab/datashare/ReferenceGenomes/Picea/Pmarianav1/assembly"
cd $WD

echo minMAF 0.1 filtering admix run 
# Estimating genotype likelihood in output .beagle format for the polymorphic sites common in the three regional populations
count=`cat ${WD}/REGIONS/324RSfam_18BSfam_bam_VACC.list | wc -l`
angsd -b ${WD}/REGIONS/324RSfam_18BSfam_bam_VACC.list \
-ref ${ref}/Pmariana1.0-genome_reduced.fa \
-anc ${ref}/Pmariana1.0-genome_reduced.fa \
-fai ${ref}/Pmariana1.0-genome_reduced.fa.fai \
-out ./minMAF_filtering/Full_Sampling_minMAF_filtering_admix \
-sites ./REGIONS/intersect_admix.txt \
-rf ./REGIONS/intersect_admix.chrs \
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
-SNP_pval 1e-6 \
-minMaf 0.1 \
-GL 1 \
-doCounts 1 \
-doMaf 1 \
-doMajorMinor 1 \
-doGlf 2 \
-nInd ${count}

# PCAngsd 
module load pcangsd/1.36.1

pcangsd -b minMAF_filtering/Full_Sampling_minMAF_filtering_admix.beagle.gz -o $WD/selection/Full_Sampling_minMAF_filtering_admix_K2_e1_July2025 --threads 8 --dosage-save --sites-save --maf-save --iter 10000 --admix --admix-K 2 -e 1