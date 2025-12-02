#!/bin/bash
 
#SBATCH --nodes=1
#SBATCH --ntasks=1
#SBATCH --mem-per-cpu=32G
#SBATCH --time=2-0:00:00
#SBATCH --output=logs/deeptoolsMatrix%j.stdout
#SBATCH --mail-user=andrea.gillespie@petermac.org
#SBATCH --mail-type=END,TIME_LIMIT_80
#SBATCH --job-name="DTMatrix"
#SBATCH --partition=prod

module load deeptools/3.5.0

computeMatrix scale-regions -S \
bigwigs/R1-untreated_S9_RPGCnorm.bw bigwigs/R2-untreated_S13_RPGCnorm.bw bigwigs/R3-untreated_S17_RPGCnorm.bw \
bigwigs/R1-A485_S11_RPGCnorm.bw bigwigs/R2-A485_S15_RPGCnorm.bw bigwigs/R3-A485_S2_RPGCnorm.bw \
bigwigs/R1-dTAG_S10_RPGCnorm.bw bigwigs/R2-dTAG_S14_RPGCnorm.bw bigwigs/R3-dTAG_S1_RPGCnorm.bw \
bigwigs/R1-dTAG-and-A485_S12_RPGCnorm.bw bigwigs/R2-dTAG-and-A485_S16_RPGCnorm.bw bigwigs/R3-dTAG-and-A485_S3_RPGCnorm.bw \
-R /data/reference/dawson_labs/bed_files/Hg38/Hg38EnsGeneStrandPlusMinusWhitelist.bed -a 3000 -b 3000 -m 5000 -o results/DTmatrix_RPGCnorm_allGenes.gz

plotHeatmap -m results/DTmatrix_RPGCnorm_allGenes.gz --sortUsingSamples 1 --sortUsing sum \
--samplesLabel R1-untreated R2-untreated R3-untreated R1-A485 R2-A485 R3-A485 R1-dTAG R2-dTAG R3-dTAG R1-dTAG-and-A485 R2-dTAG-and-A485 R3-dTAG-and-A485 \
--colorMap BuPu --regionsLabel "all genes" \
-o plots/Heatmap_RPGCnorm_allGenes.pdf --plotTitle "P300 ChIP all genes"

plotProfile -m results/DTmatrix_RPGCnorm_allGenes.gz -out plots/Profile_RPGCnorm_allGenes.pdf \
--samplesLabel R1-untreated R2-untreated R3-untreated R1-A485 R2-A485 R3-A485 R1-dTAG R2-dTAG R3-dTAG R1-dTAG-and-A485 R2-dTAG-and-A485 R3-dTAG-and-A485 \
--plotTitle "P300 ChIP all genes" --perGroup
