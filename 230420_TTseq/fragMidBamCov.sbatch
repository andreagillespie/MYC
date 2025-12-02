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

module purge
module load deeptools/3.5.0

bname=`basename $1 .merged.bam`

# make 50bp bin size w/fragment midpoint settings for elong velocity analysis
bamCoverage --bam $1 -o bigwigs/${bname}.merged.RPGC.bs50.fragMid.bw --binSize 50 \
  --normalizeUsing RPGC --effectiveGenomeSize 3297535677 -e --centerReads
