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
#SBATCH --job-name=admix


WD="/netfiles02/kellrlab/Anoob/Polygenic_Adaptation/ANALYSIS/filtering_the_snps_across_REGION"
ref="/netfiles02/kellrlab/datashare/ReferenceGenomes/Picea/Pmarianav1/assembly"
bam="/netfiles02/kellrlab/Anoob/Polygenic_Adaptation/ANALYSIS/filtering_the_snps_across_REGION/REGIONS"

cd $WD

### index the black spruce bam files for fast lookup 
# bs_path="/netfiles02/kellrlab/datashare/Spruce/exome_capture/WES_mapping/Mapping_WES/ref_Pmariana/BWA/Pmariana/"
# for FILE in ${bs_path}*.sorted.rmdup.bam
# do
# 	samtools index ${FILE}
#done

module load gcc/13.3.0-xp3epyt
module load angsd


angsd -b ${bam}/324RSfam_18BSfam_bam_VACC.list \
-ref ${ref}/Pmariana1.0-genome_reduced.fa \
-anc ${ref}/Pmariana1.0-genome_reduced.fa \
-fai ${ref}/Pmariana1.0-genome_reduced.fa.fai \
-out ./intersect_poly/324RSfam_18BSfam/Full_Sampling_intersect \
-sites ./REGIONS/intersected_sites/RS_and_BS_intersected_sites/intersect.txt \
-nThreads 8 \
-uniqueOnly 1 \
-remove_bads 1 \
-trim 1 \
-C 50 \
-baq 1 \
-GL 1 \
-doGlf 2 \
-minMapQ 20 \
-minQ 20 \
-minInd 2 \
-setMinDepthInd 1 \
-setMaxDepthInd 17 \
-setMinDepth 15 \
-skipTriallelic 1  \
-doCounts 1 \
-doMaf 1 \
-doMajorMinor 4 \
-dumpCounts 2 \
-doDepth 1 \
-SNP_pval 1e-6 \
-minMaf 0.1