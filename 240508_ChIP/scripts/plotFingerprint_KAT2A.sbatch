#!/bin/bash
 
#SBATCH --nodes=1
#SBATCH --ntasks=1
#SBATCH --mem-per-cpu=2G
#SBATCH --time=0-04:00:00
#SBATCH --output=logs/deeptoolsMatrix%j.stdout
#SBATCH --mail-user=andrea.gillespie@petermac.org
#SBATCH --mail-type=END,TIME_LIMIT_80
#SBATCH --job-name="DTMatrix"
#SBATCH --partition=prod_med

module load deeptools/3.5.0

plotFingerprint -b \
alignment/TF-ChIP-input_S94.sort.rmdup.bam \
alignment/KAT2A-DMSO-R1_S108.sort.rmdup.bam alignment/KAT2A-A485-R1_S110.sort.rmdup.bam \
alignment/KAT2A-dTAG-R1_S109.sort.rmdup.bam alignment/KAT2A-dTAG-A485-R1_S111.sort.rmdup.bam \
-o plots/fingerprint_KAT2A.pdf -l TF-input KAT2A-DMSO KAT2A-A485 KAT2A-dTAG KAT2A-A485-dTAG 
