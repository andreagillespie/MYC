#!/bin/bash
 
#SBATCH --nodes=1
#SBATCH --ntasks=1
#SBATCH --partition=prod_short
#SBATCH --mem-per-cpu=4G
#SBATCH --time=0-02:00:00
#SBATCH --output=logs/filter_secondary%j.stdout
#SBATCH --mail-user=andrea.gillespie@petermac.org
#SBATCH --mail-type=END,TIME_LIMIT_80
#SBATCH --job-name="filter_secondary"

module load samtools/1.17

bname=`basename $1 .sorted.bam`

samtools view -F0x900 $1 -o bams_no_supp/${bname}.filtered.bam

samtools index bams_no_supp/${bname}.filtered.bam