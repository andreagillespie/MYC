#!/bin/bash
 
#SBATCH --nodes=1
#SBATCH --ntasks=1
#SBATCH --mem-per-cpu=12G
#SBATCH --time=0-04:00:00
#SBATCH --output=logs/deeptoolsMatrix%j.stdout
#SBATCH --mail-user=andrea.gillespie@petermac.org
#SBATCH --mail-type=END,TIME_LIMIT_80
#SBATCH --job-name="DTMatrix"
#SBATCH --partition=prod_med

module load deeptools/3.5.0

computeMatrix scale-regions -S \
bigwigs/H3K27ac-DMSO-R2-RSI_S85_Dmnorm.bw bigwigs/H3K27ac-A485-R2-RSI_S86_Dmnorm.bw \
bigwigs/H3K27ac-dTAG-R2-RSI_S87_Dmnorm.bw bigwigs/H3K27ac-A485-dTAG-R2-RSI_S88_Dmnorm.bw \
-R /dawson_genomics/Projects/MYC/230420_TTseq/bed_files/reactivated_genes.bed \
/dawson_genomics/Projects/MYC/230420_TTseq/bed_files/nonreactivated_genes.bed \
-a 3000 -b 3000 -m 5000 -o results/DTmatrix_Dmnorm_2genelists_H3K27ac.gz

plotHeatmap -m results/DTmatrix_Dmnorm_2genelists_H3K27ac.gz --sortUsingSamples 3 --sortUsing sum \
--samplesLabel H3K27ac-DMSO H3K27ac-A485 H3K27ac-dTAG H3K27ac-dTAG-A485 \
--colorMap Oranges --regionsLabel "reactivating" "non-reactivating" \
-o plots/Heatmap_Dmnorm_2genelists_H3K27ac.pdf --plotTitle "H3K27ac ChIP spike-in norm, dTAG sorted"

plotProfile -m results/DTmatrix_Dmnorm_2genelists_H3K27ac.gz -out plots/Profile_Dmnorm_2genelists_H3K27ac.pdf \
--samplesLabel H3K27ac-DMSO H3K27ac-A485 H3K27ac-dTAG H3K27ac-dTAG-A485 \
--plotTitle "H3K27ac ChIP spike-in norm" --perGroup
