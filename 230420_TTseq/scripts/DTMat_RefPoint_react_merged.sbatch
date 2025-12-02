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

computeMatrix reference-point -S \
  bigwigs/ND-Nascent.merged.RPGC.bw bigwigs/NP-Nascent.merged.RPGC.bw \
  bigwigs/dD-Nascent.merged.RPGC.bw bigwigs/dP-Nascent.merged.RPGC.bw \
  -R /dawson_genomics/Projects/MYC/annotations/react.new.bed \
  --referencePoint TSS -bs 50 --sortRegions ascend --sortUsing region_length \
  -a 50000 -b 5000 --missingDataAsZero -p 2 \
  -out results/DTmat_RefPoint_react_RPGCnorm_merged.gz

# unclustered heatmap sorted by dP
plotHeatmap -m results/DTmat_RefPoint_react_RPGCnorm_merged.gz \
  -out plots/RP_react_RPGCnorm_merged.pdf --colorMap viridis \
  --samplesLabel "ND-Nascent" "NP-Nascent" "dD-Nascent" "dP-Nascent" --dpi 300 \
  --sortRegions ascend --sortUsing region_length \
  --heatmapHeight 10 --plotTitle "reactivated genes" \
  --outFileSortedRegions bed_files/RP_react_merged.bed \
  --whatToShow "heatmap and colorbar" 

