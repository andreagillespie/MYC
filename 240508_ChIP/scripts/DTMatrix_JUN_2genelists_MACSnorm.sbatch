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
bigwigs/JUN-DMSO-R1_S97.MACSnorm.bw bigwigs/JUN-A485-R1_S106.MACSnorm.bw \
bigwigs/JUN-dTAG-R1_S105.MACSnorm.bw bigwigs/JUN-dTAG-A485-R1_S107.MACSnorm.bw \
-R /dawson_genomics/Projects/MYC/230420_TTseq/bed_files/reactivated_genes.bed \
/dawson_genomics/Projects/MYC/230420_TTseq/bed_files/nonreactivated_genes.bed \
-a 3000 -b 3000 -m 5000 -o results/DTmatrix_MACSnorm_2genelists_JUN.gz

plotHeatmap -m results/DTmatrix_MACSnorm_2genelists_JUN.gz --sortUsingSamples 3 --sortUsing sum \
--samplesLabel JUN-DMSO JUN-A485 JUN-dTAG JUN-dTAG-A485 \
--colorMap YlOrBr --regionsLabel "reactivating" "non-reactivating" \
-o plots/Heatmap_MACSnorm_2genelists_JUN.pdf --plotTitle "JUN ChIP MACSnorm, dTAG sorted"

plotProfile -m results/DTmatrix_MACSnorm_2genelists_JUN.gz -out plots/Profile_MACSnorm_2genelists_JUN.pdf \
--samplesLabel JUN-DMSO JUN-A485 JUN-dTAG JUN-dTAG-A485 \
--plotTitle "JUN ChIP MACSnorm" --perGroup
