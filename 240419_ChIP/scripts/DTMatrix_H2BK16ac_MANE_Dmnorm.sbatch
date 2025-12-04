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

computeMatrix scale-regions -S \
bigwigs/H2BK16ac-DMSO-R1_S196_Dmnorm.bw bigwigs/H2BK16ac-A485-R1_S197_Dmnorm.bw \
bigwigs/H2BK16ac-dTAG-R1_S198_Dmnorm.bw bigwigs/H2BK16ac-A485-dTAG-R1_S199_Dmnorm.bw \
-R /dawson_genomics/Projects/MYC/annotations/mane.expressed.prot.coding.genes.hg38.bed \
-a 3000 -b 3000 -m 5000 -o results/DTmatrix_H2BK16ac_MANE_Dmnorm.gz

plotHeatmap -m results/DTmatrix_H2BK16ac_MANE_Dmnorm.gz --sortUsingSamples 3 --sortUsing sum \
--samplesLabel H2BK16ac-DMSO H2BK16ac-A485 H2BK16ac-dTAG H2BK16ac-A485-dTAG \
--colorMap OrRd --regionsLabel "protein coding genes (MANE)" \
-o plots/Heatmap_H2BK16ac_MANE_Dmnorm.pdf --plotTitle "H2BK16ac ChIPs, dTAG sorted, spike-in normalised"

plotProfile -m results/DTmatrix_H2BK16ac_MANE_Dmnorm.gz -out plots/Profile_H2BK16ac_MANE_Dmnorm.pdf \
--samplesLabel H2BK16ac-DMSO H2BK16ac-A485 H2BK16ac-dTAG H2BK16ac-A485-dTAG \
--regionsLabel "protein coding genes (MANE)" \
--plotTitle "H2BK16ac ChIPs, spike-in normalised" --perGroup 
