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
bigwigs/ND-Total.merged.RPGC.bw bigwigs/NP-Total.merged.RPGC.bw \
bigwigs/dD-Total.merged.RPGC.bw bigwigs/dP-Total.merged.RPGC.bw \
-R bed_files/mane_reactivated_genes.bed -m 10000 -a 5000 -b 5000 \
-o results/DTmat_geneRegion_reactivated_RPGCnorm_merged_Total.gz

# unclustered heatmap sorted by ND
plotHeatmap -m results/DTmat_geneRegion_reactivated_RPGCnorm_merged_Total.gz \
-out plots/GR_reactivated_NDsorted_RPGCnorm_merged_Total.pdf --colorMap magma \
--samplesLabel "ND-Total" "NP-Total" "dD-Total" "dP-Total" \
--regionsLabel "reactivated genes" --legendLocation none --sortUsingSamples 1 \
--sortUsing sum --sortRegion descend \
--heatmapHeight 10 --plotTitle "Reactivated genes, ND sorted" \
--outFileSortedRegions bed_files/GR_dPvNPonlyUp_dPsortedRegions_merged_Total.bed

plotProfile -m results/DTmat_geneRegion_reactivated_RPGCnorm_merged_Total.gz \
-out plots/Profile_reactivated_grouped_Total.pdf \
--samplesLabel "ND-Total" "NP-Total" "dD-Total" "dP-Total" \
--plotTitle "Reactivated genes" --perGroup
