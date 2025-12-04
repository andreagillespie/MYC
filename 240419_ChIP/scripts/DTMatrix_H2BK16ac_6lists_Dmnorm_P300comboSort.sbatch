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
bigwigs/H2BK16ac-DMSO-R1_S196_Dmnorm.bw bigwigs/H2BK16ac-A485-R1_S197_Dmnorm.bw \
bigwigs/H2BK16ac-dTAG-R1_S198_Dmnorm.bw bigwigs/H2BK16ac-A485-dTAG-R1_S199_Dmnorm.bw \
-R ../231106_ChIP/bed_files/P300_heatmap_6lists_comboSort.bed \
-a 3000 -b 3000 -o results/DTmatrix_H2BK16ac_6lists_Dmnorm_P300comboSort.gz

plotHeatmap -m results/DTmatrix_H2BK16ac_6lists_Dmnorm_P300comboSort.gz --sortRegions keep \
--samplesLabel H2BK16ac-DMSO H2BK16ac-A485 H2BK16ac-dTAG H2BK16ac-A485-dTAG \
--colorMap OrRd --regionsLabel "ATAC up" "ATAC down" "all SEs" "TSS" "proximal TE" "distal TE" \
-o plots/Heatmap_H2BK16ac_6lists_Dmnorm_P300comboSort.pdf --plotTitle "H2BK16ac ChIPs, P300 combo sorted, spike-in normalised"

