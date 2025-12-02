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

computeMatrix scale-regions -S \
bigwigs/dPvNP.LFC.bw bigwigs/dDvND.LFC.bw bigwigs/NPvND.LFC.bw \
-R bed_files/reactivated_genes.bed -m 10000 -a 5000 -b 5000 -out results/DTmat_geneRegion_reactivated_RPGCnorm_merged_LFC.gz

# unclustered heatmap sorted by dP
plotHeatmap -m results/DTmat_geneRegion_reactivated_RPGCnorm_merged_LFC.gz -out plots/GR_reactivated_dPsorted_RPGCnorm_merged_LFC.pdf \
--samplesLabel "dPvNP" "dDvND" "NPvND" --colorMap RdYlBu_r \
--regionsLabel "reactivated genes LFC" --legendLocation none --sortUsingSamples 1 --sortUsing sum --sortRegion descend \
--heatmapHeight 15 --plotTitle "Reactivated genes, dPvNP sorted"

plotProfile -m results/DTmat_geneRegion_reactivated_RPGCnorm_merged_LFC.gz -out plots/Profile_LFC_reactivated_grouped.pdf \
--samplesLabel "dPvNP" "dDvND" "NPvND" --plotTitle "Reactivated genes" --perGroup

