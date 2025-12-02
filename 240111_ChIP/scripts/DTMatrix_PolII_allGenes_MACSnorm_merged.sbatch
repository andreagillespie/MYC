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
bigwigs/bulk-DMSO.MACSnorm.bw bigwigs/bulk-A485.MACSnorm.bw bigwigs/bulk-A485-dTAG.MACSnorm.bw \
bigwigs/neg-reactivation.MACSnorm.bw bigwigs/pos-reactivation.MACSnorm.bw \
-R /data/reference/dawson_labs/bed_files/Hg38/Hg38EnsGeneStrandPlusMinusWhitelist.bed -a 3000 -b 3000 -m 5000 -o results/DTmatrix_MACSnorm_allGenes_PolII_merged.gz

plotHeatmap -m results/DTmatrix_MACSnorm_allGenes_PolII_merged.gz --sortUsingSamples 1 --sortUsing sum \
--samplesLabel bulk-DMSO bulk-A485 bulk-A485-dTAG neg-reactivation pos-reactivation \
--colorMap YlGn --regionsLabel "all genes" \
-o plots/Heatmap_MACSnorm_allGenes_PolII_merged.pdf --plotTitle "PolII ChIP all genes"

plotProfile -m results/DTmatrix_MACSnorm_allGenes_PolII_merged.gz -out plots/Profile_MACSnorm_allGenes_PolII_merged.pdf \
--samplesLabel bulk-DMSO bulk-A485 bulk-A485-dTAG neg-reactivation pos-reactivation \
--plotTitle "PolII ChIP all genes" --perGroup
