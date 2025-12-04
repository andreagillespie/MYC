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
bigwigs/CDK9-DMSO-R1_S90.MACSnorm.bw bigwigs/CDK9-A485-R1_S92.MACSnorm.bw \
bigwigs/CDK9-dTAG-R1_S91.MACSnorm.bw bigwigs/CDK9-dTAG-A485-R1_S93.MACSnorm.bw \
-R /data/reference/dawson_labs/bed_files/Hg38/Hg38_MANE_ProteinCoding.bed \
-a 3000 -b 3000 -m 5000 -o results/DTmatrix_CDK9_MANE.gz

plotHeatmap -m results/DTmatrix_CDK9_MANE.gz --sortUsingSamples 3 --sortUsing sum \
--samplesLabel CDK9-DMSO CDK9-A485 CDK9-dTAG CDK9-A485-dTAG \
--colorMap bone_r --regionsLabel "protein coding genes (MANE)" --zMax 4 \
-o plots/Heatmap_CDK9_MANE.pdf --plotTitle "CDK9 ChIPs, dTAG sorted"

plotProfile -m results/DTmatrix_CDK9_MANE.gz -out plots/Profile_CDK9_MANE.pdf \
--samplesLabel CDK9-DMSO CDK9-A485 CDK9-dTAG CDK9-A485-dTAG \
--regionsLabel "protein coding genes (MANE)" \
--plotTitle "CDK9 ChIPs" --perGroup 
