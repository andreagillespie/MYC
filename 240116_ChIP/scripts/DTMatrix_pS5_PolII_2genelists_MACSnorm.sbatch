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
bigwigs/R1-bulk-DMSO-pS5-Pol2_S36.MACSnorm.bw bigwigs/R2-bulk-DMSO-pS2-pS5-Pol2_S41.MACSnorm.bw bigwigs/R3-bulk-A485-pS2-pS5-Pol2_S46.MACSnorm.bw \
bigwigs/R1-bulk-A485-pS5-Pol2_S37.MACSnorm.bw bigwigs/R2-bulk-A485-pS2-pS5-Pol2_S42.MACSnorm.bw bigwigs/R3-bulk-A485-pS2-pS5-Pol2_S46.MACSnorm.bw \
bigwigs/R1-bulk-A485-dTAG-pS5-Pol2_S49.MACSnorm.bw bigwigs/R2-bulk-A485-dTAG-pS5-Pol2_S51.MACSnorm.bw bigwigs/R3-bulk-A485-dTAG-pS2-Pol2_S34.MACSnorm.bw \
bigwigs/R1-neg-reactivation-pS5-Pol2_S38.MACSnorm.bw bigwigs/R2-neg-reactivation-pS5-Pol2_S43.MACSnorm.bw bigwigs/R3-neg-reactivation-pS5-Pol2_S47.MACSnorm.bw \
bigwigs/R1-pos-reactivation-pS5-Pol2_S40.MACSnorm.bw bigwigs/R2-pos-reactivation-pS5-Pol2_S44.MACSnorm.bw bigwigs/R3-pos-reactivation-pS5-Pol2_S48.MACSnorm.bw \
-R /dawson_genomics/Projects/MYC/230420_TTseq/bed_files/reactivated_genes.bed /dawson_genomics/Projects/MYC/230420_TTseq/bed_files/nonreactivated_genes.bed \
-a 3000 -b 3000 -m 5000 -o results/DTmatrix_MACSnorm_2genelists_pS5_PolII.gz

plotHeatmap -m results/DTmatrix_MACSnorm_2genelists_pS5_PolII.gz --sortUsingSamples 1 --sortUsing sum \
--samplesLabel R1-bulk-DMSO-pS5 R2-bulk-DMSO-pS5 R3-bulk-DMSO-pS5 R1-bulk-A485-pS5 R2-bulk-A485-pS5 R3-bulk-A485-pS5 R1-bulk-A485-dTAG-pS5 R2-bulk-A485-dTAG-pS5 R3-bulk-A485-dTAG-pS5 \
R1-neg-reactivation-pS5 R2-neg-reactivation-pS5 R3-neg-reactivation-pS5 R1-pos-reactivation-pS5 R2-pos-reactivation-pS5 R3-pos-reactivation-pS5 \
--colorMap YlGn --regionsLabel "reactivating" "non-reactivating" \
-o plots/Heatmap_MACSnorm_2genelists_pS5_PolII.pdf --plotTitle "pS5 PolII ChIP MACSnorm"

plotProfile -m results/DTmatrix_MACSnorm_2genelists_pS5_PolII.gz -out plots/Profile_MACSnorm_2genelists_pS5_PolII.pdf \
--samplesLabel R1-bulk-DMSO-pS5 R2-bulk-DMSO-pS5 R3-bulk-DMSO-pS5 R1-bulk-A485-pS5 R2-bulk-A485-pS5 R3-bulk-A485-pS5 R1-bulk-A485-dTAG-pS5 R2-bulk-A485-dTAG-pS5 R3-bulk-A485-dTAG-pS5 \
R1-neg-reactivation-pS5 R2-neg-reactivation-pS5 R3-neg-reactivation-pS5 R1-pos-reactivation-pS5 R2-pos-reactivation-pS5 R3-pos-reactivation-pS5 \
--plotTitle "pS5 PolII ChIP MACSnorm" --perGroup
