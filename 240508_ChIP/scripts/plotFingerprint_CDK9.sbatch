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
alignment/CDK9-DMSO-R1_S90.sort.rmdup.bam alignment/CDK9-A485-R1_S92.sort.rmdup.bam \
alignment/CDK9-dTAG-R1_S91.sort.rmdup.bam alignment/CDK9-dTAG-A485-R1_S93.sort.rmdup.bam \
-o plots/fingerprint_CDK9.pdf -l TF-input CDK9-DMSO CDK9-A485 CDK9-dTAG CDK9-A485-dTAG 
