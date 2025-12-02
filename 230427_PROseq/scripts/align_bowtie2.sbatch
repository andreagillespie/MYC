#!/usr/bin/env bash
#

#SBATCH --nodes=1
#SBATCH --cpus-per-task=8
#SBATCH --mem=16G
#SBATCH --time=1-00:00:00
#SBATCH --output=logs/bowtie2_%j.stdout
#SBATCH --mail-type=END,TIME_LIMIT_80
#SBATCH --mail-user=andrea.gillespie@petermac.org
#SBATCH --job-name="bowtie2_align"
#SBATCH --partition=prod_med

module load bowtie2/2.3.4.1
module load samtools/1.13
module load trimgalore/0.4.4
module load igvtools/2.3.95
module load picard/2.6.0
module load htseq/0.11.2

bname=`basename $1 _comb.fastq.gz`

trim_galore --fastqc -o trimmed_comb_fastq $1

bowtie2 --end-to-end --very-sensitive --no-unal --phred33 -I 10 -p 8 -x /data/reference/dawson_labs/joint_genomes/GRCh38BDGP6/bowtie2/GRCh38BDGP6.reheaded \
-U trimmed_comb_fastq/${bname}_comb_trimmed.fq.gz -S bams/${bname}.sam

samtools view -b -q 10 -o bams/${bname}.bam bams/${bname}.sam

samtools sort bams/${bname}.bam -o bams/${bname}.sort.bam

java -Xmx8g -jar /config/binaries/picard/2.23.8/picard.jar MarkDuplicates I=bams/${bname}.sort.bam O=bams/${bname}.dedup.bam M=bams/${bname}.dedup.txt REMOVE_DUPLICATES=true

samtools sort -o bams/${bname}.sort.dedup.bam bams/${bname}.dedup.bam

samtools index bams/${bname}.sort.dedup.bam

igvtools count bams/${bname}.sort.dedup.bam tdfs/${bname}.sort.dedup.tdf hg38

htseq-count -f bam -r pos -s no -t gene bams/${bname}.sort.dedup.bam /data/reference/dawson_labs/genomes/Hg38/Homo_sapiens.GRCh38.102.gtf > counts/${bname}.count

htseq-count -f bam -r pos -s no -t gene bams/${bname}.sort.dedup.bam /data/reference/dawson_labs/genomes/BDGP6/Drosophila_melanogaster.BDGP6.32.109.reheaded.gtf > Dm_counts/${bname}.Dm.count

# remove intermediate files
rm bams/${bname}.sam
rm bams/${bname}.bam
rm bams/${bname}.dedup.bam

