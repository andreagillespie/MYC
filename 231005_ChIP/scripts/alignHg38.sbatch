#!/bin/bash
 
#SBATCH --partition=prod_med
#SBATCH --nodes=1
#SBATCH --cpus-per-task=8
#SBATCH --mem=32G
#SBATCH --time=0-16:00:00
#SBATCH --output=logs/trimalign%j.stdout
#SBATCH --mail-user=andrea.gillespie@petermac.org
#SBATCH --mail-type=END,TIME_LIMIT_80,FAIL
#SBATCH --job-name="trimalign"

module purge

module load fastqc/0.11.6
module load bowtie2/2.3.4.1
module load trimgalore/0.4.4
module load picard/2.6.0
module load samtools/1.9
module load igvtools/2.3.95

bname=`basename $1 _R1_001.fastq.gz`

Reference=/data/reference/dawson_labs/genomes/GRCh38/GCA_000001405.15_GRCh38_full_analysis_set.fna.bowtie_index

#fastqc -o fastqc/ -f fastq $1 $2

#trim_galore --fastqc --paired -o trimmed_fastqs $1 $2

bowtie2 --sensitive-local --no-unal --no-mixed --no-discordant --phred33 -I 10 -X 700 -p 8 -t -x $Reference \
-1 trimmed_fastqs/${bname}_R1_001_val_1.fq.gz -2 trimmed_fastqs/${bname}_R2_001_val_2.fq.gz -S alignment/${bname}.sam

samtools view -b -L /data/reference/dawson_labs/whitelists/Hg38WhitelistV2.bed -q 10 -o alignment/${bname}.bam alignment/${bname}.sam

samtools sort -o alignment/${bname}.sort.bam alignment/${bname}.bam

MarkDuplicates.sh I=alignment/${bname}.sort.bam O=alignment/${bname}.sort.rmdup.bam M=alignment/${bname}.txt REMOVE_DUPLICATES=true VALIDATION_STRINGENCY=SILENT

samtools index alignment/${bname}.sort.rmdup.bam

igvtools count alignment/${bname}.sort.rmdup.bam tdfs/${bname}.tdf hg38

# remove intermediate files 
rm alignment/${bname}.sam
rm alignment/${bname}.bam

