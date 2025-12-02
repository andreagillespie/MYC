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
bigwigs/PRETREAT-NEG-POLII.MACSnorm.bw bigwigs/PRETREAT-V-POLII.MACSnorm.bw \
-R /data/reference/dawson_labs/bed_files/Hg38/Hg38EnsGeneStrandPlusMinusWhitelist.bed -a 3000 -b 3000 -m 5000 -o DTmatrices/DTmatrix_PRETREAT_POLII_MACSnorm_allGenes.gz

plotHeatmap -m DTmatrices/DTmatrix_PRETREAT_POLII_MACSnorm_allGenes.gz --sortUsingSamples 1 --sortUsing sum \
--samplesLabel NEG-POLII V-POLII \
--colorMap YlGn --regionsLabel "all genes" \
-o plots/Heatmap_PRETREAT_POLII_MACSnorm_allGenes.pdf --plotTitle "CUT&RUN PRETREAT POLII all genes"

plotProfile -m DTmatrices/DTmatrix_PRETREAT_POLII_MACSnorm_allGenes.gz -out plots/Profile_PRETREAT_POLII_MACSnorm_allGenes.pdf \
--samplesLabel NEG-POLII V-POLII --plotTitle "CUT&RUN PRETREAT POLII all genes" --perGroup
