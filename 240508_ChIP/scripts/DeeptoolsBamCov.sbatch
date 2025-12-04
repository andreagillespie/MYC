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

module load deeptools/3.0.0

bname=`basename $1 .sort.rmdup.bam`

# for Dm library size normalisation
#bamCoverage --bam $1 -o bigwigs/${bname}_Dmnorm.bw --binSize 20 --scaleFactor $2

# RPGC norm
bamCoverage --bam $1 -o bigwigs/${bname}.RPGC.bw --binSize 10 --normalizeUsing RPGC --effectiveGenomeSize 3297535677

