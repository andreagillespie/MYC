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
bigwigs/3NP-LATE-R1_S6.RPGC.forward.bw \
bigwigs/5NP-LATE-R1_S2.RPGC.forward.bw \
bigwigs/5NP-LATE-R2_S10.RPGC.forward.bw \
bigwigs/3dP-LATE-R1_S8.RPGC.forward.bw \
bigwigs/5dP-LATE-R1_S4.RPGC.forward.bw \
bigwigs/5dP-LATE-R2_S12.RPGC.forward.bw \
bigwigs/3NP-LATE-R1_S6.RPGC.reverse.bw \
bigwigs/5NP-LATE-R1_S2.RPGC.reverse.bw \
bigwigs/5NP-LATE-R2_S10.RPGC.reverse.bw \
bigwigs/3dP-LATE-R1_S8.RPGC.reverse.bw \
bigwigs/5dP-LATE-R1_S4.RPGC.reverse.bw \
bigwigs/5dP-LATE-R2_S12.RPGC.reverse.bw \
-R bed_files/dPvNP_pos_diff_genes.bed bed_files/dPvNP_neg_diff_genes.bed \
-m 10000 -a 2000 -b 2000 -out results/DTmat_geneRegion_posneg_RPGCnorm_reps.gz

# unclustered heatmap sorted by dP
plotHeatmap -m results/DTmat_geneRegion_posneg_RPGCnorm_reps.gz -out plots/GR_posneg_rep_NPsorted_RPGCnorm.pdf --colorMap nipy_spectral \
--samplesLabel "3NP-R1-fwd" "5NP-R1-fwd" "5NP-R2-fwd" "3dP-R1-fwd" "5dP-R1-fwd" "5dP-R2-fwd" "3NP-R1-rev" "5NP-R1-rev" "5NP-R2-rev" "3dP-R1-rev" "5dP-R1-rev" "5dP-R2-rev" \
--sortUsingSamples 4 5 6 --sortUsing median --sortRegion descend --regionsLabel "positive" "negative" \
--heatmapHeight 15 --plotTitle 'positive/negative differential genes dTAG-V P300i sorted' --outFileSortedRegions bed_files/GR_posneg_rep_NP_sortedRegions.bed


