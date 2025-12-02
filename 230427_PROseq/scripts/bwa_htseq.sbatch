#!/usr/bin/env bash
#

#SBATCH --nodes=1
#SBATCH --cpus-per-task=2
#SBATCH --mem=16G
#SBATCH --time=1-00:00:00
#SBATCH --output=logs/htseq_%j.stdout
#SBATCH --mail-type=END,TIME_LIMIT_80
#SBATCH --mail-user=andrea.gillespie@petermac.org
#SBATCH --job-name="htseq"
#SBATCH --partition=prod_med

module load htseq/0.11.2

bname=`basename $1 _T1.bam`

htseq-count -f bam -r pos -s reverse -t gene $1 /data/reference/dawson_labs/genomes/GRCh38/GCA_000001405.15_GRCh38_full_analysis_set.refseq_annotation.gtf > bwa_counts/${bname}.count

