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
bigwigs/R1-bulk-DMSO_S9.MACSnorm.bw bigwigs/R2-bulk-DMSO_S13.MACSnorm.bw bigwigs/R3-bulk-DMSO_S17.MACSnorm.bw \
bigwigs/R1-bulk-A485_S10.MACSnorm.bw bigwigs/R2-bulk-A485_S14.MACSnorm.bw bigwigs/R3-bulk-A485_S1.MACSnorm.bw \
bigwigs/R1-bulk-A485-dTAG_S4.MACSnorm.bw bigwigs/R2-bulk-A485-dTAG_S5.MACSnorm.bw bigwigs/R3-bulk-A485-dTAG_S6.MACSnorm.bw \
bigwigs/R1-neg-reactivation_S11.MACSnorm.bw bigwigs/R2-neg-reactivation_S15.MACSnorm.bw bigwigs/R3-neg-reactivation_S2.MACSnorm.bw \
bigwigs/R1-pos-reactivation_S12.MACSnorm.bw bigwigs/R2-pos-reactivation_S16.MACSnorm.bw bigwigs/R3-pos-reactivation_S3.MACSnorm.bw \
-R /data/reference/dawson_labs/bed_files/Hg38/Hg38EnsGeneStrandPlusMinusWhitelist.bed -a 3000 -b 3000 -m 5000 -o results/DTmatrix_MACSnorm_allGenes_PolII.gz

plotHeatmap -m results/DTmatrix_MACSnorm_allGenes_PolII.gz --sortUsingSamples 1 --sortUsing sum \
--samplesLabel R1-bulk-DMSO R2-bulk-DMSO R3-bulk-DMSO R1-bulk-A485 R2-bulk-A485 R3-bulk-A485 R1-bulk-A485-dTAG R2-bulk-A485-dTAG R3-bulk-A485-dTAG \
R1-neg-reactivation R2-neg-reactivation R3-neg-reactivation R1-pos-reactivation R2-pos-reactivation R3-pos-reactivation \
--colorMap YlGn --regionsLabel "all genes" \
-o plots/Heatmap_MACSnorm_allGenes_PolII.pdf --plotTitle "PolII ChIP all genes"

plotProfile -m results/DTmatrix_MACSnorm_allGenes_PolII.gz -out plots/Profile_MACSnorm_allGenes_PolII.pdf \
--samplesLabel R1-bulk-DMSO R2-bulk-DMSO R3-bulk-DMSO R1-bulk-A485 R2-bulk-A485 R3-bulk-A485 R1-bulk-A485-dTAG R2-bulk-A485-dTAG R3-bulk-A485-dTAG \
R1-neg-reactivation R2-neg-reactivation R3-neg-reactivation R1-pos-reactivation R2-pos-reactivation R3-pos-reactivation \
--plotTitle "PolII ChIP all genes" --perGroup
