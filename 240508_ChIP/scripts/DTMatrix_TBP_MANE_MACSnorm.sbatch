#!/bin/bash
 
#SBATCH --nodes=1
#SBATCH --ntasks=1
#SBATCH --mem-per-cpu=12G
#SBATCH --time=0-12:00:00
#SBATCH --output=logs/deeptoolsMatrix%j.stdout
#SBATCH --mail-user=andrea.gillespie@petermac.org
#SBATCH --mail-type=END,TIME_LIMIT_80
#SBATCH --job-name="DTMatrix"
#SBATCH --partition=prod_med

module load deeptools/3.5.0

computeMatrix scale-regions -S \
bigwigs/TBP-DMSO-R1_S112.MACSnorm.bw bigwigs/TBP-A485-R1_S88.MACSnorm.bw \
bigwigs/TBP-dTAG-R1_S87.MACSnorm.bw bigwigs/TBP-dTAG-A485-R1_S89.MACSnorm.bw \
-R /data/reference/dawson_labs/bed_files/Hg38/Hg38_MANE_ProteinCoding.bed \
-a 3000 -b 3000 -m 5000 -o results/DTmatrix_TBP_MANE.gz

plotHeatmap -m results/DTmatrix_TBP_MANE.gz --sortUsingSamples 3 --sortUsing sum \
--samplesLabel TBP-DMSO TBP-A485 TBP-dTAG TBP-A485-dTAG \
--colorMap Purples --regionsLabel "protein coding genes (MANE)" \
-o plots/Heatmap_TBP_MANE.pdf --plotTitle "TBP ChIPs, dTAG sorted"

plotProfile -m results/DTmatrix_TBP_MANE.gz -out plots/Profile_TBP_MANE.pdf \
--samplesLabel TBP-DMSO TBP-A485 TBP-dTAG TBP-A485-dTAG \
--regionsLabel "protein coding genes (MANE)" \
--plotTitle "TBP ChIPs" --perGroup 
