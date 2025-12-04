#!/bin/bash
 
#SBATCH --nodes=1
#SBATCH --ntasks=1
#SBATCH --mem-per-cpu=12G
#SBATCH --time=0-02:00:00
#SBATCH --output=logs/deeptoolsMatrix%j.stdout
#SBATCH --mail-user=andrea.gillespie@petermac.org
#SBATCH --mail-type=END,TIME_LIMIT_80
#SBATCH --job-name="DTMatrix"
#SBATCH --partition=prod_short

module load deeptools/3.5.0

computeMatrix scale-regions -S \
bigwigs/H3K27ac-DMSO-R2-RSI_S85.MACSnorm.bw bigwigs/H3K27ac-A485-R2-RSI_S86.MACSnorm.bw \
bigwigs/H3K27ac-dTAG-R2-RSI_S87.MACSnorm.bw bigwigs/H3K27ac-A485-dTAG-R2-RSI_S88.MACSnorm.bw \
-R /dawson_genomics/Projects/MYC/annotations/mane.expressed.prot.coding.genes.hg38.bed \
-a 3000 -b 3000 -m 5000 -o results/DTmatrix_H3K27ac_MANE.gz

plotHeatmap -m results/DTmatrix_H3K27ac_MANE.gz --sortUsingSamples 3 --sortUsing sum \
--samplesLabel H3K27ac-DMSO H3K27ac-A485 H3K27ac-dTAG H3K27ac-A485-dTAG \
--colorMap GnBu --regionsLabel "protein coding genes (MANE)" \
-o plots/Heatmap_H3K27ac_MANE.pdf --plotTitle "H3K27ac ChIPs, dTAG sorted"

plotProfile -m results/DTmatrix_H3K27ac_MANE.gz -out plots/Profile_H3K27ac_MANE.pdf \
--samplesLabel H3K27ac-DMSO H3K27ac-A485 H3K27ac-dTAG H3K27ac-A485-dTAG \
--regionsLabel "protein coding genes (MANE)" \
--plotTitle "H3K27ac ChIPs" --perGroup 
