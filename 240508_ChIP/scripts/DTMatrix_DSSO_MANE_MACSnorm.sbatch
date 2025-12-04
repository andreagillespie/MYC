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
bigwigs/DSSO-HA-KP_S98.MACSnorm.bw \
bigwigs/DSSO-HA-B1_S99.MACSnorm.bw bigwigs/DSSO-HA-B3_S100.MACSnorm.bw \
-R /data/reference/dawson_labs/bed_files/Hg38/Hg38_MANE_ProteinCoding.bed \
-a 3000 -b 3000 -m 5000 -o results/DTmatrix_DSSO_MANE.gz

plotHeatmap -m results/DTmatrix_DSSO_MANE.gz --sortUsingSamples 1 --sortUsing sum \
--samplesLabel DSSO-HA-KP DSSO-HA-B1 DSSO-HA-B3 \
--colorMap copper_r --regionsLabel "protein coding genes (MANE)" \
-o plots/Heatmap_DSSO_MANE.pdf --plotTitle "DSSO ChIPs, KP sorted"

plotProfile -m results/DTmatrix_DSSO_MANE.gz -out plots/Profile_DSSO_MANE.pdf \
--samplesLabel DSSO-HA-KP DSSO-HA-B1 DSSO-HA-B3 \
--regionsLabel "protein coding genes (MANE)" \
--plotTitle "DSSO ChIPs" --perGroup 
