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
bigwigs/EGS-HA-KP_S102.MACSnorm.bw \
bigwigs/EGS-HA-B1_S103.MACSnorm.bw bigwigs/EGS-HA-B3_S104.MACSnorm.bw \
-R ../231106_ChIP/bed_files/dD.v.ND.sig.intervals.UP.bed ../231106_ChIP/bed_files/dD.v.ND.sig.intervals.DN.bed \
../231106_ChIP/bed_files/K562_prox_dist_SE_Hg38.bed \
/data/reference/dawson_labs/bed_files/Hg38/Hg38_MANE_ProteinCoding_TSS.bed \
../231106_ChIP/bed_files/K562_proximal_TE_Hg38.bed ../231106_ChIP/bed_files/K562_distal_TE_Hg38.bed \
-a 3000 -b 3000 -o results/DTmatrix_EGS_6lists.gz

plotHeatmap -m results/DTmatrix_EGS_6lists.gz --sortUsingSamples 1 --sortUsing sum \
--samplesLabel EGS-HA-KP EGS-HA-B1 EGS-HA-B3 \
--colorMap gist_heat_r --regionsLabel "ATAC up" "ATAC down" "all SEs" "TSS" "proximal TE" "distal TE" \
-o plots/Heatmap_EGS_6lists.pdf --plotTitle "EGS ChIPs, KP sorted"

plotProfile -m results/DTmatrix_EGS_6lists.gz -out plots/Profile_EGS_6lists.pdf \
--samplesLabel EGS-HA-KP EGS-HA-B1 EGS-HA-B3 \
--regionsLabel "ATAC up" "ATAC down" "all SEs" "TSS" "proximal TE" "distal TE" \
--plotTitle "EGS ChIPs" --perGroup 
