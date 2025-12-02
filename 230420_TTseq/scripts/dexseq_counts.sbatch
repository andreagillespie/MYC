#!/usr/bin/env bash
#

#SBATCH --nodes=1
#SBATCH --cpus-per-task=1
#SBATCH --mem=20G
#SBATCH --time=1-00:00:00
#SBATCH --output=logs/DEXSeq_counts%j.stdout
#SBATCH --mail-type=END,TIME_LIMIT_80
#SBATCH --mail-user=andrea.gillespie@petermac.org
#SBATCH --job-name="DEXSeq_counts"
#SBATCH --partition=prod_med

module load htseq/0.11.2
module load pysam/0.15.2

bname=`basename $1 .sort.dedup.bam`

python /config/binaries/R/4.2.0/R_libraries/DEXSeq/python_scripts/dexseq_count.py -f bam -p yes -r pos \
/data/reference/dawson_labs/genomes/Hg38/Homo_sapiens.GRCh38.102.DEXSeq.gff $1 dexseq_counts/${bname}.DEXSeqCounts.txt