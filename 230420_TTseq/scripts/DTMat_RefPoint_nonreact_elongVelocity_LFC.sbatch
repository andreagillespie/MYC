#!/bin/bash
 
#SBATCH --nodes=1
#SBATCH --cpus-per-task=2
#SBATCH --mem=24G
#SBATCH --time=0-08:00:00
#SBATCH --output=logs/deeptoolsCov%j.stdout
#SBATCH --mail-user=andrea.gillespie@petermac.org
#SBATCH --mail-type=END,TIME_LIMIT_80
#SBATCH --job-name="bwCompare"
#SBATCH --partition=prod_med

module purge
module load deeptools/3.5.0

# run from TTseq dir
# compute matrix of TTseq/PROseq LFC 
computeMatrix reference-point -S \
  bwCompare/TTseq_PROseq_ND_LATE_LFC.bw bwCompare/TTseq_PROseq_NP_LATE_LFC.bw \
  bwCompare/TTseq_PROseq_dD_LATE_LFC.bw bwCompare/TTseq_PROseq_dP_LATE_LFC.bw \
  -R /dawson_genomics/Projects/MYC/240711_ChIP/bed/non.react.new.bed \
  --referencePoint TSS -bs 50 --sortRegions ascend --sortUsing region_length \
  -a 50000 -b 5000 --missingDataAsZero -p 2 \
  -o results/DTmat_RefPoint_nonreact_expressed_elongVeloLFC.gz

# plot heatmap
plotHeatmap -m results/DTmat_RefPoint_nonreact_expressed_elongVeloLFC.gz \
  -o plots/RP_nonreact_expressed_elongVeloLFC.pdf --dpi 300 \
  --samplesLabel "ND" "NP" "dD" "dP" --heatmapHeight 10 \
  --plotTitle "Elongation Velocity LFC, non-reactivated genes" \
  --sortRegions ascend --sortUsing region_length --colorMap PRGn \
  --whatToShow "heatmap and colorbar" -min -3 -max 3




