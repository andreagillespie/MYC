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
bigwigs/GSM4555055_qPROseq_1M_K562_Rep1_deDuped_fwd.bw bigwigs/GSM4555056_qPROseq_1M_K562_Rep2_deDuped_fwd.bw \
bigwigs/GSM4555055_qPROseq_1M_K562_Rep1_deDuped_rev.bw bigwigs/GSM4555056_qPROseq_1M_K562_Rep2_deDuped_rev.bw \
-R /data/reference/dawson_labs/bed_files/Hg38/Hg38EnsGeneDT.bed \
-m 10000 -a 5000 -b 5000 -out results/DTmat_geneRegion_allGenes_stranded.gz

# unclustered heatmap sorted by dP
plotHeatmap -m results/DTmat_geneRegion_allGenes_stranded.gz -out plots/GR_allGenes_NDsorted_stranded.pdf --colorMap magma \
--samplesLabel "rep1_fwd" "rep2_fwd" "rep1_rev" "rep2_rev" \
--legendLocation none --sortUsingSamples 1 --sortUsing median --sortRegion descend \
--heatmapHeight 15 --plotTitle "All genes, rep1 fwd sorted" 

plotProfile -m results/DTmat_geneRegion_allGenes_stranded.gz -out plots/Profile_allGenes_stranded.pdf \
--samplesLabel "rep1_fwd" "rep2_fwd" "rep1_rev" "rep2_rev" --plotTitle "All genes" --perGroup

plotProfile -m results/DTmat_geneRegion_allGenes_stranded.gz -out plots/Profile_allGenes_stranded_ungrouped.pdf \
--samplesLabel "rep1_fwd" "rep2_fwd" "rep1_rev" "rep2_rev" --plotTitle "All genes" 
