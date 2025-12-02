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

computeMatrix scale-regions -S \
bigwigs/LATE-3ND-H3K4me3.MACSnorm.bw bigwigs/LATE-3NP-H3K4me3.MACSnorm.bw \
bigwigs/LATE-3dD-H3K4me3.MACSnorm.bw bigwigs/LATE-3dP-H3K4me3.MACSnorm.bw \
-R /dawson_genomics/Projects/MYC/230420_TTseq/bed_files/reactivated_genes.bed /dawson_genomics/Projects/MYC/230420_TTseq/bed_files/nonreactivated_genes.bed \
-a 3000 -b 3000 -m 5000 -o DTmatrices/DTmatrix_LATE_H3K4me3_MACSnorm_2genelists.gz

plotHeatmap -m DTmatrices/DTmatrix_LATE_H3K4me3_MACSnorm_2genelists.gz --sortUsingSamples 1 --sortUsing sum \
--samplesLabel 3ND-H3K4me3 3NP-H3K4me3 3dD-H3K4me3 3dP-H3K4me3 \
--colorMap OrRd --regionsLabel "reactivating" "non-reactivating" \
-o plots/Heatmap_LATE_H3K4me3_MACSnorm_2genelists.pdf --plotTitle "CUT&RUN LATE H3K4me3 MACSnorm"

plotProfile -m DTmatrices/DTmatrix_LATE_H3K4me3_MACSnorm_2genelists.gz -out plots/Profile_LATE_H3K4me3_MACSnorm_2genelists.pdf \
--samplesLabel 3ND-H3K4me3 3NP-H3K4me3 3dD-H3K4me3 3dP-H3K4me3 --plotTitle "CUT&RUN LATE H3K4me3 MACSnorm" --perGroup

