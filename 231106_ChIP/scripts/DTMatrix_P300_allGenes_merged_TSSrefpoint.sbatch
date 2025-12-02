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

computeMatrix reference-point --referencePoint center -S \
bigwigs/untreated.RPGC.bw bigwigs/A485.RPGC.bw \
bigwigs/dTAG.RPGC.bw bigwigs/dTAG-and-A485.RPGC.bw \
-R /dawson_genomics/Projects/MYC/annotations/mane.expressed.prot.coding.genes.hg38.bed \
-a 3000 -b 3000 -o results/DTmatrix_RPGCnorm_allGenes_TSSrefpoint.gz

plotHeatmap -m results/DTmatrix_RPGCnorm_allGenes_TSSrefpoint.gz --sortUsingSamples 3 --sortUsing sum \
--samplesLabel untreated A485 dTAG dTAG-and-A485 \
--colorMap BuPu \
-o plots/Heatmap_RPGCnorm_allGenes_TSSrefpoint.pdf --plotTitle "P300 ChIP, TSS centered"

plotProfile -m results/DTmatrix_RPGCnorm_allGenes_TSSrefpoint.gz -out plots/Profile_RPGCnorm_allGenes_TSSrefpoint.pdf \
--samplesLabel untreated A485 dTAG dTAG-and-A485 \
--plotTitle "P300 ChIP, TSS centered" --perGroup
