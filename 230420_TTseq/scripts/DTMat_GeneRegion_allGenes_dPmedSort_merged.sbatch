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
bigwigs/ND-Nascent.merged.RPGC.bw bigwigs/NP-Nascent.merged.RPGC.bw bigwigs/dD-Nascent.merged.RPGC.bw bigwigs/dP-Nascent.merged.RPGC.bw \
-R /data/reference/dawson_labs/bed_files/Hg38/Hg38EnsGeneDT.bed -m 10000 -a 5000 -b 5000 -out results/DTmat_geneRegion_allGenes_RPGCnorm_merged.gz

# unclustered heatmap sorted by ND
plotHeatmap -m results/DTmat_geneRegion_allGenes_RPGCnorm_merged.gz -out plots/GR_allGenes_NDsorted_RPGCnorm_merged.pdf --colorMap magma \
--samplesLabel "ND-Nascent" "NP-Nascent" "dD-Nascent" "dP-Nascent" \
--regionsLabel "dPvNP genes" --legendLocation none --sortUsingSamples 1 --sortUsing sum --sortRegion descend --zMax 15 \
--heatmapHeight 15 --plotTitle "All genes, ND sorted" --outFileSortedRegions bed_files/GR_dPvNPonlyUp_dPsortedRegions_merged.bed

plotProfile -m results/DTmat_geneRegion_allGenes_RPGCnorm_merged.gz -out plots/Profile_allGenes_grouped.pdf \
--samplesLabel "ND-Nascent" "NP-Nascent" "dD-Nascent" "dP-Nascent" --plotTitle "All genes" --perGroup
