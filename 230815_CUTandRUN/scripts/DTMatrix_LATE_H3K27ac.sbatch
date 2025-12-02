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
bigwigs/LATE-3ND-H3K27ac-R1_S1_RPGCnorm.bw bigwigs/LATE-3ND-H3K27ac-R2_S6_RPGCnorm.bw \
bigwigs/LATE-3NP-H3K27ac-R1_S44_RPGCnorm.bw bigwigs/LATE-3NP-H3K27ac-R2_S9_RPGCnorm.bw \
bigwigs/LATE-3dD-H3K27ac-R1_S54_RPGCnorm.bw bigwigs/LATE-3dD-H3K27ac-R2_S13_RPGCnorm.bw \
bigwigs/LATE-3dP-H3K27ac-R1_S11_RPGCnorm.bw bigwigs/LATE-3dP-H3K27ac-R2_S16_RPGCnorm.bw \
bigwigs/LATE-3dP-LO-H3K27ac-R1_S20_RPGCnorm.bw bigwigs/LATE-3dP-HI-H3K27ac-R1_S19_RPGCnorm.bw \
-R /data/reference/dawson_labs/bed_files/Hg38/Hg38EnsGeneStrandPlusMinusWhitelist.bed -a 3000 -b 3000 -m 5000 -o DTmatrices/DTmatrix_LATE_H3K27ac_RPGCnorm_allGenes.gz

plotHeatmap -m DTmatrices/DTmatrix_LATE_H3K27ac_RPGCnorm_allGenes.gz --sortUsingSamples 1 --sortUsing sum \
--samplesLabel 3ND-H3K27ac-R1 3ND-H3K27ac-R2 3NP-H3K27ac-R1 3NP-H3K27ac-R2 3dD-H3K27ac-R1 3dD-H3K27ac-R2 3dP-H3K27ac-R1 3dP-H3K27ac-R2 3dP-LO-H3K27ac-R1 3dP-HI-H3K27ac-R1 \
--colorMap YlOrBr --regionsLabel "all genes" \
-o plots/Heatmap_LATE_H3K27ac_RPGCnorm_allGenes.pdf --plotTitle "CUT&RUN LATE H3K27ac all genes"

