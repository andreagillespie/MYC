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
bigwigs/dPvNP.LFC.bw bigwigs/dDvND.LFC.bw bigwigs/NPvND.LFC.bw \
-R /dawson_genomics/Projects/MYC/230420_TTseq/bed_files/reactivated_genes.bed \
-m 10000 -a 5000 -b 5000 -out results/DTmat_geneRegion_reactGenes_LFC_RPGCnorm_merged.gz

# unclustered heatmap sorted by dP
plotHeatmap -m results/DTmat_geneRegion_reactGenes_LFC_RPGCnorm_merged.gz -out plots/GR_reactGenes_LFC_NDsorted_RPGCnorm_merged.pdf --colorMap RdYlBu_r \
--samplesLabel "dPvNP" "dDvND" "NPvND" \
--legendLocation none --sortUsingSamples 1 --sortUsing median --sortRegion descend \
--heatmapHeight 15 --plotTitle "reactivated genes, dPvND sorted" --outFileSortedRegions bed_files/GR_reactGenes_LFC_NDsorted_merged.bed

plotProfile -m results/DTmat_geneRegion_reactGenes_LFC_RPGCnorm_merged.gz -out plots/Profile_reactGenes_LFC_merged.pdf \
--samplesLabel "dPvNP" "dDvND" "NPvND" --plotTitle "reactivated genes, LFC" --perGroup
