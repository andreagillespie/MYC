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
nf-core_nascent/deeptools/3ND_LATE_R1_T1.plus.bigWig \
nf-core_nascent/deeptools/3ND_LATE_R1_T1.minus.bigWig \
nf-core_nascent/deeptools/3NP_LATE_R1_T1.plus.bigWig \
nf-core_nascent/deeptools/3NP_LATE_R1_T1.minus.bigWig \
nf-core_nascent/deeptools/3dD_LATE_R1_T1.plus.bigWig \
nf-core_nascent/deeptools/3dD_LATE_R1_T1.minus.bigWig \
nf-core_nascent/deeptools/3dP_LATE_R1_T1.plus.bigWig \
nf-core_nascent/deeptools/3dP_LATE_R1_T1.minus.bigWig \
-R /dawson_genomics/Projects/MYC/230420_TTseq/bed_files/dPvNPonly_up_genes.bed \
-m 10000 -a 2000 -b 2000 -out results/DTmat_geneRegion_dPvNPonlyUp_RPGCnorm.gz

# unclustered heatmap sorted by dP
plotHeatmap -m results/DTmat_geneRegion_dPvNPonlyUp_RPGCnorm.gz -out plots/GR_dPvNPonlyUp_NDsorted_RPGCnorm.pdf --colorMap nipy_spectral \
--samplesLabel "3ND_LATE_plus" "3ND_LATE_minus" "3NP_LATE_plus" "3NP_LATE_minus" "3dD_LATE_plus" "3dD_LATE_minus" "3dP_LATE_plus" "3dP_LATE_minus" \
--legendLocation none --sortUsingSamples 2 --sortUsing median --sortRegion descend \
--heatmapHeight 15 --plotTitle 'All genes dTAG-V P300i sorted' --outFileSortedRegions bed_files/GR_dPvNPonlyUp_NDsortedRegions.bed

# check for cluster of varying behaviour
plotHeatmap -m results/DTmat_geneRegion_dPvNPonlyUp_RPGCnorm.gz -out plots/GR_dPvNPonlyUp_NDsorted_RPGCnorm_k2.pdf --colorMap nipy_spectral \
--samplesLabel "3ND_LATE_plus" "3ND_LATE_minus" "3NP_LATE_plus" "3NP_LATE_minus" "3dD_LATE_plus" "3dD_LATE_minus" "3dP_LATE_plus" "3dP_LATE_minus" \
--sortUsingSamples 2 --sortUsing median --sortRegion descend --kmeans 2 \
--heatmapHeight 15 --plotTitle 'All genes dTAG-V P300i sorted' --outFileSortedRegions bed_files/GR_dPvNPonlyUp_NDsortedRegions_kmeans2.bed

plotHeatmap -m results/DTmat_geneRegion_dPvNPonlyUp_RPGCnorm.gz -out plots/GR_dPvNPonlyUp_NDsorted_RPGCnorm_k3.pdf --colorMap nipy_spectral \
--samplesLabel "3ND_LATE_plus" "3ND_LATE_minus" "3NP_LATE_plus" "3NP_LATE_minus" "3dD_LATE_plus" "3dD_LATE_minus" "3dP_LATE_plus" "3dP_LATE_minus" \
--sortUsingSamples 2 --sortUsing median --sortRegion descend --kmeans 3 \
--heatmapHeight 15 --plotTitle 'All genes dTAG-V P300i sorted' --outFileSortedRegions bed_files/GR_dPvNPonlyUp_NDsortedRegions_kmeans3.bed
