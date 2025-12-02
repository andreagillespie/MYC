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
bigwigs/untreated.RPGC.bw bigwigs/A485.RPGC.bw \
bigwigs/dTAG.RPGC.bw bigwigs/dTAG-and-A485.RPGC.bw \
-R bed_files/dD.v.ND.sig.intervals.UP.bed bed_files/dD.v.ND.sig.intervals.DN.bed \
bed_files/K562_prox_dist_SE_Hg38.bed \
/dawson_genomics/Projects/MYC/annotations/Hg38_MANE_ProteinCoding_TSS_240823.bed \
bed_files/K562_proximal_TE_Hg38.bed bed_files/K562_distal_TE_Hg38.bed \
-a 3000 -b 3000 -o results/DTmatrix_P300_6lists_merged_RPGCnorm.gz

plotHeatmap -m results/DTmatrix_P300_6lists_merged_RPGCnorm.gz --sortUsingSamples 4 --sortUsing sum \
--samplesLabel untreated A485 dTAG dTAG-and-A485 --zMax 20 \
--colorMap BuPu --outFileSortedRegions bed_files/P300_heatmap_6lists_comboSort.bed \
--regionsLabel "ATAC up" "ATAC down" "all SEs" "TSS" "proximal TE" "distal TE" \
-o plots/Heatmap_P300_6lists_merged_comboSort_RPGCnorm.pdf --plotTitle "P300, combo sorted"

plotProfile -m results/DTmatrix_P300_6lists_merged_RPGCnorm.gz \
-out plots/Profile_P300_6lists_merged_RPGCnorm.pdf \
--samplesLabel untreated A485 dTAG dTAG-and-A485 \
--regionsLabel "ATAC up" "ATAC down" "all SEs" "TSS" "proximal TE" "distal TE" \
--plotTitle "P300 ChIPs" --perGroup --legendLocation lower-left
