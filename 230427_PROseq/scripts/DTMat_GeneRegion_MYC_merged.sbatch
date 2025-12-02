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
bigwigs/ND_LATE.merged.RPGC.bw bigwigs/NP_LATE.merged.RPGC.bw \
bigwigs/dD_LATE.merged.RPGC.bw bigwigs/dP_LATE.merged.RPGC.bw \
-R bed_files/MYC_DT.bed -m 10000 -a 5000 -b 5000 -out results/DTmat_geneRegion_MYC_RPGCnorm_merged.gz

plotProfile -m results/DTmat_geneRegion_MYC_RPGCnorm_merged.gz -out plots/Profile_MYC_merged.pdf \
--samplesLabel "ND_LATE" "NP_LATE" "dD_LATE" "dP_LATE" --plotTitle "MYC" --perGroup
