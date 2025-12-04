#!/bin/bash
 
#SBATCH --nodes=1
#SBATCH --ntasks=1
#SBATCH --mem-per-cpu=12G
#SBATCH --time=0-04:00:00
#SBATCH --output=logs/deeptoolsMatrix%j.stdout
#SBATCH --mail-user=andrea.gillespie@petermac.org
#SBATCH --mail-type=END,TIME_LIMIT_80
#SBATCH --job-name="DTMatrix"
#SBATCH --partition=prod_med

module load deeptools/3.5.0

computeMatrix scale-regions -S \
bigwigs/H2BK16ac-DMSO-R1_S196_Dmnorm.bw bigwigs/H2BK16ac-A485-R1_S197_Dmnorm.bw \
bigwigs/H2BK16ac-dTAG-R1_S198_Dmnorm.bw bigwigs/H2BK16ac-A485-dTAG-R1_S199_Dmnorm.bw \
-R /dawson_genomics/Projects/MYC/230420_TTseq/bed_files/reactivated_genes.bed \
/dawson_genomics/Projects/MYC/230420_TTseq/bed_files/nonreactivated_genes.bed \
-a 3000 -b 3000 -m 5000 -o results/DTmatrix_Dmnorm_2genelists_H2BK16ac.gz

plotHeatmap -m results/DTmatrix_Dmnorm_2genelists_H2BK16ac.gz --sortUsingSamples 3 --sortUsing sum \
--samplesLabel H2BK16ac-DMSO H2BK16ac-A485 H2BK16ac-dTAG H2BK16ac-dTAG-A485 \
--colorMap BuPu --regionsLabel "reactivating" "non-reactivating" \
-o plots/Heatmap_Dmnorm_2genelists_H2BK16ac.pdf --plotTitle "H2BK16ac ChIP spike-in norm, dTAG sorted"

plotProfile -m results/DTmatrix_Dmnorm_2genelists_H2BK16ac.gz -out plots/Profile_Dmnorm_2genelists_H2BK16ac.pdf \
--samplesLabel H2BK16ac-DMSO H2BK16ac-A485 H2BK16ac-dTAG H2BK16ac-dTAG-A485 \
--plotTitle "H2BK16ac ChIP spike-in norm" --perGroup
