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

# run from project dir /scratch/teams/dawson_genomics/Projects/MYC/230420_TTseq/
computeMatrix scale-regions -S \
bigwigs/ND-Total.merged.RPGC.bw bigwigs/NP-Total.merged.RPGC.bw \
bigwigs/dD-Total.merged.RPGC.bw bigwigs/dP-Total.merged.RPGC.bw \
-R /dawson_genomics/Projects/MYC/annotations/mane.expressed.prot.coding.genes.hg38.bed \
-m 10000 -a 5000 -b 5000 -out results/DTmat_geneRegion_MANE_RPGCnorm_merged_Total.gz

# unclustered heatmap sorted by ND
plotHeatmap -m results/DTmat_geneRegion_MANE_RPGCnorm_merged_Total.gz \
-out plots/GR_MANE_NDsorted_RPGCnorm_merged_Total.pdf --colorMap viridis \
--samplesLabel "ND-Total" "NP-Total" "dD-Total" "dP-Total" \
--regionsLabel "MANE genes" --legendLocation none --sortUsingSamples 1 \
--sortUsing sum --sortRegion descend --zMax 15 \
--heatmapHeight 15 --plotTitle "MANE genes, ND sorted"

plotProfile -m results/DTmat_geneRegion_MANE_RPGCnorm_merged_Total.gz \
-out plots/Profile_MANE_grouped_Total.pdf \
--samplesLabel "ND-Total" "NP-Total" "dD-Total" "dP-Total" \
--plotTitle "MANE genes" --perGroup
