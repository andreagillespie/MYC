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
bigwigs/H3K4me1-DMSO-R1_S200_Dmnorm.bw bigwigs/H3K4me1-A485-R1_S201_Dmnorm.bw \
bigwigs/H3K4me1-dTAG-R1_S202_Dmnorm.bw bigwigs/H3K4me1-A485-dTAG-R1_S203_Dmnorm.bw \
-R ../231106_ChIP/bed_files/P300_heatmap_6lists_comboSort.bed \
-a 3000 -b 3000 -o results/DTmatrix_H3K4me1_6lists_P300comboSort.gz

plotHeatmap -m results/DTmatrix_H3K4me1_6lists_P300comboSort.gz --sortRegions keep \
--samplesLabel H3K4me1-DMSO H3K4me1-A485 H3K4me1-dTAG H3K4me1-A485-dTAG \
--colorMap YlGn --regionsLabel "ATAC up" "ATAC down" "all SEs" "TSS" "proximal TE" "distal TE" \
-o plots/Heatmap_H3K4me1_6lists_P300comboSort.pdf --plotTitle "H3K4me1 ChIPs, P300 combo sorted"

