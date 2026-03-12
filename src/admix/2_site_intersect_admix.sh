#!/bin/bash

#SBATCH --partition=short
#SBATCH --time=0-03:00:00
#SBATCH --nodes=1
#SBATCH --ntasks-per-node=1
#SBATCH --cpus-per-task=10
#request memory for entire job
#SBATCH --mem=600G
# (optional) --mem-per-cpu: requests memory per core (CPU)
#SBATCH --mail-user=ap1@uvm.edu
#SBATCH --mail-type=ALL
#SBATCH --job-name=snp_filter

# sbatch --dependency=afterok:1036890 2_site_intersect_admix.sh

module load gcc/13.3.0-xp3epyt
module load angsd

WD="/netfiles02/kellrlab/Anoob/Polygenic_Adaptation/ANALYSIS/filtering_the_snps_across_REGION"
ref="/netfiles02/kellrlab/datashare/ReferenceGenomes/Picea/Pmarianav1/assembly"
bam="/netfiles02/kellrlab/Anoob/Polygenic_Adaptation/ANALYSIS/black_spruce"

cd $WD

# Finding loci intersection among regions
zcat ./REGIONS/BS/BS_run2.mafs.gz | awk 'BEGIN { OFS = ":" }{ print $1,$2 }' | sed '1d' | sort > ./REGIONS/BS/BS_run2_sites.txt

# # intersect sites - for admix (RS+BS)
comm -12 ./REGIONS/BS/BS_run2_sites.txt ./REGIONS/CORE_EDGE_MARGIN_sites.txt > ./REGIONS/CORE_EDGE_MARGIN_BS_admix_sites.txt

sed 's/:/\t/' ./REGIONS/CORE_EDGE_MARGIN_BS_admix_sites.txt | sort -b -k1,1 > ./REGIONS/intersect_admix.txt
cut -f1 ./REGIONS/intersect_admix.txt | uniq | sort > ./REGIONS/intersect_admix.chrs
angsd sites index ./REGIONS/intersect_admix.txt

# Number of total sites with monomorphic and plolymorphic sites
cat ./REGIONS/intersect_admix.txt | wc -l # sites 417,641

