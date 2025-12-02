#!/bin/bash
 
#SBATCH --nodes=1
#SBATCH --ntasks=1
#SBATCH --partition=prod_short
#SBATCH --mem-per-cpu=4G
#SBATCH --time=0-01:00:00
#SBATCH --output=logs/sort%j.stdout
#SBATCH --mail-user=andrea.gillespie@petermac.org
#SBATCH --mail-type=END,TIME_LIMIT_80
#SBATCH --job-name="sort"

module load samtools/1.13

bname=`basename $1 .bam`

samtools sort $1 -o nf-core_nascent/samtools/${bname}.sort.bam

samtools index nf-core_nascent/samtools/${bname}.sort.bam