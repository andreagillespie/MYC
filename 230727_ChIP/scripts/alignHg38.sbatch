#!/bin/bash
 
#SBATCH --nodes=1
#SBATCH --ntasks=1
#SBATCH --partition=prod_med
#SBATCH --cpus-per-task=1
#SBATCH --mem=12G
#SBATCH --time=0-08:00:00
#SBATCH --output=logs/trimalign%j.stdout
#SBATCH --mail-user=andrea.gillespie@petermac.org
#SBATCH --mail-type=END,TIME_LIMIT_80
#SBATCH --job-name="trimalign"

module load fastqc/0.11.6
module load bowtie2/2.3.4.1
module load trimgalore/0.4.4
module load picard/2.6.0
module load samtools/1.9
module load igvtools/2.3.95

bname=`basename $1 _R1_001.fastq.gz`

Reference=/data/reference/dawson_labs/genomes/GRCh38/GCA_000001405.15_GRCh38_full_analysis_set.fna.bowtie_index

fastqc -o fastqc/ -f fastq $1

trim_galore --fastqc -o trimmed_fastqs $1

bowtie2 --end-to-end --very-sensitive --no-unal --no-mixed --no-discordant --phred33 -I 10 -X 700 -p 8 -t -x $Reference \
-U trimmed_fastqs/${bname}_R1_001_trimmed.fq.gz -S alignment/${bname}.sam

samtools view -b -L /data/reference/dawson_labs/whitelists/Hg38WhitelistV2.bed -q 10 -o alignment/${bname}.bam alignment/${bname}.sam

samtools sort -o alignment/${bname}.sort.bam alignment/${bname}.bam

MarkDuplicates.sh I=alignment/${bname}.sort.bam O=alignment/${bname}.sort.rmdup.bam M=alignment/${bname}.txt REMOVE_DUPLICATES=true VALIDATION_STRINGENCY=SILENT

samtools index alignment/${bname}.sort.rmdup.bam

igvtools count alignment/${bname}.sort.rmdup.bam tdfs/${bname}.tdf hg38

# remove intermediate files 
rm alignment/${bname}.sam
rm alignment/${bname}.bam
