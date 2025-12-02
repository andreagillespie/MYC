#!/usr/bin/env bash

#SBATCH --nodes=1
#SBATCH --mem=32G
#SBATCH --time=0-16:00:00
#SBATCH --output=logs/bowtie2_%j.stdout
#SBATCH --mail-type=END,TIME_LIMIT_80
#SBATCH --mail-user=andrea.gillespie@petermac.org
#SBATCH --job-name="bowtie2_align"
#SBATCH --partition=prod_med

module load fastp/0.23.4
module load bowtie2/2.3.4.1
module load samtools/1.13
module load trimgalore/0.4.4
module load igvtools/2.3.95
module load picard/2.6.0
module load htseq/0.11.2

# use fastp trimmed fastqs (as done in Cornell pipeline) from nf-core output 
bname=`basename $1 _comb.fastq.gz`

HsRef=/data/reference/dawson_labs/genomes/Hg38/Homo_sapiens.GRCh38.dna.toplevel.fa
DmRef=/data/reference/dawson_labs/genomes/FastQ_Screen_Genomes/Drosophila/BDGP6

#fastp -i $1 --adapter_fasta ~/adapters.fa --umi --umi_loc=read1 --umi_len=6 --html fastp/${bname}_fastp.html -w 8 -o fastp/${bname}.trim.fq.gz

# Cornell used --fast-local, but this has a known issue which was fixed in v2.3.4.2; however the latest version on the cluster is v2.3.4.1
# so just running with --local for now which should be a stricted alignment anyway
#bowtie2 --local -x $HsRef -U fastp/${bname}.trim.fq.gz -S bams/${bname}.sam

#samtools view -b -q 10 -o bams/${bname}.bam bams/${bname}.sam

#samtools sort bams/${bname}.bam -o bams/${bname}.sort.bam

#java -Xmx8g -jar /config/binaries/picard/2.23.8/picard.jar MarkDuplicates I=bams/${bname}.sort.bam O=bams/${bname}.dedup.bam M=bams/${bname}.dedup.txt REMOVE_DUPLICATES=true

#samtools sort -o bams/${bname}.sort.dedup.bam bams/${bname}.dedup.bam

#samtools index bams/${bname}.sort.dedup.bam

#igvtools count bams/${bname}.sort.dedup.bam tdfs/${bname}.sort.dedup.tdf hg38

#htseq-count -f bam -r pos -s no -t gene bams/${bname}.sort.dedup.bam /data/reference/dawson_labs/genomes/Hg38/Homo_sapiens.GRCh38.102.gtf > counts/${bname}.count

# same for spikein
bowtie2 --local -x $DmRef -U fastp/${bname}.trim.fq.gz -S bams/${bname}.Dm.sam

samtools view -b -o bams/${bname}.Dm.bam bams/${bname}.Dm.sam

samtools sort bams/${bname}.Dm.bam -o bams/${bname}.sort.Dm.bam

java -Xmx8g -jar /config/binaries/picard/2.23.8/picard.jar MarkDuplicates I=bams/${bname}.sort.Dm.bam O=bams/${bname}.dedup.Dm.bam M=bams/${bname}.dedup.Dm.txt REMOVE_DUPLICATES=true

samtools sort -o bams/${bname}.sort.dedup.Dm.bam bams/${bname}.dedup.Dm.bam

#htseq-count -f bam -r pos -s no -t gene bams/${bname}.sort.dedup.Dm.bam /data/reference/dawson_labs/genomes/BDGP6/Drosophila_melanogaster.BDGP6.32.109.gtf > Dm_counts/${bname}.Dm.count

# remove intermediate files
#rm bams/${bname}.sam
#rm bams/${bname}.bam
#rm bams/${bname}.dedup.bam
rm bams/${bname}.Dm.sam
rm bams/${bname}.Dm.bam
rm bams/${bname}.dedup.Dm.bam
