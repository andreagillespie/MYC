#!/usr/bin/env bash
#

#SBATCH --nodes=1
#SBATCH --ntasks=1
#SBATCH --cpus-per-task=4
#SBATCH --mem=12G
#SBATCH --time=1-00:00:00
#SBATCH --output=logs/star_%j.stdout
#SBATCH --mail-type=END,TIME_LIMIT_80
#SBATCH --mail-user=andrea.gillespie@petermac.org
#SBATCH --job-name="star_align"
#SBATCH --partition=prod_med

module load star/2.7.5b
module load samtools/1.13
module load trimgalore/0.4.4
module load igvtools/2.3.95
module load picard/2.6.0
module load htseq/0.11.2

bname=`basename $1 _L002_R1_001.fastq.gz`

# lanes need to be concatenated first
cat $1 $3 > cat_fastq/${bname}_R1.fastq.gz
cat $2 $4 > cat_fastq/${bname}_R2.fastq.gz

trim_galore --fastqc --paired -o trimmed_fastqs cat_fastq/${bname}_R1.fastq.gz cat_fastq/${bname}_R2.fastq.gz

STAR --runThreadN 4 --genomeDir /data/reference/dawson_labs/joint_genomes/GRCh38BDGP6/STAR \
--readFilesIn trimmed_fastqs/${bname}_R1_val_1.fq.gz trimmed_fastqs/${bname}_R2_val_2.fq.gz --readFilesCommand zcat \
--outSAMtype BAM Unsorted --outFilterMultimapNmax 1 --outFilterMismatchNmax 3 --outFileNamePrefix ./bams/${bname}_

samtools sort bams/${bname}_Aligned.out.bam -o bams/${bname}.sort.bam

samtools index bams/${bname}.sort.bam

java -Xmx8g -jar /config/binaries/picard/2.23.8/picard.jar MarkDuplicates I=bams/${bname}.sort.bam O=bams/${bname}.dedup.bam M=bams/${bname}.dedup.txt REMOVE_DUPLICATES=true

samtools sort -o bams/${bname}.sort.dedup.bam bams/${bname}.dedup.bam

samtools index bams/${bname}.sort.dedup.bam

igvtools count bams/${bname}.sort.dedup.bam tdfs/${bname}.sort.dedup.tdf hg38

htseq-count -f bam -r pos -s no -t gene bams/${bname}.sort.dedup.bam /data/reference/dawson_labs/genomes/Hg38/Homo_sapiens.GRCh38.102.gtf > counts/${bname}.count

htseq-count -f bam -r pos -s no -t gene bams/${bname}.sort.dedup.bam /data/reference/dawson_labs/genomes/BDGP6/Drosophila_melanogaster.BDGP6.32.109.reheaded.gtf > Dm_counts/${bname}.Dm.count

# remove intermediate files
rm bams/${bname}_Aligned.out.bam
rm bams/${bname}.dedup.bam

