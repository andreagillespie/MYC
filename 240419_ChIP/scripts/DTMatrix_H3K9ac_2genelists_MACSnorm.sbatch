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
bigwigs/H3K9ac-DMSO-R1_S192.MACSnorm.bw bigwigs/H3K9ac-A485-R1_S193.MACSnorm.bw \
bigwigs/H3K9ac-dTAG-R1_S194.MACSnorm.bw bigwigs/H3K9ac-A485-dTAG-R1_S195.MACSnorm.bw \
-R /dawson_genomics/Projects/MYC/230420_TTseq/bed_files/reactivated_genes.bed \
/dawson_genomics/Projects/MYC/230420_TTseq/bed_files/nonreactivated_genes.bed \
-a 3000 -b 3000 -m 5000 -o results/DTmatrix_MACSnorm_2genelists_H3K9ac.gz

plotHeatmap -m results/DTmatrix_MACSnorm_2genelists_H3K9ac.gz --sortUsingSamples 3 --sortUsing sum \
--samplesLabel H3K9ac-DMSO H3K9ac-A485 H3K9ac-dTAG H3K9ac-dTAG-A485 \
--colorMap pink_r --regionsLabel "reactivating" "non-reactivating" \
-o plots/Heatmap_MACSnorm_2genelists_H3K9ac.pdf --plotTitle "H3K9ac ChIP MACSnorm, dTAG sorted"

plotProfile -m results/DTmatrix_MACSnorm_2genelists_H3K9ac.gz -out plots/Profile_MACSnorm_2genelists_H3K9ac.pdf \
--samplesLabel H3K9ac-DMSO H3K9ac-A485 H3K9ac-dTAG H3K9ac-dTAG-A485 \
--plotTitle "H3K9ac ChIP MACSnorm" --perGroup
