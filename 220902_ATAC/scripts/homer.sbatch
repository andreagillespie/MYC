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

bname=`basename $1 _c3.0_cond1.bed`
#bname=`basename $1 _c3.0_cond2.bed`
dname=/dawson_genomics/Projects/MYC/220902_ATAC/homer/

findMotifsGenome.pl $1 hg38 ${dname}/${bname}_cond1 -p 2 -preparsedDir homer/presparsed
#findMotifsGenome.pl $1 hg38 ${dname}/${bname}_cond2 -p 2 -preparsedDir homer/presparsed
