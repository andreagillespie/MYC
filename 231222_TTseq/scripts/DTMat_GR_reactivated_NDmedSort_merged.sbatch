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
bigwigs/ND-nascent-early.merged.RPGC.bw bigwigs/NP-nascent-early.merged.RPGC.bw \
bigwigs/dD-nascent-early.merged.RPGC.bw bigwigs/dP-nascent-early.merged.RPGC.bw \
-R /dawson_genomics/Projects/MYC/230420_TTseq/bed_files/reactivated_genes.bed -m 10000 -a 5000 -b 5000 -out results/DTmat_geneRegion_reactivated_RPGCnorm_merged.gz

# unclustered heatmap sorted by ND
plotHeatmap -m results/DTmat_geneRegion_reactivated_RPGCnorm_merged.gz -out plots/GR_reactivated_TTseq_early_RPGCnorm_merged.pdf --colorMap viridis \
--samplesLabel "ND-nascent-early" "NP-nascent-early" "dD-nascent-early" "dP-nascent-early" \
--regionsLabel "reactivated genes" --legendLocation none --sortUsingSamples 1 --sortUsing sum --sortRegion descend \
--heatmapHeight 15 --plotTitle "Reactivated genes, ND sorted" --outFileSortedRegions bed_files/GR_reactivated_dPsortedRegions_merged.bed

plotProfile -m results/DTmat_geneRegion_reactivated_RPGCnorm_merged.gz -out plots/Profile_reactivated_TTseq_early_grouped.pdf \
--samplesLabel "ND-nascent-early" "NP-nascent-early" "dD-nascent-early" "dP-nascent-early" --plotTitle "Reactivated genes" --perGroup
