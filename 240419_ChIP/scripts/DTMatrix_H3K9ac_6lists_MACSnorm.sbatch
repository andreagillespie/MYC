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
bigwigs/H3K9ac-DMSO-R1_S192.MACSnorm.bw bigwigs/H3K9ac-A485-R1_S193.MACSnorm.bw \
bigwigs/H3K9ac-dTAG-R1_S194.MACSnorm.bw bigwigs/H3K9ac-A485-dTAG-R1_S195.MACSnorm.bw \
-R ../231106_ChIP/bed_files/dD.v.ND.sig.intervals.UP.bed ../231106_ChIP/bed_files/dD.v.ND.sig.intervals.DN.bed \
../231106_ChIP/bed_files/K562_prox_dist_SE_Hg38.bed \
/data/reference/dawson_labs/bed_files/Hg38/Hg38_MANE_ProteinCoding_TSS.bed \
../231106_ChIP/bed_files/K562_proximal_TE_Hg38.bed ../231106_ChIP/bed_files/K562_distal_TE_Hg38.bed \
-a 3000 -b 3000 -o results/DTmatrix_H3K9ac_6lists.gz

plotHeatmap -m results/DTmatrix_H3K9ac_6lists.gz --sortUsingSamples 3 --sortUsing sum \
--samplesLabel H3K9ac-DMSO H3K9ac-A485 H3K9ac-dTAG H3K9ac-A485-dTAG \
--colorMap pink_r --regionsLabel "ATAC up" "ATAC down" "all SEs" "TSS" "proximal TE" "distal TE" \
-o plots/Heatmap_H3K9ac_6lists.pdf --plotTitle "H3K9ac ChIPs, dTAG sorted"

plotProfile -m results/DTmatrix_H3K9ac_6lists.gz -out plots/Profile_H3K9ac_6lists.pdf \
--samplesLabel H3K9ac-DMSO H3K9ac-A485 H3K9ac-dTAG H3K9ac-A485-dTAG \
--regionsLabel "ATAC up" "ATAC down" "all SEs" "TSS" "proximal TE" "distal TE" \
--plotTitle "H3K9ac ChIPs" --perGroup 
