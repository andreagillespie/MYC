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
  bigwigs/dPvNP.LFC.bw bigwigs/dDvND.LFC.bw bigwigs/NPvND.LFC.bw \
  -R /dawson_genomics/Projects/MYC/annotations/react.new.bed \
  --referencePoint TSS -bs 50 --sortRegions ascend --sortUsing region_length \
  -a 50000 -b 5000 --missingDataAsZero -p 2 \
  -out results/DTmat_RefPoint_react_LFC_RPGCnorm_merged.gz

# unclustered heatmap sorted by dP
plotHeatmap -m results/DTmat_RefPoint_react_LFC_RPGCnorm_merged.gz \
  -out plots/RP_react_LFC_RPGCnorm_merged.pdf --colorMap RdYlBu_r \
  --samplesLabel "dPvNP" "dDvND" "NPvND" --dpi 300 \
  --sortRegions ascend --sortUsing region_length \
  --heatmapHeight 10 --plotTitle "reactivated genes, LFC" \
  --outFileSortedRegions bed_files/RP_react_LFC_merged.bed \
  --whatToShow "heatmap and colorbar" -min -3 -max 3
