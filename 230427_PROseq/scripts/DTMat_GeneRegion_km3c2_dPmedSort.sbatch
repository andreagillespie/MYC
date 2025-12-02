#!/usr/bin/env bash
#SBATCH --nodes=1
#SBATCH --cpus-per-task=4
#SBATCH --mem=16G
#SBATCH --time=0-16:00:00
#SBATCH --output=logs/deeptoolsMatrix%j.stdout
#SBATCH --mail-type=END,TIME_LIMIT_80
#SBATCH --mail-user=andrea.gillespie@petermac.org
#SBATCH --job-name="Heatmap_GeneRegion"
#SBATCH --partition=prod_med

module purge
module load deeptools/3.5.0

# run from project dir /scratch/teams/dawson_genomics/Projects/MYC/230427_PROseq/
computeMatrix scale-regions -S \
bigwigs/NP-LATE.merged.RPGC.bw \
bigwigs/dP-LATE.merged.RPGC.bw \
-R bed_files/GR_km3c2_dP_sortedRegions.bed \
-m 10000 -a 2000 -b 2000 -out results/DTmat_geneRegion_km3c2_RPGCnorm.gz

# unclustered heatmap sorted by dP
plotHeatmap -m results/DTmat_geneRegion_km3c2_RPGCnorm.gz -out plots/GR_km3c2_dPsorted_RPGCnorm.pdf --colorMap nipy_spectral \
--samplesLabel "NP-LATE" "dP-LATE" --legendLocation none --sortUsingSamples 2 --sortUsing median --sortRegion descend \
--heatmapHeight 15 --plotTitle 'kmeans 3 cluster 2 genes dTAG-V P300i sorted' --outFileSortedRegions bed_files/GR_km3c2_dP_sortedRegions.bed

# check for cluster of varying behaviour
plotHeatmap -m results/DTmat_geneRegion_km3c2_RPGCnorm.gz -out plots/GR_km3c2_dPsorted_RPGCnorm_k2.pdf --colorMap nipy_spectral \
--samplesLabel "NP-LATE" "dP-LATE" --sortUsingSamples 2 --sortUsing median --sortRegion descend --kmeans 2 \
--heatmapHeight 15 --plotTitle 'kmeans 3 cluster 2 genes dTAG-V P300i sorted' --outFileSortedRegions bed_files/GR_km3c2_dP_sortedRegions_kmeans2.bed

plotHeatmap -m results/DTmat_geneRegion_km3c2_RPGCnorm.gz -out plots/GR_km3c2_dPsorted_RPGCnorm_k3.pdf --colorMap nipy_spectral \
--samplesLabel "NP-LATE" "dP-LATE" --sortUsingSamples 2 --sortUsing median --sortRegion descend --kmeans 3 \
--heatmapHeight 15 --plotTitle 'kmeans 3 cluster 2 genes dTAG-V P300i sorted' --outFileSortedRegions bed_files/GR_km3c2_dP_sortedRegions_kmeans3.bed
