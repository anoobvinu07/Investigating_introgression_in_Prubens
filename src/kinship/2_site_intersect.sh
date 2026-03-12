#!/bin/bash

#SBATCH --partition=bigmemwk
#SBATCH --time=7-00:00:00
#SBATCH --nodes=2
#SBATCH --ntasks-per-node=1
#SBATCH --cpus-per-task=1
#request memory for entire job
#SBATCH --mem=800G
# (optional) --mem-per-cpu: requests memory per core (CPU)
#SBATCH --mail-user=ap1@uvm.edu
#SBATCH --mail-type=ALL
#SBATCH --job-name=snp_filter

spack load angsd@0.933

WD="/netfiles02/kellrlab/Anoob/Polygenic_Adaptation/ANALYSIS/filtering_the_snps_across_REGION"
ref="/netfiles02/kellrlab/datashare/ReferenceGenomes/Picea/Pmarianav1/assembly"
bam="/netfiles02/kellrlab/Anoob/Polygenic_Adaptation/ANALYSIS/black_spruce"

cd $WD

# Finding loci intersection among regions
# zcat ./REGIONS/CORE/CORE.mafs.gz | awk 'BEGIN { OFS = ":" }{ print $1,$2 }' | sed '1d' | sort > ./REGIONS/CORE/CORE_sites.txt
# zcat ./REGIONS/EDGE/EDGE.mafs.gz | awk 'BEGIN { OFS = ":" }{ print $1,$2 }' | sed '1d' | sort > ./REGIONS/EDGE/EDGE_sites.txt
# zcat ./REGIONS/MARGIN/MARGIN.mafs.gz | awk 'BEGIN { OFS = ":" }{ print $1,$2 }' | sed '1d' | sort > ./REGIONS/MARGIN/MARGIN_sites.txt

# comm -12 ./REGIONS/CORE/CORE_sites.txt ./REGIONS/EDGE/EDGE_sites.txt > ./REGIONS/CORE_EDGE_sites.txt
# comm -12 ./REGIONS/CORE_EDGE_sites.txt ./REGIONS/MARGIN/MARGIN_sites.txt > ./REGIONS/CORE_EDGE_MARGIN_sites.txt

# sed 's/:/\t/' ./REGIONS/CORE_EDGE_MARGIN_sites.txt | sort -b -k1,1 > ./REGIONS/intersect.txt
# cut -f1 ./REGIONS/intersect.txt | uniq | sort > ./REGIONS/intersect.chrs
# angsd sites index ./REGIONS/intersect.txt

# Number of total sites with monomorphic and plolymorphic sites
# cat ./REGIONS/intersect.txt | wc -l # 1045535             # thibauts estimate: 30 823 071 sites


# Estimating genotype likelihood in output .beagle format for the polymorphic sites common in the three regional populations
count=`cat ${bam}/new_324RSfam_bam_VACC.list | wc -l`

angsd -b ${bam}/new_324RSfam_bam_VACC.list \
-ref ${ref}/Pmariana1.0-genome_reduced.fa \
-anc ${ref}/Pmariana1.0-genome_reduced.fa \
-fai ${ref}/Pmariana1.0-genome_reduced.fa.fai \
-out ./intersect_poly/Full_Sampling_intersect_poly \
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
-minMaf 0.003 \
-GL 1 \
-doHWE 1 \
-doGeno 32 \
-doPost 1 \
-doCounts 1 \
-doMaf 1 \
-doMajorMinor 1 \
-doGlf 2 \
-dobcf 1 \
-nInd ${count}