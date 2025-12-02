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

computeMatrix reference-point --referencePoint center -S \
bigwigs/untreated.MACSnorm.bw bigwigs/A485.MACSnorm.bw \
bigwigs/dTAG.MACSnorm.bw bigwigs/dTAG-and-A485.MACSnorm.bw \
-R /data/reference/dawson_labs/bed_files/Hg38/Hg38EnsGeneStrandPlusMinusWhitelist.bed -a 3000 -b 3000 -o results/DTmatrix_MACSnorm_allGenes_merged.gz

plotHeatmap -m results/DTmatrix_MACSnorm_allGenes_merged.gz --sortUsingSamples 3 --sortUsing sum \
--samplesLabel untreated A485 dTAG dTAG-and-A485 \
--colorMap BuPu \
-o plots/Heatmap_MACSnorm_allGenes_merged.pdf --plotTitle "P300 ChIP, dTAG sorted"

plotHeatmap -m results/DTmatrix_MACSnorm_allGenes_merged.gz --sortUsingSamples 3 --sortUsing sum \
--samplesLabel untreated A485 dTAG dTAG-and-A485 \
--colorMap BuPu --kmeans 2 \
-o plots/Heatmap_MACSnorm_allGenes_merged_km2.pdf --plotTitle "P300 ChIP, dTAG sorted"

plotHeatmap -m results/DTmatrix_MACSnorm_allGenes_merged.gz --sortUsingSamples 3 --sortUsing sum \
--samplesLabel untreated A485 dTAG dTAG-and-A485 \
--colorMap BuPu --kmeans 3 \
-o plots/Heatmap_MACSnorm_allGenes_merged_km3.pdf --plotTitle "P300 ChIP, dTAG sorted"

plotProfile -m results/DTmatrix_MACSnorm_allGenes_merged.gz -out plots/Profile_MACSnorm_allGenes_merged.pdf \
--samplesLabel untreated A485 dTAG dTAG-and-A485 \
--plotTitle "P300 ChIP, all genes" --perGroup
