#!/usr/bin/env bash
#SBATCH --nodes=1
#SBATCH --cpus-per-task=4
#SBATCH --mem=32G
#SBATCH --time=1-00:00:00
#SBATCH --output=logs/deeptoolsMatrix%j.stdout
#SBATCH --mail-type=END,TIME_LIMIT_80
#SBATCH --mail-user=andrea.gillespie@petermac.org
#SBATCH --job-name="Heatmap_GeneRegion"
#SBATCH --partition=prod_med

module purge
module load deeptools/3.5.0

# run from project dir /scratch/teams/dawson_genomics/Projects/MYC/230427_PROseq/
computeMatrix scale-regions -S \
bigwigs/ND_LATE.merged.RPGC.forward.bw bigwigs/NP_LATE.merged.RPGC.forward.bw \
bigwigs/dD_LATE.merged.RPGC.forward.bw bigwigs/dP_LATE.merged.RPGC.forward.bw \
bigwigs/ND_LATE.merged.RPGC.reverse.bw bigwigs/NP_LATE.merged.RPGC.reverse.bw \
bigwigs/dD_LATE.merged.RPGC.reverse.bw bigwigs/dP_LATE.merged.RPGC.reverse.bw \
-R /data/reference/dawson_labs/bed_files/Hg38/Hg38EnsGeneDT.bed \
-m 10000 -a 5000 -b 5000 -out results/DTmat_geneRegion_allGenes_RPGCnorm_stranded.gz

# unclustered heatmap sorted by dP
plotHeatmap -m results/DTmat_geneRegion_allGenes_RPGCnorm_stranded.gz -out plots/GR_allGenes_NDsorted_RPGCnorm_stranded.pdf --colorMap magma \
--samplesLabel "ND_LATE_plus" "NP_LATE_plus" "dD_LATE_plus" "dP_LATE_plus" "ND_LATE_minus" "NP_LATE_minus" "dD_LATE_minus" "dP_LATE_minus" \
--legendLocation none --sortUsingSamples 1 --sortUsing median --sortRegion descend \
--heatmapHeight 15 --plotTitle "All genes, ND plus sorted" 

plotProfile -m results/DTmat_geneRegion_allGenes_RPGCnorm_stranded.gz -out plots/Profile_allGenes_stranded.pdf \
--samplesLabel "ND_LATE_plus" "NP_LATE_plus" "dD_LATE_plus" "dP_LATE_plus" "ND_LATE_minus" "NP_LATE_minus" "dD_LATE_minus" "dP_LATE_minus" \
--plotTitle "All genes" --perGroup
