#!/bin/bash

#SBATCH --partition=bluemoon
#SBATCH --time=30:00:00
#SBATCH --nodes=5
#SBATCH --ntasks-per-node=1
#SBATCH --cpus-per-task=1
#request memory for entire job
#SBATCH --mem=1000G
# (optional) --mem-per-cpu: requests memory per core (CPU)
#SBATCH --mail-user=ap1@uvm.edu
#SBATCH --mail-type=ALL
#SBATCH --job-name=snp_filter

spack load angsd@0.933

WD="/netfiles02/kellrlab/Anoob/Polygenic_Adaptation/ANALYSIS/filtering_the_snps_across_REGION"
ref="/netfiles02/kellrlab/datashare/ReferenceGenomes/Picea/Pmarianav1/assembly"

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
#cat ./REGIONS/intersect.txt | wc -l # 1045535             # thibauts estimate: 30 823 071 sites

# Re-launching the genotype likelihoods estimation by keeping only intersecting sites (monomorphic and polymorphic) and making the optimization step on the SFS
for POP in CORE EDGE MARGIN 
do
    (
	angsd -b ./REGIONS/${POP}_bam.list \
	-GL 1 \
	-out ./REGIONS/${POP}/${POP}_intersect \
	-ref ${ref}/Pmariana1.0-genome_reduced.fa \
	-anc ${ref}/Pmariana1.0-genome_reduced.fa \
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
	-doHWE 1 \
	-doGeno 32 \
	-doPost 1 \
	-doCounts 1 \
	-doMaf 1 \
	-doMajorMinor 1 \
	-doGlf 1 \
	-doSaf 1 \
	-fold 0 
    #EM optimization of the sfs
	realSFS ./REGIONS/${POP}/${POP}_intersect.saf.idx -maxIter 50000 -tole 1e-6 -P 4 > ./REGIONS/${POP}/${POP}_intersect.sfs
    echo "starting task $POP.."
    ) 
done