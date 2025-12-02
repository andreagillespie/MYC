#!/bin/bash
 
#SBATCH --nodes=1
#SBATCH --cpus-per-task=2
#SBATCH --mem=24G
#SBATCH --time=0-08:00:00
#SBATCH --output=logs/deeptoolsCov%j.stdout
#SBATCH --mail-user=andrea.gillespie@petermac.org
#SBATCH --mail-type=END,TIME_LIMIT_80
#SBATCH --job-name="bigwigs"
#SBATCH --partition=prod_med

module load samtools/1.17
module load deeptools/3.5.0

samtools merge -o bams/${4}.merged.bam $1 $2 $3

samtools index bams/${4}.merged.bam

bamCoverage --bam bams/${4}.merged.bam -o bigwigs/${4}.merged.RPGC.bw --binSize 10 --normalizeUsing RPGC --effectiveGenomeSize 3297535677

