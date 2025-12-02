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

bname=`basename $1 .merged.sort.bam`

bamCoverage --bam $1 -o bigwigs/${bname}.merged.spikein.bw --binSize 10 --scaleFactor $2
