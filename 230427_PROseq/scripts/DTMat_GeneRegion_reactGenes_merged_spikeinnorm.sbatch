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
bigwigs/ND_LATE.merged.spikein.bw bigwigs/NP_LATE.merged.spikein.bw \
bigwigs/dD_LATE.merged.spikein.bw bigwigs/dP_LATE.merged.spikein.bw \
-R /dawson_genomics/Projects/MYC/230420_TTseq/bed_files/mane_reactivated_genes.bed \
-m 10000 -a 5000 -b 5000 -out results/DTmat_geneRegion_reactGenes_spikeinnorm_merged.gz

# unclustered heatmap sorted by dP
plotHeatmap -m results/DTmat_geneRegion_reactGenes_spikeinnorm_merged.gz \
-out plots/GR_reactGenes_NDsorted_spikeinnorm_merged.pdf --colorMap magma \
--samplesLabel "ND_LATE" "NP_LATE" "dD_LATE" "dP_LATE" \
--legendLocation none --sortUsingSamples 1 --sortUsing median --sortRegion descend \
--heatmapHeight 10 --plotTitle "reactivated genes, ND sorted, spike-in norm" \
--outFileSortedRegions bed_files/GR_reactGenes_NDsorted_merged_spikeinnorm.bed

plotProfile -m results/DTmat_geneRegion_reactGenes_spikeinnorm_merged.gz \
-out plots/Profile_reactGenes_merged_spikeinnorm_yMax25.pdf \
--samplesLabel "ND_LATE" "NP_LATE" "dD_LATE" "dP_LATE" \
--plotTitle "reactivated genes, spike-in norm" --perGroup --yMax 25
