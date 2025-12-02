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

computeMatrix scale-regions -S \
bigwigs/H2BK20ac-DMSO.MACSnorm.bw bigwigs/H2BK20ac-A485.MACSnorm.bw \
bigwigs/H2BK20ac-dTAG.MACSnorm.bw bigwigs/H2BK20ac-A485-dTAG.MACSnorm.bw \
-R /data/reference/dawson_labs/bed_files/Hg38/Hg38_MANE_ProteinCoding.bed \
-a 3000 -b 3000 -m 5000 -o results/DTmatrix_H2BK20ac_MANE_merged.gz

plotHeatmap -m results/DTmatrix_H2BK20ac_MANE_merged.gz --sortUsingSamples 3 --sortUsing sum \
--samplesLabel H2BK20ac-DMSO H2BK20ac-A485 H2BK20ac-dTAG H2BK20ac-A485-dTAG \
--colorMap Blues Blues Blues Blues Oranges Oranges Oranges Oranges \
--regionsLabel "protein coding genes (MANE)" \
-o plots/Heatmap_H2BK20ac_MANE_merged.pdf --plotTitle "H2BK20ac ChIPs, dTAG sorted"

plotProfile -m results/DTmatrix_H2BK20ac_MANE_merged.gz -out plots/Profile_H2BK20ac_MANE_merged.pdf \
--samplesLabel H2BK20ac-DMSO H2BK20ac-A485 H2BK20ac-dTAG H2BK20ac-A485-dTAG \
--regionsLabel "protein coding genes (MANE)" \
--plotTitle "H2BK20ac ChIPs" --perGroup
