#!/usr/bin/env bash
#

#SBATCH --nodes=1
#SBATCH --ntasks=1
#SBATCH --cpus-per-task=4
#SBATCH --mem=12G
#SBATCH --time=1-00:00:00
#SBATCH --output=logs/star_%j.stdout
#SBATCH --mail-type=END,TIME_LIMIT_80
#SBATCH --mail-user=andrea.gillespie@petermac.org
#SBATCH --job-name="star_align"
#SBATCH --partition=prod_med

module load htseq/0.11.2

bname=`basename $1 .merged.bam`

htseq-count -f bam -r pos -s no -t gene $1 /data/reference/dawson_labs/genomes/BDGP6/Drosophila_melanogaster.BDGP6.32.109.reheaded.gtf > Dm_counts/${bname}.Dm.count

