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
bigwigs/KAT2A-DMSO-R1_S108.MACSnorm.bw bigwigs/KAT2A-A485-R1_S110.MACSnorm.bw \
bigwigs/KAT2A-dTAG-R1_S109.MACSnorm.bw bigwigs/KAT2A-dTAG-A485-R1_S111.MACSnorm.bw \
-R /data/reference/dawson_labs/bed_files/Hg38/Hg38_MANE_ProteinCoding.bed \
-a 3000 -b 3000 -m 5000 -o results/DTmatrix_KAT2A_MANE.gz

plotHeatmap -m results/DTmatrix_KAT2A_MANE.gz --sortUsingSamples 3 --sortUsing sum \
--samplesLabel KAT2A-DMSO KAT2A-A485 KAT2A-dTAG KAT2A-A485-dTAG \
--colorMap PuBuGn --regionsLabel "protein coding genes (MANE)" --zMax 3 \
-o plots/Heatmap_KAT2A_MANE.pdf --plotTitle "KAT2A ChIPs, dTAG sorted"

plotProfile -m results/DTmatrix_KAT2A_MANE.gz -out plots/Profile_KAT2A_MANE.pdf \
--samplesLabel KAT2A-DMSO KAT2A-A485 KAT2A-dTAG KAT2A-A485-dTAG \
--regionsLabel "protein coding genes (MANE)" \
--plotTitle "KAT2A ChIPs" --perGroup 
