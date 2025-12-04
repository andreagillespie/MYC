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
bigwigs/SF3B1-NEG.merged.RPGC.bw bigwigs/SF3B1-V.merged.RPGC.bw \
bigwigs/SF3B3-NEG.merged.RPGC.bw bigwigs/SF3B3-V.merged.RPGC.bw \
bigwigs/SF3B5-NEG.merged.RPGC.bw bigwigs/SF3B5-V.merged.RPGC.bw \
-R /data/reference/dawson_labs/bed_files/Hg38/Hg38_MANE_ProteinCoding.bed \
-m 10000 -a 5000 -b 5000 -out results/DTmat_geneRegion_pcGenes_RPGCnorm_merged.gz

# unclustered heatmap sorted by dP
plotHeatmap -m results/DTmat_geneRegion_pcGenes_RPGCnorm_merged.gz -out plots/GR_pcGenes_SF3B3NEGsorted_RPGCnorm_merged.pdf --colorMap magma_r \
--samplesLabel "SF3B1-NEG" "SF3B1-V" "SF3B3-NEG" "SF3B3-V" "SF3B5-NEG" "SF3B5-V" \
--legendLocation none --sortUsingSamples 3 --sortUsing median --sortRegion descend \
--heatmapHeight 15 --plotTitle "All genes, SF3B3NEG sorted" --outFileSortedRegions bed_files/GR_pcGenes_SF3B3NEGsorted_merged.bed

plotProfile -m results/DTmat_geneRegion_pcGenes_RPGCnorm_merged.gz -out plots/Profile_SF3B_pcGenes_merged.pdf \
--samplesLabel "SF3B1-NEG" "SF3B1-V" "SF3B3-NEG" "SF3B3-V" "SF3B5-NEG" "SF3B5-V" --plotTitle "MANE genes" --perGroup
