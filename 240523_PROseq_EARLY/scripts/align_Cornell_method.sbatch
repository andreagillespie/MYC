#!/usr/bin/env bash

#SBATCH --nodes=1
#SBATCH --mem=48G
#SBATCH --time=0-16:00:00
#SBATCH --output=logs/bowtie2_%j.stdout
#SBATCH --mail-type=END,TIME_LIMIT_80
#SBATCH --mail-user=andrea.gillespie@petermac.org
#SBATCH --job-name="bowtie2_align"
#SBATCH --partition=prod_med

module load fastqc/0.11.6
module load fastq-screen/0.15.3
module load fastp/0.23.4
module load bowtie2/2.3.4.1
module load samtools/1.13
module load igvtools/2.3.95
module load picard/2.6.0
module load htseq/0.11.2

bname=`basename $1 _R1_001.fastq.gz`

Ref=/data/reference/dawson_labs/genomes/Hg38/Homo_sapiens.GRCh38.dna.toplevel.fa

# fastqc pre- and post-trimming
fastqc -o fastqc/ -f fastq $1 $2

# check for contamination
fastq_screen --conf /data/reference/dawson_labs/genomes/FastQ_Screen_Genomes/fastq_screen.conf --outdir fastq_screen $1

fastp -i $1 -I $2 --adapter_fasta ~/adapters.fa --umi --umi_loc=read1 --umi_len=6 --html fastp/${bname}_fastp.html --json fastp/${bname}_fastp.json -o fastp/${bname}_R1.trim.fq.gz -O fastp/${bname}_R2.trim.fq.gz

fastqc -o fastp/ -f fastq fastp/${bname}_R1.trim.fq.gz fastp/${bname}_R2.trim.fq.gz

# Cornell used --fast-local, but this has a known issue which was fixed in v2.3.4.2; 
# however the latest version on the cluster is v2.3.4.1
# so just running with --local for now which should be a stricter alignment anyway
bowtie2 --local -x $Ref -1 fastp/${bname}_R1.trim.fq.gz -2 fastp/${bname}_R2.trim.fq.gz -S bams/${bname}.sam

samtools view -b -q 10 -o bams/${bname}.bam bams/${bname}.sam

samtools sort bams/${bname}.bam -o bams/${bname}.sort.bam

java -Xmx8g -jar /config/binaries/picard/2.23.8/picard.jar MarkDuplicates I=bams/${bname}.sort.bam O=bams/${bname}.dedup.bam M=bams/${bname}.dedup.txt REMOVE_DUPLICATES=true

samtools sort -o bams/${bname}.sort.dedup.bam bams/${bname}.dedup.bam

samtools index bams/${bname}.sort.dedup.bam

igvtools count bams/${bname}.sort.dedup.bam tdfs/${bname}.sort.dedup.tdf hg38

htseq-count -f bam -r pos -s no -t gene bams/${bname}.sort.dedup.bam /data/reference/dawson_labs/genomes/Hg38/Homo_sapiens.GRCh38.102.gtf > counts/${bname}.count

# remove intermediate files
rm bams/${bname}.sam
rm bams/${bname}.bam
rm bams/${bname}.dedup.bam
