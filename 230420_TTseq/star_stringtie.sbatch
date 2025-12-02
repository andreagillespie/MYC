#!/usr/bin/env bash
#

#SBATCH --nodes=1
#SBATCH --ntasks=1
#SBATCH --cpus-per-task=8
#SBATCH --mem=40G
#SBATCH --time=0-12:00:00
#SBATCH --output=logs/star_%j.stdout
#SBATCH --mail-type=END,TIME_LIMIT_80
#SBATCH --mail-user=andrea.gillespie@petermac.org
#SBATCH --job-name="star_align"
#SBATCH --partition=prod_med

module load trimgalore/0.4.4
module load star/2.7.5b
module load samtools/1.13
module load picard/2.6.0
module load stringtie/2.2.1

bname=`basename $1 _L002_R1_001.fastq.gz`

STAR --runThreadN 8 --genomeDir /data/reference/dawson_labs/joint_genomes/GRCh38BDGP6/STAR \
--readFilesIn trimmed_fastqs/${bname}_R1_val_1.fq.gz trimmed_fastqs/${bname}_R2_val_2.fq.gz --readFilesCommand zcat \
--outSAMstrandField intronMotif --outSAMtype BAM Unsorted --outFilterMultimapNmax 1 --outFilterMismatchNmax 3 --outFileNamePrefix bams/${bname}_

samtools sort bams/${bname}_Aligned.out.bam -o bams/${bname}.sort.bam

samtools index bams/${bname}.sort.bam

java -Xmx8g -jar /config/binaries/picard/2.23.8/picard.jar MarkDuplicates I=bams/${bname}.sort.bam O=bams/${bname}.dedup.bam M=bams/${bname}.dedup.txt REMOVE_DUPLICATES=true

samtools sort -o bams/${bname}.sort.dedup.bam bams/${bname}.dedup.bam

samtools index bams/${bname}.sort.dedup.bam

stringtie -o stringtie/${bname}_quant.gtf -G /data/reference/dawson_labs/genomes/Hg38/Homo_sapiens.GRCh38.102.gtf bams/${bname}.sort.dedup.bam

# remove intermediate files
rm bams/${bname}_Aligned.out.bam
rm bams/${bname}.dedup.bam
