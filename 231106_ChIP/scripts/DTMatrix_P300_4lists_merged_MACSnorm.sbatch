#!/bin/bash
 
#SBATCH --nodes=1
#SBATCH --ntasks=1
#SBATCH --mem-per-cpu=32G
#SBATCH --time=2-0:00:00
#SBATCH --output=logs/deeptoolsMatrix%j.stdout
#SBATCH --mail-user=andrea.gillespie@petermac.org
#SBATCH --mail-type=END,TIME_LIMIT_80
#SBATCH --job-name="DTMatrix"
#SBATCH --partition=prod

module load deeptools/3.5.0

computeMatrix reference-point --referencePoint center -S \
bigwigs/untreated.MACSnorm.bw bigwigs/A485.MACSnorm.bw \
bigwigs/dTAG.MACSnorm.bw bigwigs/dTAG-and-A485.MACSnorm.bw \
-R bed_files/dD.v.ND.sig.intervals.UP.bed bed_files/dD.v.ND.sig.intervals.DN.bed \
/dawson_genomics/Projects/MYC/230420_TTseq/bed_files/K562_ENCODE_sedb_01_0039.bed /data/reference/dawson_labs/bed_files/Hg38/Hg38EnsTSSStrandPlusMinusWhitelist.bed \
-a 3000 -b 3000 -o results/DTmatrix_MACSnorm_4lists_merged.gz

plotHeatmap -m results/DTmatrix_MACSnorm_4lists_merged.gz --sortUsingSamples 3 --sortUsing sum \
--samplesLabel untreated A485 dTAG dTAG-and-A485 \
--colorMap BuPu --regionsLabel "ATAC up" "ATAC down" "superenhancers" "TSS" --zMax 12 \
-o plots/Heatmap_MACSnorm_4lists_merged.pdf --plotTitle "P300 ChIP, dTAG sorted"

plotProfile -m results/DTmatrix_MACSnorm_4lists_merged.gz -out plots/Profile_MACSnorm_4lists_merged.pdf \
--samplesLabel untreated A485 dTAG dTAG-and-A485 --regionsLabel "ATAC up" "ATAC down" "superenhancers" "TSS" \
--plotTitle "P300 ChIP, all genes" --perGroup
