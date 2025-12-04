#!/bin/bash
 
#SBATCH --partition=prod_med
#SBATCH --nodes=1
#SBATCH --cpus-per-task=2
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

Reference=/data/reference/dawson_labs/genomes/Hg38/Homo_sapiens.GRCh38.dna.toplevel.fa

fastqc -o fastqc/ -f fastq $1

trim_galore --fastqc -o trimmed_fastqs $1

bowtie2 --sensitive-local --no-unal --no-mixed --no-discordant --phred33 -I 10 -X 700 -p 2 -t -x $Reference \
-U trimmed_fastqs/${bname}_R1_001_trimmed.fq.gz -S alignment/${bname}.sam

samtools view -b -L /data/reference/dawson_labs/whitelists/Hg38WhitelistV2nochr.bed -q 10 -o alignment/${bname}.bam alignment/${bname}.sam

samtools sort -o alignment/${bname}.sort.bam alignment/${bname}.bam

MarkDuplicates.sh I=alignment/${bname}.sort.bam O=alignment/${bname}.sort.rmdup.bam M=alignment/${bname}.txt REMOVE_DUPLICATES=true VALIDATION_STRINGENCY=SILENT

samtools index alignment/${bname}.sort.rmdup.bam

igvtools count alignment/${bname}.sort.rmdup.bam tdfs/${bname}.tdf hg38

# remove intermediate files 
rm alignment/${bname}.sam
rm alignment/${bname}.bam

# align & process spike-in reads
DmRef=/data/reference/dawson_labs/genomes/FastQ_Screen_Genomes/Drosophila/BDGP6

bowtie2 --sensitive-local --no-unal --no-mixed --no-discordant --phred33 -I 10 -X 700 -p 2 -t -x $DmRef \
-U trimmed_fastqs/${bname}_R1_001_trimmed.fq.gz -S alignment/${bname}_Dm.sam

samtools view -b -q 10 -o alignment/${bname}_Dm.bam alignment/${bname}_Dm.sam

samtools sort -o alignment/${bname}_Dm.sort.bam alignment/${bname}_Dm.bam

MarkDuplicates.sh I=alignment/${bname}_Dm.sort.bam O=alignment/${bname}_Dm.sort.rmdup.bam M=alignment/${bname}_Dm.txt REMOVE_DUPLICATES=true VALIDATION_STRINGENCY=SILENT

# remove intermediate files 
rm alignment/${bname}_Dm.sam
rm alignment/${bname}_Dm.bam
