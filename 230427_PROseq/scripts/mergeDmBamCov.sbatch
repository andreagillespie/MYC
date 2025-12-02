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

samtools merge -o bams/$3.merged.Dm.bam $1 $2 

samtools sort -o bams/$3.merged.sort.Dm.bam bams/$3.merged.Dm.bam

rm bams/$3.merged.Dm.bam
