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
-R ../231106_ChIP/bed_files/dD.v.ND.sig.intervals.UP.bed ../231106_ChIP/bed_files/dD.v.ND.sig.intervals.DN.bed \
../231106_ChIP/bed_files/K562_prox_dist_SE_Hg38.bed \
/data/reference/dawson_labs/bed_files/Hg38/Hg38_MANE_ProteinCoding_TSS_240823.bed \
../231106_ChIP/bed_files/K562_proximal_TE_Hg38.bed ../231106_ChIP/bed_files/K562_distal_TE_Hg38.bed \
-a 3000 -b 3000 -o results/DTmatrix_H2BK16ac_6lists_Dmnorm.gz

plotHeatmap -m results/DTmatrix_H2BK16ac_6lists_Dmnorm.gz --sortUsingSamples 3 --sortUsing sum \
--samplesLabel H2BK16ac-DMSO H2BK16ac-A485 H2BK16ac-dTAG H2BK16ac-A485-dTAG \
--colorMap BuPu --regionsLabel "ATAC up" "ATAC down" "all SEs" "TSS" "proximal TE" "distal TE" \
-o plots/Heatmap_H2BK16ac_6lists_Dmnorm.pdf --plotTitle "H2BK16ac ChIPs, dTAG sorted, spike-in normalised"

plotProfile -m results/DTmatrix_H2BK16ac_6lists_Dmnorm.gz -out plots/Profile_H2BK16ac_6lists_Dmnorm.pdf \
--samplesLabel H2BK16ac-DMSO H2BK16ac-A485 H2BK16ac-dTAG H2BK16ac-A485-dTAG \
--regionsLabel "ATAC up" "ATAC down" "all SEs" "TSS" "proximal TE" "distal TE" \
--plotTitle "H2BK16ac ChIPs, spike-in normalised" --perGroup 
