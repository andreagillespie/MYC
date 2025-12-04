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
bigwigs/KAT2A-DMSO-R1_S108.MACSnorm.bw bigwigs/KAT2A-A485-R1_S110.MACSnorm.bw \
bigwigs/KAT2A-dTAG-R1_S109.MACSnorm.bw bigwigs/KAT2A-dTAG-A485-R1_S111.MACSnorm.bw \
-R ../231106_ChIP/bed_files/dD.v.ND.sig.intervals.UP.bed ../231106_ChIP/bed_files/dD.v.ND.sig.intervals.DN.bed \
../231106_ChIP/bed_files/K562_prox_dist_SE_Hg38.bed \
/data/reference/dawson_labs/bed_files/Hg38/Hg38_MANE_ProteinCoding_TSS.bed \
../231106_ChIP/bed_files/K562_proximal_TE_Hg38.bed ../231106_ChIP/bed_files/K562_distal_TE_Hg38.bed \
-a 3000 -b 3000 -o results/DTmatrix_KAT2A_6lists.gz

plotHeatmap -m results/DTmatrix_KAT2A_6lists.gz --sortUsingSamples 3 --sortUsing sum \
--samplesLabel KAT2A-DMSO KAT2A-A485 KAT2A-dTAG KAT2A-A485-dTAG --zMax 3 \
--colorMap PuBuGn --regionsLabel "ATAC up" "ATAC down" "all SEs" "TSS" "proximal TE" "distal TE" \
-o plots/Heatmap_KAT2A_6lists.pdf --plotTitle "KAT2A ChIPs, dTAG sorted"

plotProfile -m results/DTmatrix_KAT2A_6lists.gz -out plots/Profile_KAT2A_6lists.pdf \
--samplesLabel KAT2A-DMSO KAT2A-A485 KAT2A-dTAG KAT2A-A485-dTAG \
--regionsLabel "ATAC up" "ATAC down" "all SEs" "TSS" "proximal TE" "distal TE" \
--plotTitle "KAT2A ChIPs" --perGroup 
