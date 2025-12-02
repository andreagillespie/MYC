#!/bin/bash
 
#SBATCH --nodes=1
#SBATCH --ntasks=1
#SBATCH --mem-per-cpu=20G
#SBATCH --time=1-0:00:00
#SBATCH --output=logs/deeptoolsMatrix%j.stdout
#SBATCH --mail-user=andrea.gillespie@petermac.org
#SBATCH --mail-type=END,TIME_LIMIT_80
#SBATCH --job-name="DTMatrix"
#SBATCH --partition=prod_med

module load deeptools/3.5.0

computeMatrix scale-regions -S \
bigwigs/LATE-3ND-H3K27me3-R1_S2_RPGCnorm.bw bigwigs/LATE-3ND-H3K27me3-R2_S7_RPGCnorm.bw \
bigwigs/LATE-3NP-H3K27me3-R1_S52_RPGCnorm.bw bigwigs/LATE-3NP-H3K27me3-R2_S10_RPGCnorm.bw \
bigwigs/LATE-3dD-H3K27me3-R1_S55_RPGCnorm.bw bigwigs/LATE-3dD-H3K27me3-R2_S14_RPGCnorm.bw \
bigwigs/LATE-3dP-H3K27me3-R1_S22_RPGCnorm.bw bigwigs/LATE-3dP-H3K27me3-R2_S17_RPGCnorm.bw \
-R /data/reference/dawson_labs/bed_files/Hg38/Hg38EnsGeneStrandPlusMinusWhitelist.bed -a 3000 -b 3000 -m 5000 -o DTmatrices/DTmatrix_LATE_H3K27me3_RPGCnorm_allGenes.gz

plotHeatmap -m DTmatrices/DTmatrix_LATE_H3K27me3_RPGCnorm_allGenes.gz --sortUsingSamples 1 --sortUsing sum \
--samplesLabel 3ND-H3K27me3-R1 3ND-H3K27me3-R2 3NP-H3K27me3-R1 3NP-H3K27me3-R2 3dD-H3K27me3-R1 3dD-H3K27me3-R2 3dP-H3K27me3-R1 3dP-H3K27me3-R2 \
--colorMap GnBu --regionsLabel "all genes" \
-o plots/Heatmap_LATE_H3K27me3_RPGCnorm_allGenes.pdf --plotTitle "CUT&RUN LATE H3K27me3 all genes"

