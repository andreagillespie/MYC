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
computeMatrix reference-point --referencePoint center -S \
bigwigs/ND-Nascent.merged.RPGC.bw bigwigs/NP-Nascent.merged.RPGC.bw bigwigs/dD-Nascent.merged.RPGC.bw bigwigs/dP-Nascent.merged.RPGC.bw \
-R ../230427_PROseq/bed_files/CGI_promoter_distanceOrder_CGIendCentered.bed -a 1000 -b 1000 -out results/DTmat_refPoint_CGIprom_RPGCnorm_merged.gz

# unclustered heatmap sorted by ND
plotHeatmap -m results/DTmat_refPoint_CGIprom_RPGCnorm_merged.gz -out plots/RP_CGIprom_distancesorted_RPGCnorm_merged_TTseq.pdf --colorMap viridis \
--samplesLabel "ND-Nascent" "NP-Nascent" "dD-Nascent" "dP-Nascent" \
--legendLocation none --sortRegion keep --zMax 20 \
--heatmapHeight 15 --plotTitle "CGIs overlapping w/promoters of active genes, distance sorted" --outFileSortedRegions bed_files/RP_CGIprom_merged.bed

plotProfile -m results/DTmat_refPoint_CGIprom_RPGCnorm_merged.gz -out plots/Profile_CGIprom_grouped_TTseq.pdf \
--samplesLabel "ND-Nascent" "NP-Nascent" "dD-Nascent" "dP-Nascent" --plotTitle "CGIs overlapping w/promoters of active genes" --perGroup
