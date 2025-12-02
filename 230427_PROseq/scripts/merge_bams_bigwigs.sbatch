#!/bin/bash
 
#SBATCH --nodes=1
#SBATCH --ntasks=1
#SBATCH --mem=16G
#SBATCH --time=0-08:00:00
#SBATCH --output=logs/mergeBamCov%j.stdout
#SBATCH --mail-user=andrea.gillespie@petermac.org
#SBATCH --mail-type=END,TIME_LIMIT_80
#SBATCH --job-name="mergeBamCov"
#SBATCH --partition=prod_med

module load deeptools/3.0.0
module load samtools/1.17

bname=$4

samtools merge -o bams/${bname}.merged.bam $1 $2 $3

samtools sort bams/${bname}.merged.bam -o bams/${bname}.merged.sort.bam

samtools index bams/${bname}.merged.sort.bam

bamCoverage --bam bams/${bname}.merged.sort.bam -o bigwigs/${bname}.merged.RPGC.bw --binSize 10 --normalizeUsing RPGC --effectiveGenomeSize 3297535677 

rm bams/${bname}.merged.bam
