#!/bin/bash
 
#SBATCH --nodes=1
#SBATCH --ntasks=1
#SBATCH --mem-per-cpu=8G
#SBATCH --time=0-2:00:00
#SBATCH --output=logs/DTBamCov%j.stdout
#SBATCH --mail-user=andrea.gillespie@petermac.org
#SBATCH --mail-type=END
#SBATCH --job-name="DTBamCov"
#SBATCH --partition=prod_short

module load deeptools/3.5.0
module load samtools/1.17

bname=`basename $1 .bam`

# ban needs to be indexed first
samtools index $1

# use RPCG norm
bamCoverage --bam $1 -o bigwigs/${bname}_RPGCnorm.bw --binSize 20 --normalizeUsing RPGC --effectiveGenomeSize 2736124973

