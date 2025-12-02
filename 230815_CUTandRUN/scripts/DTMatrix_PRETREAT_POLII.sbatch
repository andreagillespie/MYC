#!/bin/bash
 
#SBATCH --nodes=1
#SBATCH --ntasks=1
#SBATCH --mem-per-cpu=20G
#SBATCH --time=1-0:00:00
#SBATCH --output=logs/deeptoolsMatrix%j.stdout
#SBATCH --mail-user=andrea.gillespie@petermac.org
#SBATCH --mail-type=END,TIME_LIMIT_80
#SBATCH --job-name="DTMatrix"
#SBATCH --partition=prod_med

module load deeptools/3.5.0

computeMatrix scale-regions -S \
bigwigs/PRETREAT-3NEG-POLII-R1_S38_RPGCnorm.bw bigwigs/PRETREAT-5NEG-POLII-R2_S47_RPGCnorm.bw \
bigwigs/PRETREAT-3V-POLII-R1_S42_RPGCnorm.bw bigwigs/PRETREAT-5V-POLII-R2_S51_RPGCnorm.bw \
-R /data/reference/dawson_labs/bed_files/Hg38/Hg38EnsGeneStrandPlusMinusWhitelist.bed -a 3000 -b 3000 -m 5000 -o DTmatrices/DTmatrix_PRETREAT_POLII_RPGCnorm_allGenes.gz

plotHeatmap -m DTmatrices/DTmatrix_PRETREAT_POLII_RPGCnorm_allGenes.gz --sortUsingSamples 1 --sortUsing sum \
--samplesLabel 3NEG-POLII 5NEG-POLII 3V-POLII 5V-POLII \
--colorMap YlGn --regionsLabel "all genes" \
-o plots/Heatmap_PRETREAT_POLII_RPGCnorm_allGenes.pdf --plotTitle "CUT&RUN PRETREAT POLII all genes"

