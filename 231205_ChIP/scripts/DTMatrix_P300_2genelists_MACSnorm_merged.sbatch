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
bigwigs/EARLY-DMSO.MACSnorm.bw bigwigs/EARLY-A485.MACSnorm.bw \
bigwigs/dTAG-3h.MACSnorm.bw bigwigs/EARLY-dTAG.MACSnorm.bw bigwigs/EARLY-dTAG-A485.MACSnorm.bw \
-R /dawson_genomics/Projects/MYC/230420_TTseq/bed_files/reactivated_genes.bed /dawson_genomics/Projects/MYC/230420_TTseq/bed_files/nonreactivated_genes.bed \
-a 3000 -b 3000 -m 5000 -o results/DTmatrix_MACSnorm_2genelists_EARLY_merged.gz

plotHeatmap -m results/DTmatrix_MACSnorm_2genelists_EARLY_merged.gz --sortUsingSamples 1 --sortUsing sum \
--samplesLabel EARLY-DMSO EARLY-A485 dTAG-3h EARLY-dTAG EARLY-dTAG-A485 \
--colorMap BuPu --regionsLabel "reactivating" "non-reactivating" \
-o plots/Heatmap_MACSnorm_2genelists_EARLY_merged.pdf --plotTitle "P300 ChIP MACSnorm, EARLY"

plotProfile -m results/DTmatrix_MACSnorm_2genelists_EARLY_merged.gz -out plots/Profile_MACSnorm_2genelists_EARLY_merged.pdf \
--samplesLabel EARLY-DMSO EARLY-A485 dTAG-3h EARLY-dTAG EARLY-dTAG-A485 \
--plotTitle "P300 ChIP MACSnorm, EARLY" --perGroup
