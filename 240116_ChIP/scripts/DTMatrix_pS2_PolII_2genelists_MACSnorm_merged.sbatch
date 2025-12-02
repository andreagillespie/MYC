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

computeMatrix scale-regions -S \
bigwigs/bulk-DMSO-pS2-Pol2.MACSnorm.bw bigwigs/bulk-A485-pS2-Pol2.MACSnorm.bw bigwigs/bulk-A485-dTAG-pS2-Pol2.MACSnorm.bw \
bigwigs/neg-reactivation-pS2-Pol2.MACSnorm.bw bigwigs/pos-reactivation-pS2-Pol2.MACSnorm.bw \
-R /dawson_genomics/Projects/MYC/230420_TTseq/bed_files/reactivated_genes.bed /dawson_genomics/Projects/MYC/230420_TTseq/bed_files/nonreactivated_genes.bed \
-a 3000 -b 3000 -m 5000 -o results/DTmatrix_MACSnorm_2genelists_PolII_pS2_merged.gz

plotHeatmap -m results/DTmatrix_MACSnorm_2genelists_PolII_pS2_merged.gz --sortUsingSamples 1 --sortUsing sum \
--samplesLabel bulk-DMSO-pS2-Pol2 bulk-A485-pS2-Pol2 bulk-A485-dTAG-pS2 neg-reactivation-pS2-Pol2 pos-reactivation-pS2-Pol2 \
--colorMap YlGn --regionsLabel "reactivating" "non-reactivating" \
-o plots/Heatmap_MACSnorm_2genelists_PolII_pS2_merged.pdf --plotTitle "pS2 PolII ChIP MACSnorm"

plotProfile -m results/DTmatrix_MACSnorm_2genelists_PolII_pS2_merged.gz -out plots/Profile_MACSnorm_2genelists_PolII_pS2_merged.pdf \
--samplesLabel bulk-DMSO-pS2-Pol2 bulk-A485-pS2-Pol2 bulk-A485-dTAG-pS2 neg-reactivation-pS2-Pol2 pos-reactivation-pS2-Pol2 \
--plotTitle "pS2 PolII ChIP MACSnorm" --perGroup



