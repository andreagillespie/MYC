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

computeMatrix reference-point --referencePoint center -S \
bigwigs/PRETREAT-NEG-H3K27ac.MACSnorm.bw bigwigs/PRETREAT-V-H3K27ac.MACSnorm.bw \
-R /dawson_genomics/Projects/MYC/230420_TTseq/bed_files/K562_ENCODE_sedb_01_0039.bed -a 3000 -b 3000 -o DTmatrices/DTmatrix_PRETREAT_H3K27ac_MACSnorm_SE.gz

plotHeatmap -m DTmatrices/DTmatrix_PRETREAT_H3K27ac_MACSnorm_SE.gz --sortUsingSamples 1 --sortUsing sum \
--samplesLabel NEG-H3K27ac V-H3K27ac \
--colorMap YlOrBr --regionsLabel "superenhancers" \
-o plots/Heatmap_PRETREAT_H3K27ac_MACSnorm_superenhancers.pdf --plotTitle "CUT&RUN PRETREAT H3K27ac superenhancers"

plotProfile -m DTmatrices/DTmatrix_PRETREAT_H3K27ac_MACSnorm_SE.gz -out plots/Profile_PRETREAT_H3K27ac_MACSnorm_superenhancers.pdf \
--samplesLabel NEG-H3K27ac V-H3K27ac --plotTitle "CUT&RUN PRETREAT H3K27ac superenhancers" --perGroup
