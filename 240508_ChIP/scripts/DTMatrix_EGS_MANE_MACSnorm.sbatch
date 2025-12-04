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
bigwigs/EGS-HA-KP_S102.MACSnorm.bw \
bigwigs/EGS-HA-B1_S103.MACSnorm.bw bigwigs/EGS-HA-B3_S104.MACSnorm.bw \
-R /data/reference/dawson_labs/bed_files/Hg38/Hg38_MANE_ProteinCoding.bed \
-a 3000 -b 3000 -m 5000 -o results/DTmatrix_EGS_MANE.gz

plotHeatmap -m results/DTmatrix_EGS_MANE.gz --sortUsingSamples 1 --sortUsing sum \
--samplesLabel EGS-HA-KP EGS-HA-B1 EGS-HA-B3 \
--colorMap gist_heat_r --regionsLabel "protein coding genes (MANE)" \
-o plots/Heatmap_EGS_MANE.pdf --plotTitle "EGS ChIPs, KP sorted"

plotProfile -m results/DTmatrix_EGS_MANE.gz -out plots/Profile_EGS_MANE.pdf \
--samplesLabel EGS-HA-KP EGS-HA-B1 EGS-HA-B3 \
--regionsLabel "protein coding genes (MANE)" \
--plotTitle "EGS ChIPs" --perGroup 
