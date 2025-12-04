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
bigwigs/TBP-DMSO-R1_S112.MACSnorm.bw bigwigs/TBP-A485-R1_S88.MACSnorm.bw \
bigwigs/TBP-dTAG-R1_S87.MACSnorm.bw bigwigs/TBP-dTAG-A485-R1_S89.MACSnorm.bw \
-R /dawson_genomics/Projects/MYC/230420_TTseq/bed_files/reactivated_genes.bed \
/dawson_genomics/Projects/MYC/230420_TTseq/bed_files/nonreactivated_genes.bed \
-a 3000 -b 3000 -m 5000 -o results/DTmatrix_MACSnorm_2genelists_TBP.gz

plotHeatmap -m results/DTmatrix_MACSnorm_2genelists_TBP.gz --sortUsingSamples 3 --sortUsing sum \
--samplesLabel TBP-DMSO TBP-A485 TBP-dTAG TBP-dTAG-A485 \
--colorMap Purples --regionsLabel "reactivating" "non-reactivating" \
-o plots/Heatmap_MACSnorm_2genelists_TBP.pdf --plotTitle "TBP ChIP MACSnorm, dTAG sorted"

plotProfile -m results/DTmatrix_MACSnorm_2genelists_TBP.gz -out plots/Profile_MACSnorm_2genelists_TBP.pdf \
--samplesLabel TBP-DMSO TBP-A485 TBP-dTAG TBP-dTAG-A485 \
--plotTitle "TBP ChIP MACSnorm" --perGroup
