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
-R /dawson_genomics/Projects/MYC/220902_ATAC/bed_files/dDvND_ATACup_intergenic.bed -a 3000 -b 3000 -o results/DTmatrix_MACSnorm_dTAG_ATACup.gz

plotHeatmap -m results/DTmatrix_MACSnorm_dTAG_ATACup.gz --sortUsingSamples 3 --sortUsing sum \
--samplesLabel untreated A485 dTAG dTAG-and-A485 \
--colorMap BuPu --regionsLabel "dTAG ATAC peak" \
-o plots/Heatmap_MACSnorm_dTAG_ATACup.pdf --plotTitle "P300 ChIP dTAG, intergenic increased accessibility"

plotProfile -m results/DTmatrix_MACSnorm_dTAG_ATACup.gz -out plots/Profile_MACSnorm_dTAG_ATACup.pdf \
--samplesLabel untreated A485 dTAG dTAG-and-A485 \
--plotTitle "P300 ChIP dTAG, intergenic increased accessibility" --perGroup
