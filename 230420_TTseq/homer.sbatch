#!/usr/bin/env bash
#

#SBATCH --nodes=1
#SBATCH --ntasks=1
#SBATCH --cpus-per-task=2
#SBATCH --mem=32G
#SBATCH --time=1-00:00:00
#SBATCH --output=logs/homer_%j.stdout
#SBATCH --mail-type=END,TIME_LIMIT_80
#SBATCH --mail-user=andrea.gillespie@petermac.org
#SBATCH --job-name="homer"
#SBATCH --partition=prod_med

module load homer/4.11

findMotifs.pl results/reactivated_genelist.txt human /dawson_genomics/Projects/MYC/230420_TTseq/homer/ -p 2
