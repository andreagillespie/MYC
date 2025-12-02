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
bigwigs/untreated.MACSnorm.bw bigwigs/A485.MACSnorm.bw \
bigwigs/dTAG.MACSnorm.bw bigwigs/dTAG-and-A485.MACSnorm.bw \
bigwigs/K562_MED1_Hg38_merged_HAIB_RPGCnorm.bw bigwigs/K562_BRD4_Hg38_merged_Broad_RPGCnorm.bw \
bigwigs/K562_H3K27ac_Hg38_3bioRep_2techRep_merged_Broad_RPGCnorm.bw \
../230427_PROseq/bigwigs/ND_LATE.merged.RPGC.bw ../230427_PROseq/bigwigs/NP_LATE.merged.RPGC.bw \
../230427_PROseq/bigwigs/dD_LATE.merged.RPGC.bw ../230427_PROseq/bigwigs/dP_LATE.merged.RPGC.bw \
-R bed_files/dD.v.ND.sig.intervals.UP.bed bed_files/dD.v.ND.sig.intervals.DN.bed \
bed_files/K562_proximal_SE_Hg38.bed bed_files/K562_distal_SE_Hg38.bed \
/data/reference/dawson_labs/bed_files/Hg38/Hg38_MANE_ProteinCoding_TSS.bed \
bed_files/K562_proximal_TE_Hg38.bed bed_files/K562_distal_TE_Hg38.bed \
-a 3000 -b 3000 -o results/DTmatrix_P300_ENCODE_PROseq_7lists_merged.gz

plotHeatmap -m results/DTmatrix_P300_ENCODE_PROseq_7lists_merged.gz --sortUsingSamples 3 --sortUsing sum \
--samplesLabel untreated A485 dTAG dTAG-and-A485 MED1 BRD4 H3K27ac PROseq_ND PROseq_NP PROseq_dD PROseq_dP \
--colorMap BuPu BuPu BuPu BuPu Reds Greens Oranges magma_r magma_r magma_r magma_r \
--regionsLabel "ATAC up" "ATAC down" "proximal SE" "distal SE" "TSS" "proximal TE" "distal TE" --zMax 12 \
-o plots/Heatmap_P300_ENCODE_PROseq_7lists_merged.pdf --plotTitle "P300 & ENCODE ChIPs & PROseq, dTAG sorted"

plotProfile -m results/DTmatrix_P300_ENCODE_PROseq_7lists_merged.gz -out plots/Profile_P300_ENCODE_PROseq_7lists_merged.pdf \
--samplesLabel untreated A485 dTAG dTAG-and-A485 MED1 BRD4 H3K27ac PROseq_ND PROseq_NP PROseq_dD PROseq_dP \
--regionsLabel "ATAC up" "ATAC down" "proximal SE" "distal SE" "TSS" "proximal TE" "distal TE" \
--plotTitle "P300 & ENCODE ChIPs & PROseq" --perGroup --legendLocation lower-left
