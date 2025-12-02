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
nf-core_nascent/deeptools/5ND_LATE_R1_T1.plus.bigWig nf-core_nascent/deeptools/5NP_LATE_R1_T1.plus.bigWig \
nf-core_nascent/deeptools/5dD_LATE_R1_T1.plus.bigWig nf-core_nascent/deeptools/5dP_LATE_R1_T1.plus.bigWig \
nf-core_nascent/deeptools/5ND_LATE_R1_T1.minus.bigWig nf-core_nascent/deeptools/5NP_LATE_R1_T1.minus.bigWig \
nf-core_nascent/deeptools/5dD_LATE_R1_T1.minus.bigWig nf-core_nascent/deeptools/5dP_LATE_R1_T1.minus.bigWig \
-R /dawson_genomics/Projects/MYC/230420_TTseq/bed_files/dPvNPonly_up_genes.bed \
-m 10000 -a 5000 -b 5000 -out results/DTmat_geneRegion_dPvNPonlyUp_RPGCnorm_stranded_rep5_1.gz

# unclustered heatmap sorted by dP
plotHeatmap -m results/DTmat_geneRegion_dPvNPonlyUp_RPGCnorm_stranded_rep5_1.gz -out plots/GR_dPvNPonlyUp_NDsorted_stranded_rep5_1.pdf --colorMap magma \
--samplesLabel "ND_LATE_plus" "NP_LATE_plus" "dD_LATE_plus" "dP_LATE_plus" "ND_LATE_minus" "NP_LATE_minus" "dD_LATE_minus" "dP_LATE_minus" \
--legendLocation none --sortUsingSamples 1 --sortUsing median --sortRegion descend \
--heatmapHeight 15 --plotTitle "dPvNP only genes, ND plus sorted" 

plotProfile -m results/DTmat_geneRegion_dPvNPonlyUp_RPGCnorm_stranded_rep5_1.gz -out plots/Profile_dPvNPonlyUp_stranded_rep5_1.pdf \
--samplesLabel "ND_LATE_plus" "NP_LATE_plus" "dD_LATE_plus" "dP_LATE_plus" "ND_LATE_minus" "NP_LATE_minus" "dD_LATE_minus" "dP_LATE_minus" \
--plotTitle "dPvNP only genes" --perGroup
