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
-R /dawson_genomics/Projects/MYC/220902_ATAC/bed_files/dDvND_ATACup_intergenic.bed \
-a 3000 -b 3000 -out results/DTmat_refPoint_dTAG_ATACup_RPGCnorm_merged.gz

# unclustered heatmap sorted by dP
plotHeatmap -m results/DTmat_refPoint_dTAG_ATACup_RPGCnorm_merged.gz -out plots/RP_dTAG_ATACup_dTAGsorted_RPGCnorm_merged.pdf --colorMap magma_r \
--samplesLabel "ND_LATE" "NP_LATE" "dD_LATE" "dP_LATE" \
--legendLocation none --sortUsingSamples 3 --sortUsing sum --sortRegion keep --zMax 2 \
--heatmapHeight 15 --plotTitle "dTAG intergenic increased accessibility, dTAG sorted" --outFileSortedRegions bed_files/RP_dTAG_ATACup_dDsorted_merged.bed

plotProfile -m results/DTmat_refPoint_dTAG_ATACup_RPGCnorm_merged.gz -out plots/Profile_dTAG_ATACup_merged.pdf \
--samplesLabel "ND_LATE" "NP_LATE" "dD_LATE" "dP_LATE" --plotTitle "dTAG intergenic increased accessibility" --perGroup
