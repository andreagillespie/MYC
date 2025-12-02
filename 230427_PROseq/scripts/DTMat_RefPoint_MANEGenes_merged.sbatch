#!/usr/bin/env bash
#SBATCH --nodes=1
#SBATCH --cpus-per-task=2
#SBATCH --mem=24G
#SBATCH --time=0-16:00:00
#SBATCH --output=logs/deeptoolsMatrix%j.stdout
#SBATCH --mail-type=END,TIME_LIMIT_80
#SBATCH --mail-user=andrea.gillespie@petermac.org
#SBATCH --job-name="Heatmap_GeneRegion"
#SBATCH --partition=prod_med

module purge
module load deeptools/3.5.0

# run from project dir /scratch/teams/dawson_genomics/Projects/MYC/230427_PROseq/
computeMatrix reference-point -S \
  bigwigs/ND_LATE.merged.RPGC.bw bigwigs/NP_LATE.merged.RPGC.bw \
  bigwigs/dD_LATE.merged.RPGC.bw bigwigs/dP_LATE.merged.RPGC.bw \
  -R /dawson_genomics/Projects/MYC/annotations/mane.expressed.prot.coding.genes.hg38.bed \
  --referencePoint TSS -bs 50 --sortRegions ascend --sortUsing region_length \
  -a 50000 -b 5000 --missingDataAsZero -p 2 \
  -out results/DTmat_RefPoint_MANE_RPGCnorm_merged.gz

# unclustered heatmap sorted by dP
plotHeatmap -m results/DTmat_RefPoint_MANE_RPGCnorm_merged.gz \
  -out plots/RP_MANE_RPGCnorm_merged.pdf --colorMap magma \
  --samplesLabel "ND_LATE" "NP_LATE" "dD_LATE" "dP_LATE" --dpi 300 \
  --sortRegions ascend --sortUsing region_length \
  --heatmapHeight 15 --plotTitle "expressed MANE genes" \
  --outFileSortedRegions bed_files/RP_MANE_merged.bed \
  --whatToShow "heatmap and colorbar" -max 8
