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
bigwigs/JUN-DMSO-R1_S97.RPGC.bw bigwigs/JUN-A485-R1_S106.RPGC.bw \
bigwigs/JUN-dTAG-R1_S105.RPGC.bw bigwigs/JUN-dTAG-A485-R1_S107.RPGC.bw \
-R /dawson_genomics/Projects/MYC/annotations/mane.expressed.prot.coding.genes.hg38.bed \
-a 3000 -b 3000 -m 5000 -o results/DTmatrix_JUN_MANE_RPGCnorm.gz

plotHeatmap -m results/DTmatrix_JUN_MANE_RPGCnorm.gz --sortUsingSamples 3 --sortUsing sum \
--samplesLabel JUN-DMSO JUN-A485 JUN-dTAG JUN-A485-dTAG \
--colorMap YlOrBr --regionsLabel "protein coding genes (MANE)" \
-o plots/Heatmap_JUN_MANE_RPGCnorm.pdf --plotTitle "JUN ChIPs, dTAG sorted"

plotProfile -m results/DTmatrix_JUN_MANE_RPGCnorm.gz -out plots/Profile_JUN_MANE_RPGCnorm.pdf \
--samplesLabel JUN-DMSO JUN-A485 JUN-dTAG JUN-A485-dTAG \
--regionsLabel "protein coding genes (MANE)" \
--plotTitle "JUN ChIPs" --perGroup 
