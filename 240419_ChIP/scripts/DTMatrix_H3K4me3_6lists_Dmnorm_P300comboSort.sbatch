#!/bin/bash
 
#SBATCH --nodes=1
#SBATCH --ntasks=1
#SBATCH --mem-per-cpu=32G
#SBATCH --time=0-10:00:00
#SBATCH --output=logs/deeptoolsMatrix%j.stdout
#SBATCH --mail-user=andrea.gillespie@petermac.org
#SBATCH --mail-type=END,TIME_LIMIT_80
#SBATCH --job-name="DTMatrix"
#SBATCH --partition=prod_med

module load deeptools/3.5.0

computeMatrix reference-point --referencePoint center -S \
bigwigs/H3K4me3-DMSO-R1_S204_Dmnorm.bw bigwigs/H3K4me3-A485-R1_S189_Dmnorm.bw \
bigwigs/H3K4me3-dTAG-R1_S190_Dmnorm.bw bigwigs/H3K4me3-A485-dTAG-R1_S191_Dmnorm.bw \
-R ../231106_ChIP/bed_files/P300_heatmap_6lists_comboSort.bed \
-a 3000 -b 3000 -o results/DTmatrix_H3K4me3_6lists_P300comboSort.gz

plotHeatmap -m results/DTmatrix_H3K4me3_6lists_P300comboSort.gz --sortRegions keep \
--samplesLabel H3K4me3-DMSO H3K4me3-A485 H3K4me3-dTAG H3K4me3-A485-dTAG \
--colorMap YlOrBr --regionsLabel "ATAC up" "ATAC down" "all SEs" "TSS" "proximal TE" "distal TE" \
-o plots/Heatmap_H3K4me3_6lists_P300comboSort.pdf --plotTitle "H3K4me3 ChIPs, P300 combo sorted"
