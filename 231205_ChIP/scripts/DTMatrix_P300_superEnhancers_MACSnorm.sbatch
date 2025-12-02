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
bigwigs/R1-EARLY-DMSO_S4.MACSnorm.bw bigwigs/R2-EARLY-DMSO_S8.MACSnorm.bw \
bigwigs/R1-EARLY-A485_S6.MACSnorm.bw bigwigs/R2-EARLY-A485_S10.MACSnorm.bw \
bigwigs/R1-dTAG-3h_S12.MACSnorm.bw bigwigs/R2-dTAG-3h_S1.MACSnorm.bw \
bigwigs/R1-EARLY-dTAG_S5.MACSnorm.bw bigwigs/R2-EARLY-dTAG_S9.MACSnorm.bw \
bigwigs/R1-EARLY-dTAG-A485_S7.MACSnorm.bw bigwigs/R2-EARLY-dTAG-A485_S11.MACSnorm.bw \
-R /dawson_genomics/Projects/MYC/230420_TTseq/bed_files/K562_ENCODE_sedb_01_0039.bed -a 3000 -b 3000 -o results/DTmatrix_MACSnorm_SE_EARLY_refPoint.gz

plotHeatmap -m results/DTmatrix_MACSnorm_SE_EARLY_refPoint.gz --sortUsingSamples 1 --sortUsing sum \
--samplesLabel R1-EARLY-DMSO R2-EARLY-DMSO R1-EARLY-A485 R2-EARLY-A485 R1-dTAG-3h R2-dTAG-3h R1-EARLY-dTAG R2-EARLY-dTAG R1-EARLY-dTAG-A485 R2-EARLY-dTAG-A485 \
--colorMap BuPu --regionsLabel "superenhancers" \
-o plots/Heatmap_MACSnorm_superEnhancers_EARLY.pdf --plotTitle "P300 ChIP superenhancers, EARLY"

plotProfile -m results/DTmatrix_MACSnorm_SE_EARLY_refPoint.gz -out plots/Profile_MACSnorm_superEnhancers_EARLY.pdf \
--samplesLabel R1-EARLY-DMSO R2-EARLY-DMSO R1-EARLY-A485 R2-EARLY-A485 R1-dTAG-3h R2-dTAG-3h R1-EARLY-dTAG R2-EARLY-dTAG R1-EARLY-dTAG-A485 R2-EARLY-dTAG-A485 \
--plotTitle "P300 ChIP superenhancers, EARLY" --perGroup
