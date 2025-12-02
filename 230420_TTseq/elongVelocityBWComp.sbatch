#!/bin/bash
 
#SBATCH --nodes=1
#SBATCH --cpus-per-task=2
#SBATCH --mem=24G
#SBATCH --time=0-08:00:00
#SBATCH --output=logs/deeptoolsCov%j.stdout
#SBATCH --mail-user=andrea.gillespie@petermac.org
#SBATCH --mail-type=END,TIME_LIMIT_80
#SBATCH --job-name="bwCompare"
#SBATCH --partition=prod_med

module purge
module load deeptools/3.5.0

# run from TTseq dir
# get LFC of TTseq/PROseq for each condition
bigwigCompare -b1 bigwigs/${1} -b2 /dawson_genomics/Projects/MYC/230427_PROseq/bigwigs/${2} \
  -bs 50 --operation log2 -o bwCompare/TTseq_PROseq_${3}_LATE_LFC.bw -p 2




