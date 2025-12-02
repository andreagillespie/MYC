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

module load deeptools/3.0.0

bamCompare -b1 $1 -b2 $2 -o bigwigs/${3}.LFC.bw --binSize 10 --scaleFactorsMethod None --normalizeUsing RPKM --effectiveGenomeSize 3297535677
