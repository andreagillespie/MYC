#!/bin/bash
 
#SBATCH --nodes=1
#SBATCH --ntasks=1
#SBATCH --mem-per-cpu=32G
#SBATCH --time=0-10:00:00
#SBATCH --output=logs/deeptoolsMatrix%j.stdout
#SBATCH --mail-user=andrea.gillespie@petermac.org
#SBATCH --mail-type=END,TIME_LIMIT_80
#SBATCH --job-name="DTMatrix"
#SBATCH --partition=prod_med

module load deeptools/3.5.0

computeMatrix scale-regions -S \
bigwigs/H3K4me1-DMSO-R1_S200.MACSnorm.bw bigwigs/H3K4me1-A485-R1_S201.MACSnorm.bw \
bigwigs/H3K4me1-dTAG-R1_S202.MACSnorm.bw bigwigs/H3K4me1-A485-dTAG-R1_S203.MACSnorm.bw \
-R /data/reference/dawson_labs/bed_files/Hg38/Hg38_MANE_ProteinCoding.bed \
-a 3000 -b 3000 -m 5000 -o results/DTmatrix_H3K4me1_MANE.gz

plotHeatmap -m results/DTmatrix_H3K4me1_MANE.gz --sortUsingSamples 3 --sortUsing sum \
--samplesLabel H3K4me1-DMSO H3K4me1-A485 H3K4me1-dTAG H3K4me1-A485-dTAG \
--colorMap RdPu --regionsLabel "protein coding genes (MANE)" \
-o plots/Heatmap_H3K4me1_MANE.pdf --plotTitle "H3K4me1 ChIPs, dTAG sorted"

plotProfile -m results/DTmatrix_H3K4me1_MANE.gz -out plots/Profile_H3K4me1_MANE.pdf \
--samplesLabel H3K4me1-DMSO H3K4me1-A485 H3K4me1-dTAG H3K4me1-A485-dTAG \
--regionsLabel "protein coding genes (MANE)" \
--plotTitle "H3K4me1 ChIPs" --perGroup 
