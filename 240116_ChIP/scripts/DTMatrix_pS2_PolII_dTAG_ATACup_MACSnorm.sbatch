#!/bin/bash
 
#SBATCH --nodes=1
#SBATCH --ntasks=1
#SBATCH --mem-per-cpu=20G
#SBATCH --time=1-0:00:00
#SBATCH --output=logs/deeptoolsMatrix%j.stdout
#SBATCH --mail-user=andrea.gillespie@petermac.org
#SBATCH --mail-type=END,TIME_LIMIT_80
#SBATCH --job-name="DTMatrix"
#SBATCH --partition=prod_med

module load deeptools/3.5.0

computeMatrix reference-point --referencePoint center -S \
bigwigs/R1-bulk-DMSO-pS2-Pol2_S39.MACSnorm.bw bigwigs/R2-bulk-DMSO-pS2-Pol2_S55.MACSnorm.bw bigwigs/R3-bulk-DMSO-pS2-Pol2_S59.MACSnorm.bw \
bigwigs/R1-bulk-A485-pS2-Pol2_S50.MACSnorm.bw bigwigs/R2-bulk-A485-pS2-Pol2_S56.MACSnorm.bw bigwigs/R3-bulk-A485-pS2-Pol2_S29.MACSnorm.bw \
bigwigs/R1-bulk-A485-dTAG-pS2-Pol2_S32.MACSnorm.bw bigwigs/R2-bulk-A485-dTAG-pS2-Pol2_S33.MACSnorm.bw bigwigs/R3-bulk-A485-dTAG-pS2-Pol2_S34.MACSnorm.bw \
bigwigs/R1-neg-reactivation-pS2-Pol2_S53.MACSnorm.bw bigwigs/R2-neg-reactivation-pS2-Pol2_S57.MACSnorm.bw bigwigs/R3-neg-reactivation-pS2-Pol2_S30.MACSnorm.bw \
bigwigs/R1-pos-reactivation-pS2-Pol2_S54.MACSnorm.bw bigwigs/R2-pos-reactivation-pS2-Pol2_S58.MACSnorm.bw bigwigs/R3-pos-reactivation-pS2-Pol2_S31.MACSnorm.bw \
-R /dawson_genomics/Projects/MYC/220902_ATAC/bed_files/dDvND_ATACup_intergenic.bed -a 3000 -b 3000 -o results/DTmatrix_MACSnorm_dTAG_ATACup_pS2_PolII_refPoint.gz

plotHeatmap -m results/DTmatrix_MACSnorm_dTAG_ATACup_pS2_PolII_refPoint.gz --sortUsingSamples 7 --sortUsing sum \
--samplesLabel R1-bulk-DMSO-pS2 R2-bulk-DMSO-pS2 R3-bulk-DMSO-pS2 R1-bulk-A485-pS2 R2-bulk-A485-pS2 R3-bulk-A485-pS2 R1-bulk-A485-dTAG-pS2 R2-bulk-A485-dTAG-pS2 R3-bulk-A485-dTAG-pS2 \
R1-neg-reactivation-pS2 R2-neg-reactivation-pS2 R3-neg-reactivation-pS2 R1-pos-reactivation-pS2 R2-pos-reactivation-pS2 R3-pos-reactivation-pS2 \
--colorMap YlGn --regionsLabel "dTAG ATAC peaks" \
-o plots/Heatmap_MACSnorm_dTAG_ATACup_pS2_PolII.pdf --plotTitle "pS2 PolII ChIP, dTAG intergenic increased accessibility"

plotProfile -m results/DTmatrix_MACSnorm_dTAG_ATACup_pS2_PolII_refPoint.gz -out plots/Profile_MACSnorm_dTAG_ATACup_pS2_PolII.pdf \
--samplesLabel R1-bulk-DMSO-pS2 R2-bulk-DMSO-pS2 R3-bulk-DMSO-pS2 R1-bulk-A485-pS2 R2-bulk-A485-pS2 R3-bulk-A485-pS2 R1-bulk-A485-dTAG-pS2 R2-bulk-A485-dTAG-pS2 R3-bulk-A485-dTAG-pS2 \
R1-neg-reactivation-pS2 R2-neg-reactivation-pS2 R3-neg-reactivation-pS2 R1-pos-reactivation-pS2 R2-pos-reactivation-pS2 R3-pos-reactivation-pS2 \
--plotTitle "pS2 PolII ChIP, dTAG intergenic increased accessibility" --perGroup
