#!/bin/bash
 
#SBATCH --nodes=1
#SBATCH --ntasks=1
#SBATCH --mem-per-cpu=20G
#SBATCH --time=0-2:00:00
#SBATCH --output=logs/deeptoolsMatrix%j.stdout
#SBATCH --mail-user=andrea.gillespie@petermac.org
#SBATCH --mail-type=END,TIME_LIMIT_80
#SBATCH --job-name="DTMatrix"
#SBATCH --partition=prod_short

module load deeptools/3.5.0

computeMatrix reference-point --referencePoint center -S \
bigwigs/3ND_R1_RPGCnorm.bw bigwigs/4ND_R1_RPGCnorm.bw \
bigwigs/3NP_R1_RPGCnorm.bw bigwigs/4NP_R1_RPGCnorm.bw \
bigwigs/3dD_R1_RPGCnorm.bw bigwigs/4dD_R1_RPGCnorm.bw \
bigwigs/3dP_R1_RPGCnorm.bw bigwigs/4dP_R1_RPGCnorm.bw \
-R /dawson_genomics/Projects/MYC/230420_TTseq/bed_files/K562_ENCODE_sedb_01_0039.bed -a 3000 -b 3000 -o results/DTmatrix_RPGCnorm_SE_refPoint.gz

plotHeatmap -m results/DTmatrix_RPGCnorm_SE_refPoint.gz --sortUsingSamples 1 --sortUsing sum \
--samplesLabel R1-untreated R2-untreated R1-A485 R2-A485 R1-dTAG R2-dTAG R1-dTAG-and-A485 R2-dTAG-and-A485 \
--colorMap copper --regionsLabel "superenhancers" \
-o plots/Heatmap_RPGCnorm_superEnhancers.pdf --plotTitle "ATACseq at superenhancers"

plotProfile -m results/DTmatrix_RPGCnorm_SE_refPoint.gz -out plots/Profile_RPGCnorm_superEnhancers.pdf \
--samplesLabel R1-untreated R2-untreated R1-A485 R2-A485 R1-dTAG R2-dTAG R1-dTAG-and-A485 R2-dTAG-and-A485 \
--plotTitle "ATACseq at superenhancers" --perGroup
