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
bigwigs/bulk-DMSO-pS5-Pol2.MACSnorm.bw bigwigs/bulk-A485-pS5-Pol2.MACSnorm.bw bigwigs/bulk-A485-dTAG-pS5-Pol2.MACSnorm.bw \
bigwigs/neg-reactivation-pS5-Pol2.MACSnorm.bw bigwigs/pos-reactivation-pS5-Pol2.MACSnorm.bw \
-R /dawson_genomics/Projects/MYC/220902_ATAC/bed_files/dDvND_ATACup_intergenic.bed -a 3000 -b 3000 -o results/DTmatrix_MACSnorm_dTAG_ATACup_PolII_pS5_refPoint_merged.gz

plotHeatmap -m results/DTmatrix_MACSnorm_dTAG_ATACup_PolII_pS5_refPoint_merged.gz --sortUsingSamples 5 --sortUsing sum \
--samplesLabel bulk-DMSO-pS5-Pol2 bulk-A485-pS5-Pol2 bulk-A485-dTAG-pS5-Pol2 neg-reactivation-pS5-Pol2 pos-reactivation-pS5-Pol2 \
--colorMap YlGn --regionsLabel "dTAG ATAC peaks" --zMax 4 \
-o plots/Heatmap_MACSnorm_dTAG_ATACup_PolII_pS5_merged.pdf --plotTitle "pS5 PolII ChIP, dTAG intergenic increased accessibility"

plotProfile -m results/DTmatrix_MACSnorm_dTAG_ATACup_PolII_pS5_refPoint_merged.gz -out plots/Profile_MACSnorm_dTAG_ATACup_PolII_pS5_merged.pdf \
--samplesLabel bulk-DMSO-pS5-Pol2 bulk-A485-pS5-Pol2 bulk-A485-dTAG-pS5-Pol2 neg-reactivation-pS5-Pol2 pos-reactivation-pS5-Pol2 \
--plotTitle "pS5 PolII ChIP, dTAG intergenic increased accessibility" --perGroup
