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
bigwigs/3ND-1-Nascent_S417.RPGC.bw bigwigs/5ND-1-Nascent_S400.RPGC.bw bigwigs/5ND-2-Nascent_S421.RPGC.bw bigwigs/5ND-3-Nascent_S393.RPGC.bw \
bigwigs/3NP-1-Nascent_S418.RPGC.bw bigwigs/5NP-1-Nascent_S411.RPGC.bw bigwigs/5NP-2-Nascent_S390.RPGC.bw bigwigs/5NP-3-Nascent_S394.RPGC.bw \
bigwigs/3dD-1-Nascent_S419.RPGC.bw bigwigs/5dD-1-Nascent_S415.RPGC.bw bigwigs/5dD-2-Nascent_S391.RPGC.bw bigwigs/5dD-3-Nascent_S395.RPGC.bw \
bigwigs/3dP-1-Nascent_S420.RPGC.bw bigwigs/5dP-1-Nascent_S416.RPGC.bw bigwigs/5dP-2-Nascent_S392.RPGC.bw bigwigs/5dP-3-Nascent_S396.RPGC.bw \
-R bed_files/dPvNPonly_up_genes.bed -m 10000 -a 2000 -b 2000 -out results/DTmat_geneRegion_dPvNPonlyUp_RPGCnorm.gz

# unclustered heatmap sorted by dP
plotHeatmap -m results/DTmat_geneRegion_dPvNPonlyUp_RPGCnorm.gz -out plots/GR_dPvNPonlyUp_dPsorted_RPGCnorm.pdf --colorMap magma \
--samplesLabel "3ND-1-Nascent" "5ND-1-Nascent" "5ND-2-Nascent" "5ND-3-Nascent" "3NP-1-Nascent" "5NP-1-Nascent" "5NP-2-Nascent" "5NP-3-Nascent" \
"3dD-1-Nascent" "5dD-1-Nascent" "5dD-2-Nascent" "5dD-3-Nascent" "3dP-1-Nascent" "5dP-1-Nascent" "5dP-2-Nascent" "5dP-3-Nascent" \
--regionsLabel "dPvNP genes" --legendLocation none --sortUsingSamples 16 --sortUsing sum --sortRegion descend \
--heatmapHeight 15 --plotTitle 'dPvNP only up genes, dTAG-V P300i sorted' --outFileSortedRegions bed_files/GR_dPvNPonlyUp_dPsortedRegions.bed

plotHeatmap -m results/DTmat_geneRegion_dPvNPonlyUp_RPGCnorm.gz -out plots/GR_dPvNPonlyUp_dPsorted_RPGCnorm_km2.pdf --colorMap magma \
--samplesLabel "3ND-1-Nascent" "5ND-1-Nascent" "5ND-2-Nascent" "5ND-3-Nascent" "3NP-1-Nascent" "5NP-1-Nascent" "5NP-2-Nascent" "5NP-3-Nascent" \
"3dD-1-Nascent" "5dD-1-Nascent" "5dD-2-Nascent" "5dD-3-Nascent" "3dP-1-Nascent" "5dP-1-Nascent" "5dP-2-Nascent" "5dP-3-Nascent" \
--sortUsingSamples 16 --sortUsing sum --sortRegion descend --kmeans 2 \
--heatmapHeight 15 --plotTitle 'dPvNP only up genes, dTAG-V P300i sorted' --outFileSortedRegions bed_files/GR_dPvNPonlyUp_dPsortedRegions_km2.bed

plotHeatmap -m results/DTmat_geneRegion_dPvNPonlyUp_RPGCnorm.gz -out plots/GR_dPvNPonlyUp_dPsorted_RPGCnorm_km3.pdf --colorMap magma \
--samplesLabel "3ND-1-Nascent" "5ND-1-Nascent" "5ND-2-Nascent" "5ND-3-Nascent" "3NP-1-Nascent" "5NP-1-Nascent" "5NP-2-Nascent" "5NP-3-Nascent" \
"3dD-1-Nascent" "5dD-1-Nascent" "5dD-2-Nascent" "5dD-3-Nascent" "3dP-1-Nascent" "5dP-1-Nascent" "5dP-2-Nascent" "5dP-3-Nascent" \
--sortUsingSamples 16 --sortUsing sum --sortRegion descend --kmeans 3 \
--heatmapHeight 15 --plotTitle 'dPvNP only up genes, dTAG-V P300i sorted' --outFileSortedRegions bed_files/GR_dPvNPonlyUp_dPsortedRegions_km3.bed
