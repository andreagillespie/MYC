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
bigwigs/EARLY-3ND-H3K27ac-R1.TMMnorm.bw bigwigs/EARLY-3NP-H3K27ac-R1.TMMnorm.bw \
bigwigs/EARLY-3dD-H3K27ac-R1.TMMnorm.bw bigwigs/EARLY-3dP-H3K27ac-R1.TMMnorm.bw \
-R /data/reference/dawson_labs/bed_files/Hg38/Hg38EnsGeneStrandPlusMinusWhitelist.bed -a 3000 -b 3000 -m 5000 -o DTmatrices/DTmatrix_EARLY_H3K27ac_TMMnorm_allGenes.gz

plotHeatmap -m DTmatrices/DTmatrix_EARLY_H3K27ac_TMMnorm_allGenes.gz --sortUsingSamples 1 --sortUsing sum \
--samplesLabel 3ND-H3K27ac 3NP-H3K27ac 3dD-H3K27ac 3dP-H3K27ac \
--colorMap YlOrBr --regionsLabel "all genes" \
-o plots/Heatmap_EARLY_H3K27ac_TMMnorm_allGenes.pdf --plotTitle "CUT&RUN EARLY H3K27ac all genes"

plotProfile -m DTmatrices/DTmatrix_EARLY_H3K27ac_TMMnorm_allGenes.gz -out plots/Profile_EARLY_H3K27ac_TMMnorm_allGenes.pdf \
--samplesLabel 3ND-H3K27ac 3NP-H3K27ac 3dD-H3K27ac 3dP-H3K27ac --plotTitle "CUT&RUN EARLY H3K27ac all genes" --perGroup
