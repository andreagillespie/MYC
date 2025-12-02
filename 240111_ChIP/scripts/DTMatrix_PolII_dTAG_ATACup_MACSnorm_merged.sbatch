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
bigwigs/bulk-DMSO.MACSnorm.bw bigwigs/bulk-A485.MACSnorm.bw bigwigs/bulk-A485-dTAG.MACSnorm.bw \
bigwigs/neg-reactivation.MACSnorm.bw bigwigs/pos-reactivation.MACSnorm.bw \
-R /dawson_genomics/Projects/MYC/220902_ATAC/bed_files/dDvND_ATACup_intergenic.bed -a 3000 -b 3000 -o results/DTmatrix_MACSnorm_dTAG_ATACup_PolII_refPoint_merged.gz

plotHeatmap -m results/DTmatrix_MACSnorm_dTAG_ATACup_PolII_refPoint_merged.gz --sortUsingSamples 3 --sortUsing sum \
--samplesLabel bulk-DMSO bulk-A485 bulk-A485-dTAG neg-reactivation pos-reactivation \
--colorMap YlGn --regionsLabel "dTAG ATAC peaks" \
-o plots/Heatmap_MACSnorm_dTAG_ATACup_PolII_merged.pdf --plotTitle "PolII ChIP, dTAG intergenic increased accessibility"

plotProfile -m results/DTmatrix_MACSnorm_dTAG_ATACup_PolII_refPoint_merged.gz -out plots/Profile_MACSnorm_dTAG_ATACup_PolII_merged.pdf \
--samplesLabel bulk-DMSO bulk-A485 bulk-A485-dTAG neg-reactivation pos-reactivation \
--plotTitle "PolII ChIP, dTAG intergenic increased accessibility" --perGroup
