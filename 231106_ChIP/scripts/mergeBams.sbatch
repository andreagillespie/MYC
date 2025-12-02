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

module load samtools/1.17

# merge bams
samtools merge -o $1 $2 $3

