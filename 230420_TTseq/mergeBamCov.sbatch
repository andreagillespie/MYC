#!/bin/bash
 
#SBATCH --nodes=1
#SBATCH --cpus-per-task=1
#SBATCH --mem=16G
#SBATCH --time=0-08:00:00
#SBATCH --output=logs/deeptoolsCov%j.stdout
#SBATCH --mail-user=andrea.gillespie@petermac.org
#SBATCH --mail-type=END,TIME_LIMIT_80
#SBATCH --job-name="bigwigs"
#SBATCH --partition=prod_med

module load samtools/1.17
module load deeptools/3.5.0

#samtools merge -o bams/${5}.merged.bam $1 $2 $3 $4

#samtools index bams/${5}.merged.bam

#bamCoverage --bam bams/${5}.merged.bam -o bigwigs/${5}.merged.RPGC.bw \
#  --binSize 10 --normalizeUsing RPGC --effectiveGenomeSize 3297535677

#bamCoverage --bam bams/${5}.merged.bam -o bigwigs/${5}.merged.spikein.bw \
#  --binSize 10 --scaleFactor $6

# also make larger bin size versions for reactivated genes plots
#bamCoverage --bam bams/${5}.merged.bam -o bigwigs/${5}.merged.RPGC.bs50.bw \
#  --binSize 50 --normalizeUsing RPGC --effectiveGenomeSize 3297535677

#bamCoverage --bam bams/${5}.merged.bam -o bigwigs/${5}.merged.spikein.bs50.bw \
#  --binSize 50 --scaleFactor $6

bamCoverage --bam bams/${5}.merged.bam -o bigwigs/${5}.merged.RPGC.bs100.bw \
  --binSize 100 --normalizeUsing RPGC --effectiveGenomeSize 3297535677

bamCoverage --bam bams/${5}.merged.bam -o bigwigs/${5}.merged.spikein.bs100.bw \
  --binSize 100 --scaleFactor $6
