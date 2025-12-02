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
bigwigs/PRETREAT-NEG-POLII.MACSnorm.bw bigwigs/PRETREAT-V-POLII.MACSnorm.bw \
-R ../230427_PROseq/bed_files/CGI_promoter_distanceOrder_CGIendCentered.bed -a 1000 -b 1000 -o DTmatrices/DTmatrix_PRETREAT_POLII_MACSnorm_CGIprom.gz

plotHeatmap -m DTmatrices/DTmatrix_PRETREAT_POLII_MACSnorm_CGIprom.gz \
--samplesLabel NEG-POLII V-POLII --zMax 0.4 \
--colorMap YlGn --sortRegion keep -o plots/Heatmap_PRETREAT_POLII_MACSnorm_CGIprom.pdf \
--plotTitle "CUT&RUN PRETREAT POLII, CGIs overlapping w/promoters of active genes"

plotProfile -m DTmatrices/DTmatrix_PRETREAT_POLII_MACSnorm_CGIprom.gz -out plots/Profile_PRETREAT_POLII_MACSnorm_CGIprom.pdf \
--samplesLabel NEG-POLII V-POLII --plotTitle "CUT&RUN PRETREAT POLII \nCGIs overlapping w/promoters of active genes" --perGroup
