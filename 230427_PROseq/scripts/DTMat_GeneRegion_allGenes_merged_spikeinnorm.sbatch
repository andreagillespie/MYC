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
-R /dawson_genomics/Projects/MYC/annotations/mane.expressed.prot.coding.genes.hg38.bed \
-m 10000 -a 5000 -b 5000 -out results/DTmat_geneRegion_allGenes_spikeinnorm_merged.gz

# unclustered heatmap sorted by ND
plotHeatmap -m results/DTmat_geneRegion_allGenes_spikeinnorm_merged.gz \
-out plots/GR_allGenes_NDsorted_spikeinnorm_merged.pdf --colorMap magma \
--samplesLabel "ND_LATE" "NP_LATE" "dD_LATE" "dP_LATE" \
--legendLocation none --sortUsingSamples 1 --sortUsing median --sortRegion descend \
--heatmapHeight 15 --plotTitle "All genes, ND sorted, spike-in norm" \
--outFileSortedRegions bed_files/GR_allGenes_NDsorted_merged_spikinnorm.bed

plotProfile -m results/DTmat_geneRegion_allGenes_spikeinnorm_merged.gz \
-out plots/Profile_allGenes_merged_spikeinnorm.pdf \
--samplesLabel "ND_LATE" "NP_LATE" "dD_LATE" "dP_LATE" \
--plotTitle "All genes, spike-in norm" --perGroup

# also make zoomed in profile plot
plotProfile -m results/DTmat_geneRegion_allGenes_spikeinnorm_merged.gz \
-out plots/Profile_allGenes_merged_spikeinnorm_yMax10.pdf \
--samplesLabel "ND_LATE" "NP_LATE" "dD_LATE" "dP_LATE" \
--plotTitle "All genes, spike-in norm" --perGroup --yMax 10
