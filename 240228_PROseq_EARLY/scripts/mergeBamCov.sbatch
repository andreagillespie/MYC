#!/bin/bash
 
#SBATCH --nodes=1
#SBATCH --cpus-per-task=2
#SBATCH --mem=16G
#SBATCH --time=0-08:00:00
#SBATCH --output=logs/deeptoolsCov%j.stdout
#SBATCH --mail-user=andrea.gillespie@petermac.org
#SBATCH --mail-type=END,TIME_LIMIT_80
#SBATCH --job-name="bigwigs"
#SBATCH --partition=prod_med

module load samtools/1.17
module load deeptools/3.5.0

samtools merge -o bams/$3.merged.bam $1 $2 

samtools sort -o bams/$3.merged.sort.bam bams/$3.merged.bam

samtools index bams/$3.merged.sort.bam

bamCoverage --bam bams/$3.merged.sort.bam -o bigwigs/$3.merged.RPGC.bw --binSize 10 --normalizeUsing RPGC --effectiveGenomeSize 3297535677

rm bams/$3.merged.bam
