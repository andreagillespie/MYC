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
bigwigs/DSSO-HA-KP_S98.MACSnorm.bw \
bigwigs/DSSO-HA-B1_S99.MACSnorm.bw bigwigs/DSSO-HA-B3_S100.MACSnorm.bw \
-R ../231106_ChIP/bed_files/dD.v.ND.sig.intervals.UP.bed ../231106_ChIP/bed_files/dD.v.ND.sig.intervals.DN.bed \
../231106_ChIP/bed_files/K562_prox_dist_SE_Hg38.bed \
/data/reference/dawson_labs/bed_files/Hg38/Hg38_MANE_ProteinCoding_TSS.bed \
../231106_ChIP/bed_files/K562_proximal_TE_Hg38.bed ../231106_ChIP/bed_files/K562_distal_TE_Hg38.bed \
-a 3000 -b 3000 -o results/DTmatrix_DSSO_6lists.gz

plotHeatmap -m results/DTmatrix_DSSO_6lists.gz --sortUsingSamples 1 --sortUsing sum \
--samplesLabel DSSO-HA-KP DSSO-HA-B1 DSSO-HA-B3 \
--colorMap copper_r --regionsLabel "ATAC up" "ATAC down" "all SEs" "TSS" "proximal TE" "distal TE" \
-o plots/Heatmap_DSSO_6lists.pdf --plotTitle "DSSO ChIPs, KP sorted"

plotProfile -m results/DTmatrix_DSSO_6lists.gz -out plots/Profile_DSSO_6lists.pdf \
--samplesLabel DSSO-HA-KP DSSO-HA-B1 DSSO-HA-B3 \
--regionsLabel "ATAC up" "ATAC down" "all SEs" "TSS" "proximal TE" "distal TE" \
--plotTitle "DSSO ChIPs" --perGroup 
