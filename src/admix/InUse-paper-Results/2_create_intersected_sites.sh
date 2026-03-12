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
#SBATCH --job-name=snp_filter_with_BS_samples


WD="/netfiles02/kellrlab/Anoob/Polygenic_Adaptation/ANALYSIS/filtering_the_snps_across_REGION"
ref="/netfiles02/kellrlab/datashare/ReferenceGenomes/Picea/Pmarianav1/assembly"
bam="/netfiles02/kellrlab/Anoob/Polygenic_Adaptation/ANALYSIS/black_spruce"

cd $WD

# Finding loci intersection among regions
zcat ./REGIONS/CORE/CORE_general.mafs.gz | awk 'BEGIN { OFS = ":" }{ print $1,$2 }' | sed '1d' | sort > ./REGIONS/intersected_sites/CORE/CORE_sites.txt
zcat ./REGIONS/EDGE/EDGE_general.mafs.gz | awk 'BEGIN { OFS = ":" }{ print $1,$2 }' | sed '1d' | sort > ./REGIONS/intersected_sites/EDGE/EDGE_sites.txt
zcat ./REGIONS/MARGIN/MARGIN_general.mafs.gz | awk 'BEGIN { OFS = ":" }{ print $1,$2 }' | sed '1d' | sort > ./REGIONS/intersected_sites/MARGIN/MARGIN_sites.txt
zcat ./REGIONS/BS/BS.mafs.gz | awk 'BEGIN { OFS = ":" }{ print $1,$2 }' | sed '1d' | sort > ./REGIONS/intersected_sites/BS/BS_sites.txt

comm -12 ./REGIONS/intersected_sites/CORE/CORE_sites.txt ./REGIONS/intersected_sites/EDGE/EDGE_sites.txt > ./REGIONS/intersected_sites/RS_intersected_sites/CORE_EDGE_sites.txt
comm -12 ./REGIONS/intersected_sites/RS_intersected_sites/CORE_EDGE_sites.txt ./REGIONS/intersected_sites/MARGIN/MARGIN_sites.txt > ./REGIONS/intersected_sites/RS_intersected_sites/CORE_EDGE_MARGIN_sites.txt				
comm -12 ./REGIONS/intersected_sites/RS_intersected_sites/CORE_EDGE_MARGIN_sites.txt ./REGIONS/intersected_sites/BS/BS_sites.txt > ./REGIONS/intersected_sites/RS_and_BS_intersected_sites/CORE_EDGE_MARGIN_BS_sites.txt				

# intersect sites for only RS (324 families)
sed 's/:/\t/' ./REGIONS/intersected_sites/RS_intersected_sites/CORE_EDGE_MARGIN_sites.txt | sort -b -k1,1 > ./REGIONS/intersected_sites/RS_intersected_sites/intersect.txt
cut -f1 ./REGIONS/intersected_sites/RS_intersected_sites/intersect.txt | uniq | sort > ./REGIONS/intersected_sites/RS_intersected_sites/intersect.chrs
angsd sites index ./REGIONS/intersected_sites/RS_intersected_sites/intersect.txt

# intersect sites of RS (324 families) and BS (18 families)
sed 's/:/\t/' ./REGIONS/intersected_sites/RS_and_BS_intersected_sites/CORE_EDGE_MARGIN_BS_sites.txt | sort -b -k1,1 > ./REGIONS/intersected_sites/RS_and_BS_intersected_sites/intersect.txt
cut -f1 ./REGIONS/intersected_sites/RS_and_BS_intersected_sites/intersect.txt | uniq | sort > ./REGIONS/intersected_sites/RS_and_BS_intersected_sites/intersect.chrs
angsd sites index ./REGIONS/intersected_sites/RS_and_BS_intersected_sites/intersect.txt

# Number of total sites with monomorphic and plolymorphic sites
# sites info - 68,625,123 sites
cat ./REGIONS/intersected_sites/RS_intersected_sites/CORE_EDGE_MARGIN_sites.txt | wc -l  
# sites info - 32,120,629 sites
cat ./REGIONS/intersected_sites/RS_and_BS_intersected_sites/intersect.txt | wc -l 

# Estimating genotype likelihood in output .beagle format for the polymorphic sites common in the three regional populations
count=`cat ${bam}/new_332RSfam_18BSfam_bam_VACC.list | wc -l`

