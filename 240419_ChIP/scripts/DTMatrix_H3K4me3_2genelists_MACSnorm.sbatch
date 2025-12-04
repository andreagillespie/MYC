#!/bin/bash
 
#SBATCH --nodes=1
#SBATCH --ntasks=1
#SBATCH --mem-per-cpu=12G
#SBATCH --time=0-04:00:00
#SBATCH --output=logs/deeptoolsMatrix%j.stdout
#SBATCH --mail-user=andrea.gillespie@petermac.org
#SBATCH --mail-type=END,TIME_LIMIT_80
#SBATCH --job-name="DTMatrix"
#SBATCH --partition=prod_med

module load deeptools/3.5.0

computeMatrix scale-regions -S \
bigwigs/H3K4me3-DMSO-R1_S204.MACSnorm.bw bigwigs/H3K4me3-A485-R1_S189.MACSnorm.bw \
bigwigs/H3K4me3-dTAG-R1_S190.MACSnorm.bw bigwigs/H3K4me3-A485-dTAG-R1_S191.MACSnorm.bw \
-R /dawson_genomics/Projects/MYC/230420_TTseq/bed_files/reactivated_genes.bed \
/dawson_genomics/Projects/MYC/230420_TTseq/bed_files/nonreactivated_genes.bed \
-a 3000 -b 3000 -m 5000 -o results/DTmatrix_MACSnorm_2genelists_H3K4me3.gz

plotHeatmap -m results/DTmatrix_MACSnorm_2genelists_H3K4me3.gz --sortUsingSamples 3 --sortUsing sum \
--samplesLabel H3K4me3-DMSO H3K4me3-A485 H3K4me3-dTAG H3K4me3-dTAG-A485 \
--colorMap OrRd --regionsLabel "reactivating" "non-reactivating" \
-o plots/Heatmap_MACSnorm_2genelists_H3K4me3.pdf --plotTitle "H3K4me3 ChIP MACSnorm, dTAG sorted"

plotProfile -m results/DTmatrix_MACSnorm_2genelists_H3K4me3.gz -out plots/Profile_MACSnorm_2genelists_H3K4me3.pdf \
--samplesLabel H3K4me3-DMSO H3K4me3-A485 H3K4me3-dTAG H3K4me3-dTAG-A485 \
--plotTitle "H3K4me3 ChIP MACSnorm" --perGroup
