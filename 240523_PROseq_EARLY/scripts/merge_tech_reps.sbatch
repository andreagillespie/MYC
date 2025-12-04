#!/usr/bin/env bash

#SBATCH --nodes=1
#SBATCH --mem=12G
#SBATCH --time=0-04:00:00
#SBATCH --output=logs/merge_TR_%j.stdout
#SBATCH --mail-type=END,TIME_LIMIT_80
#SBATCH --mail-user=andrea.gillespie@petermac.org
#SBATCH --job-name="merge_TR"
#SBATCH --partition=prod_med

module load samtools/1.13

bname=`basename $1 .sort.dedup.bam`

# merge w/ tech reps from prev sequencing run
samtools merge -r -o bams/${bname}.techmerged.bam $1 ../240228_PROseq_EARLY/bams/${bname}.sort.dedup.bam

# sort by name for fixmate
samtools sort -n bams/${bname}.techmerged.bam -o bams/${bname}.techmerged.namesort.bam

# run fixmate to tag matescore for dedup
samtools fixmate -m bams/${bname}.techmerged.namesort.bam bams/${bname}.techmerged.fixmate.bam

# coord sort for mark dup input
samtools sort bams/${bname}.techmerged.fixmate.bam -o bams/${bname}.techmerged.sort.bam

# remove duplicates
samtools markdup -r -S -s -f bams/${bname}.techmerged.dedup.txt -c \
bams/${bname}.techmerged.sort.bam bams/${bname}.techmerged.dedup.bam

samtools sort -o bams/${bname}.techmerged.sort.dedup.bam bams/${bname}.techmerged.dedup.bam

samtools index bams/${bname}.techmerged.sort.dedup.bam

# remove intermediate files
rm bams/${bname}.techmerged.bam
rm bams/${bname}.techmerged.namesort.bam
rm bams/${bname}.techmerged.sort.bam
rm bams/${bname}.techmerged.fixmate.bam
rm bams/${bname}.techmerged.dedup.bam

