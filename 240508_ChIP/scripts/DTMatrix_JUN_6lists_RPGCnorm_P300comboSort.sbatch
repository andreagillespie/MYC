#!/bin/bash
 
#SBATCH --nodes=1
#SBATCH --ntasks=1
#SBATCH --mem-per-cpu=12G
#SBATCH --time=0-12:00:00
#SBATCH --output=logs/deeptoolsMatrix%j.stdout
#SBATCH --mail-user=andrea.gillespie@petermac.org
#SBATCH --mail-type=END,TIME_LIMIT_80
#SBATCH --job-name="DTMatrix"
#SBATCH --partition=prod_med

module load deeptools/3.5.0

computeMatrix reference-point --referencePoint center -S \
bigwigs/JUN-DMSO-R1_S97.RPGC.bw bigwigs/JUN-A485-R1_S106.RPGC.bw \
bigwigs/JUN-dTAG-R1_S105.RPGC.bw bigwigs/JUN-dTAG-A485-R1_S107.RPGC.bw \
-R ../231106_ChIP/bed_files/P300_heatmap_6lists_comboSort.bed \
-a 3000 -b 3000 -o results/DTmatrix_JUN_6lists_P300comboSort_RPGCnorm.gz

plotHeatmap -m results/DTmatrix_JUN_6lists_P300comboSort_RPGCnorm.gz --sortRegions keep \
--samplesLabel JUN-DMSO JUN-A485 JUN-dTAG JUN-A485-dTAG \
--colorMap RdPu --regionsLabel "ATAC up" "ATAC down" "all SEs" "TSS" "proximal TE" "distal TE" \
-o plots/Heatmap_JUN_6lists_P300comboSort_RPGCnorm.pdf --plotTitle "JUN ChIPs, P300 combo sorted, RPGC norm"
