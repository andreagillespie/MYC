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
bigwigs/EARLY-3ND-H3K27me3-R1_S23_RPGCnorm.bw bigwigs/EARLY-3NP-H3K27me3-R1_S26_RPGCnorm.bw \
bigwigs/EARLY-3dD-H3K27me3-R1_S29_RPGCnorm.bw bigwigs/EARLY-3dP-H3K27me3-R1_S32_RPGCnorm.bw \
-R /data/reference/dawson_labs/bed_files/Hg38/Hg38EnsGeneStrandPlusMinusWhitelist.bed -a 3000 -b 3000 -m 5000 -o DTmatrices/DTmatrix_EARLY_H3K27me3_RPGCnorm_allGenes.gz

plotHeatmap -m DTmatrices/DTmatrix_EARLY_H3K27me3_RPGCnorm_allGenes.gz --sortUsingSamples 1 --sortUsing sum \
--samplesLabel 3ND-H3K27me3 3NP-H3K27me3 3dD-H3K27me3 3dP-H3K27me3 \
--colorMap GnBu --regionsLabel "all genes" \
-o plots/Heatmap_EARLY_H3K27me3_RPGCnorm_allGenes.pdf --plotTitle "CUT&RUN EARLY H3K27me3 all genes"

