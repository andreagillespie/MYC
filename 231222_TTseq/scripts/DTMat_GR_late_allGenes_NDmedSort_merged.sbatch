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

# run from project dir /scratch/teams/dawson_genomics/Projects/MYC/231222_TTseq/
computeMatrix scale-regions -S \
bigwigs/ND-nascent-early-total.merged.RPGC.bw bigwigs/NP-nascent-early-total.merged.RPGC.bw \
bigwigs/dD-nascent-early-total.merged.RPGC.bw bigwigs/dP-nascent-early-total.merged.RPGC.bw \
-R /dawson_genomics/Projects/MYC/annotations/mane.expressed.prot.coding.genes.hg38.bed \
-m 10000 -a 5000 -b 5000 -out results/DTmat_geneRegion_allGenes_RPGCnorm_merged_total.gz

# unclustered heatmap sorted by ND
plotHeatmap -m results/DTmat_geneRegion_allGenes_RPGCnorm_merged_total.gz \
-out plots/GR_allGEnes_TTseq_early_RPGCnorm_merged_total.pdf --colorMap viridis \
--samplesLabel "ND-total-early" "NP-total-early" "dD-total-early" "dP-total-early" \
--regionsLabel "MANE genes" --legendLocation none --sortUsingSamples 1 \
--sortUsing sum --sortRegion descend --heatmapHeight 15 \
--plotTitle "MANE genes, ND sorted" \
--outFileSortedRegions bed_files/GR_allGenes_NDsortedRegions_merged_total.bed

plotProfile -m results/DTmat_geneRegion_allGenes_RPGCnorm_merged_total.gz \
-out plots/Profile_allGenes_TTseq_early_grouped_total.pdf \
--samplesLabel "ND-total-early" "NP-total-early" "dD-total-early" "dP-total-early" \
--plotTitle "MANE genes" --perGroup
