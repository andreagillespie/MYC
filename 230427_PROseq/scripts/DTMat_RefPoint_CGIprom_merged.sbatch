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
bigwigs/ND_LATE.merged.RPGC.bw bigwigs/NP_LATE.merged.RPGC.bw \
bigwigs/dD_LATE.merged.RPGC.bw bigwigs/dP_LATE.merged.RPGC.bw \
-R bed_files/CGI_promoter_distanceOrder_CGIendCentered.bed \
-a 1000 -b 1000 -out results/DTmat_refPoint_CGIprom_RPGCnorm_merged.gz

# unclustered heatmap sorted by dP
plotHeatmap -m results/DTmat_refPoint_CGIprom_RPGCnorm_merged.gz -out plots/RP_CGIprom_distancesorted_RPGCnorm_merged.pdf --colorMap magma \
--samplesLabel "ND_LATE" "NP_LATE" "dD_LATE" "dP_LATE" \
--legendLocation none --sortUsingSamples 1 --sortUsing median --sortRegion keep \
--heatmapHeight 15 --plotTitle "CGIs overlapping w/promoters of active genes, distance sored" --outFileSortedRegions bed_files/RP_CGIprom_NDsorted_merged.bed

plotProfile -m results/DTmat_refPoint_CGIprom_RPGCnorm_merged.gz -out plots/Profile_CGIprom_merged.pdf \
--samplesLabel "ND_LATE" "NP_LATE" "dD_LATE" "dP_LATE" --plotTitle "CGIs overlapping w/promoters of active genes" --perGroup
