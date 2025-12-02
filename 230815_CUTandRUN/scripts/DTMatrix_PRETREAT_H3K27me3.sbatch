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
bigwigs/PRETREAT-3NEG-H3K27me3-R1_S36_RPGCnorm.bw bigwigs/PRETREAT-5NEG-H3K27me3-R2_S45_RPGCnorm.bw \
bigwigs/PRETREAT-3V-H3K27me3-R1_S40_RPGCnorm.bw bigwigs/PRETREAT-5V-H3K27me3-R2_S49_RPGCnorm.bw \
-R /data/reference/dawson_labs/bed_files/Hg38/Hg38EnsGeneStrandPlusMinusWhitelist.bed -a 3000 -b 3000 -m 5000 -o DTmatrices/DTmatrix_PRETREAT_H3K27me3_RPGCnorm_allGenes.gz

plotHeatmap -m DTmatrices/DTmatrix_PRETREAT_H3K27me3_RPGCnorm_allGenes.gz --sortUsingSamples 1 --sortUsing sum \
--samplesLabel 3NEG-H3K27me3 5NEG-H3K27me3 3V-H3K27me3 5V-H3K27me3 \
--colorMap GnBu --regionsLabel "all genes" \
-o plots/Heatmap_PRETREAT_H3K27me3_RPGCnorm_allGenes.pdf --plotTitle "CUT&RUN PRETREAT H3K27me3 all genes"

