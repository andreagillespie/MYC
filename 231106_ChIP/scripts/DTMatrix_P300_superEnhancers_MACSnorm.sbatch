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

computeMatrix reference-point --referencePoint center -S \
bigwigs/R1-untreated_S9.MACSnorm.bw bigwigs/R2-untreated_S13.MACSnorm.bw bigwigs/R3-untreated_S17.MACSnorm.bw \
bigwigs/R1-A485_S11.MACSnorm.bw bigwigs/R2-A485_S15.MACSnorm.bw bigwigs/R3-A485_S2.MACSnorm.bw \
bigwigs/R1-dTAG_S10.MACSnorm.bw bigwigs/R2-dTAG_S14.MACSnorm.bw bigwigs/R3-dTAG_S1.MACSnorm.bw \
bigwigs/R1-dTAG-and-A485_S12.MACSnorm.bw bigwigs/R2-dTAG-and-A485_S16.MACSnorm.bw bigwigs/R3-dTAG-and-A485_S3.MACSnorm.bw \
-R /dawson_genomics/Projects/MYC/230420_TTseq/bed_files/K562_ENCODE_sedb_01_0039.bed -a 3000 -b 3000 -o results/DTmatrix_MACSnorm_SE_refPoint.gz

plotHeatmap -m results/DTmatrix_MACSnorm_SE_refPoint.gz --sortUsingSamples 1 --sortUsing sum \
--samplesLabel R1-untreated R2-untreated R3-untreated R1-A485 R2-A485 R3-A485 R1-dTAG R2-dTAG R3-dTAG R1-dTAG-and-A485 R2-dTAG-and-A485 R3-dTAG-and-A485 \
--colorMap BuPu --regionsLabel "superenhancers" \
-o plots/Heatmap_MACSnorm_superEnhancers.pdf --plotTitle "P300 ChIP superenhancers"

plotProfile -m results/DTmatrix_MACSnorm_SE_refPoint.gz -out plots/Profile_MACSnorm_superEnhancers.pdf \
--samplesLabel R1-untreated R2-untreated R3-untreated R1-A485 R2-A485 R3-A485 R1-dTAG R2-dTAG R3-dTAG R1-dTAG-and-A485 R2-dTAG-and-A485 R3-dTAG-and-A485 \
--plotTitle "P300 ChIP superenhancers" --perGroup
