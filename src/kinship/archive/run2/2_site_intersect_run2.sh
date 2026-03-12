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

module load gcc/13.3.0-xp3epyt
module load angsd

WD="/netfiles02/kellrlab/Anoob/Polygenic_Adaptation/ANALYSIS/filtering_the_snps_across_REGION"
ref="/netfiles02/kellrlab/datashare/ReferenceGenomes/Picea/Pmarianav1/assembly"
bam="/netfiles02/kellrlab/Anoob/Polygenic_Adaptation/ANALYSIS/black_spruce"

cd $WD

# Finding loci intersection among regions
zcat ./REGIONS/CORE/CORE_run2.mafs.gz | awk 'BEGIN { OFS = ":" }{ print $1,$2 }' | sed '1d' | sort > ./REGIONS/CORE/CORE_run2_sites.txt
zcat ./REGIONS/EDGE/EDGE_run2.mafs.gz | awk 'BEGIN { OFS = ":" }{ print $1,$2 }' | sed '1d' | sort > ./REGIONS/EDGE/EDGE_run2_sites.txt
zcat ./REGIONS/MARGIN/MARGIN_run2.mafs.gz | awk 'BEGIN { OFS = ":" }{ print $1,$2 }' | sed '1d' | sort > ./REGIONS/MARGIN/MARGIN_run2_sites.txt

comm -12 ./REGIONS/CORE/CORE_run2_sites.txt ./REGIONS/EDGE/EDGE_run2_sites.txt > ./REGIONS/CORE_EDGE_run2_sites.txt
comm -12 ./REGIONS/CORE_EDGE_run2_sites.txt ./REGIONS/MARGIN/MARGIN_run2_sites.txt > ./REGIONS/CORE_EDGE_MARGIN_run2_sites.txt

# # intersect sites - for admix (RS+BS)
# sed 's/:/\t/' ./REGIONS/CORE_EDGE_MARGIN_run2_sites.txt | sort -b -k1,1 > ./REGIONS/intersect_run2.txt
# cut -f1 ./REGIONS/intersect_run2.txt | uniq | sort > ./REGIONS/intersect_run2.chrs
# angsd sites index ./REGIONS/intersect_run2.txt

# intersect sites - for Qpc (RS)
sed 's/:/\t/' ./REGIONS/CORE_EDGE_MARGIN_run2_sites.txt | sort -b -k1,1 > ./REGIONS/intersect_run2.txt
cut -f1 ./REGIONS/intersect_run2.txt | uniq | sort > ./REGIONS/intersect_run2.chrs
angsd sites index ./REGIONS/intersect_run2.txt

Number of total sites with monomorphic and plolymorphic sites
cat ./REGIONS/intersect_run2.txt | wc -l # 1045535             # thibauts estimate: 30 823 071 sites
