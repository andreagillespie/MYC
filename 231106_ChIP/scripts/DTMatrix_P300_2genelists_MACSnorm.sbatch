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
bigwigs/untreated.MACSnorm.bw bigwigs/A485.MACSnorm.bw \
bigwigs/dTAG.MACSnorm.bw bigwigs/dTAG-and-A485.MACSnorm.bw \
-R /dawson_genomics/Projects/MYC/230420_TTseq/bed_files/reactivated_genes.bed /dawson_genomics/Projects/MYC/230420_TTseq/bed_files/nonreactivated_genes.bed \
-a 3000 -b 3000 -m 5000 -o results/DTmatrix_MACSnorm_2genelists.gz

plotHeatmap -m results/DTmatrix_MACSnorm_2genelists.gz --sortUsingSamples 1 --sortUsing sum \
--samplesLabel untreated A485 dTAG dTAG-and-A485 \
--colorMap BuPu --regionsLabel "reactivating" "non-reactivating" \
-o plots/Heatmap_MACSnorm_2genelists.pdf --plotTitle "P300 ChIP MACSnorm"

plotProfile -m results/DTmatrix_MACSnorm_2genelists.gz -out plots/Profile_MACSnorm_2genelists.pdf \
--samplesLabel untreated A485 dTAG dTAG-and-A485 \
--plotTitle "P300 ChIP MACSnorm" --perGroup
