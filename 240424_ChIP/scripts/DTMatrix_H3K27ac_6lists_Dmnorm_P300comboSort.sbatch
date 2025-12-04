#!/bin/bash
 
#SBATCH --nodes=1
#SBATCH --ntasks=1
#SBATCH --mem-per-cpu=12G
#SBATCH --time=0-06:00:00
#SBATCH --output=logs/deeptoolsMatrix%j.stdout
#SBATCH --mail-user=andrea.gillespie@petermac.org
#SBATCH --mail-type=END,TIME_LIMIT_80
#SBATCH --job-name="DTMatrix"
#SBATCH --partition=prod_med

module load deeptools/3.5.0

computeMatrix reference-point --referencePoint center -S \
bigwigs/H3K27ac-DMSO-R2-RSI_S85_Dmnorm.bw bigwigs/H3K27ac-A485-R2-RSI_S86_Dmnorm.bw \
bigwigs/H3K27ac-dTAG-R2-RSI_S87_Dmnorm.bw bigwigs/H3K27ac-A485-dTAG-R2-RSI_S88_Dmnorm.bw \
-R ../231106_ChIP/bed_files/P300_heatmap_6lists_comboSort.bed \
-a 3000 -b 3000 -o results/DTmatrix_H3K27ac_6lists_Dmnorm_P300comboSort.gz

plotHeatmap -m results/DTmatrix_H3K27ac_6lists_Dmnorm_P300comboSort.gz --sortRegions keep \
--samplesLabel H3K27ac-DMSO H3K27ac-A485 H3K27ac-dTAG H3K27ac-A485-dTAG \
--colorMap GnBu --regionsLabel "ATAC up" "ATAC down" "all SEs" "TSS" "proximal TE" "distal TE" \
-o plots/Heatmap_H3K27ac_6lists_Dmnorm_P300comboSort.pdf --plotTitle "H3K27ac ChIPs, P300 combo sorted, spike-in normalised"
