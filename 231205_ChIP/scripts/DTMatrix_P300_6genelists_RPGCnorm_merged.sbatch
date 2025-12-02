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

computeMatrix reference-point --referencePoint center -S \
bigwigs/EARLY-DMSO.RPGC.bw bigwigs/EARLY-A485.RPGC.bw \
bigwigs/dTAG-3h.RPGC.bw bigwigs/EARLY-dTAG.RPGC.bw bigwigs/EARLY-dTAG-A485.RPGC.bw \
-R ../231106_ChIP/bed_files/P300_heatmap_6lists_comboSort.bed \
-a 3000 -b 3000 -o results/DTmatrix_RPGCnorm_6genelists_EARLY_merged_P300LATEsort.gz

plotHeatmap -m results/DTmatrix_RPGCnorm_6genelists_EARLY_merged_P300LATEsort.gz \
--sortUsingSamples 1 --sortUsing sum --colorMap BuPu \
--samplesLabel EARLY-DMSO EARLY-A485 dTAG-3h EARLY-dTAG EARLY-dTAG-A485 \
--regionsLabel "ATAC up" "ATAC down" "all SEs" "TSS" "proximal TE" "distal TE" \
-o plots/Heatmap_RPGCnorm_6genelists_EARLY_merged_P300LATEsort.pdf \
--plotTitle "P300 ChIP RPGCnorm, EARLY"

plotProfile -m results/DTmatrix_RPGCnorm_6genelists_EARLY_merged_P300LATEsort.gz \
-out plots/Profile_RPGCnorm_6genelists_EARLY_merged_P300LATEsort.pdf \
--samplesLabel EARLY-DMSO EARLY-A485 dTAG-3h EARLY-dTAG EARLY-dTAG-A485 \
--plotTitle "P300 ChIP RPGCnorm, EARLY" --perGroup
