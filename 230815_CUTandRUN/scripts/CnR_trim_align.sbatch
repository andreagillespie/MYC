#!/bin/bash
 
#SBATCH --nodes=1
#SBATCH --ntasks=1
#SBATCH --cpus-per-task=1
#SBATCH --mem=16G
#SBATCH --partition=prod_med
#SBATCH --time=1-0:00:00
#SBATCH --output=logs/CutTag%j.stdout
#SBATCH --mail-user=andrea.gillespie@petermac.org
#SBATCH --mail-type=END,TIME_LIMIT_80
#SBATCH --job-name="CUTandRUN"

module load fastqc/0.11.6
module load bowtie2/2.3.4.1
module load trimmomatic/0.39
module load samtools/1.17
module load igvtools/2.3.95


bname=`basename $1 _R1_001.fastq.gz`

HsRef=/data/reference/dawson_labs/joint_genomes/GRCh38BDGP6/bowtie2/GRCh38BDGP6.reheaded
EcRef=/data/reference/dawson_labs/genomes/FastQ_Screen_Genomes/E_coli/Ecoli

# This first bit is adapted from the protocol from Epicypher for analysis of their spike-in, unfortunately fastq needs to be copied to a local folder and then unzipped
fname=`basename $1`
uname=`basename $1 .gz`
cp $1 temp/$fname
gunzip temp/$fname

for barcode in TTCGCGCGTAACGACGTACCGT CGCGATACGACCGCGTTACGCG CGACGTTAACGCGTTTCGTACG CGCGACTATCGCGCGTAACGCG CCGTACGTCGTGTCGAACGACG CGATACGCGTTGGTACGCGTAA TAGTTCGCGACACCGTTCGTCG TCGACGCGTAAACGGTACGTCG TTATCGCGTCGCGACGGACGTA CGATCGTACGATAGCGTACCGA CGCATATCGCGTCGTACGACCG ACGTTCGACCGCGGTCGTACGA ACGATTCGACGATCGTCGACGA CGATAGTCGCGTCGCACGATCG CGCCGATTACGTGTCGCGCGTA ATCGTACCGCGCGTATCGGTCG CGTTCGAACGTTCGTCGACGAT TCGCGATTACGATGTCGCGCGA ACGCGAATCGTCGACGCGTATA CGCGATATCACTCGACGCGATA CGCGAAATTCGTATACGCGTCG CGCGATCGGTATCGGTACGCGC GTGATATCGCGTTAACGTCGCG TATCGCGCGAAACGACCGTTCG CCGCGCGTAATGCGCGACGTTA CCGCGATACGACTCGTTCGTCG GTCGCGAACTATCGTCGATTCG CCGCGCGTATAGTCCGAGCGTA CGATACGCCGATCGATCGTCGG CCGCGCGATAAGACGCGTAACG CGATTCGACGGTCGCGACCGTA TTTCGACGCGTCGATTCGGCGA ;
do
	grep -c $barcode temp/$uname >> kmetstat_counts/${bname}_kmetstat_counts.txt
done
rm temp/$uname

fastqc -o fastqc/ -f fastq $1

# using options as in cutandruntools
java -jar /config/binaries/trimmomatic/0.39/trimmomatic-0.39.jar SE -threads 1 -phred33 $1 trimmomatic/${bname}_trim.fq.gz ILLUMINACLIP:/data/reference/dawson_labs/trimmomatic/TruSeq3-SE.fa:2:15:4:4:true LEADING:20 TRAILING:20 SLIDINGWINDOW:4:15 MINLEN:25
fastqc -o trimmomatic -f fastq trimmomatic/${bname}_trim.fq.gz

# second pass trimming also as in cutandruntools
~/cutandruntools/kseq_test trimmomatic/${bname}_trim.fq.gz 75 kseq_trim/${bname}_kseq_trim.fq.gz
fastqc -o kseq_trim -f fastq kseq_trim/${bname}_kseq_trim.fq.gz

bowtie2 --end-to-end --very-sensitive --no-unal --no-mixed --no-discordant --phred33 -I 10 -X 700 -p 1 -t -x $HsRef -U kseq_trim/${bname}_kseq_trim.fq.gz -S alignment/${bname}.sam

samtools view -b -q 10 -o alignment/${bname}.bam alignment/${bname}.sam

samtools sort -o alignment/${bname}.sort.bam alignment/${bname}.bam

samtools index alignment/${bname}.sort.bam

igvtools count alignment/${bname}.sort.bam tdfs/${bname}.tdf hg38

bowtie2 --end-to-end --very-sensitive --no-unal --no-mixed --no-discordant --phred33 -I 10 -X 700 -p 1 -t -x $EcRef -U kseq_trim/${bname}_kseq_trim.fq.gz -S alignment/${bname}.Ecoli.sam

samtools view -b -q 10 -o alignment/${bname}.Ecoli.bam alignment/${bname}.Ecoli.sam

samtools sort -o alignment/${bname}.sort.Ecoli.bam alignment/${bname}.Ecoli.bam

rm alignment/${bname}.sam
rm alignment/${bname}.bam
rm alignment/${bname}.Ecoli.sam
rm alignment/${bname}.Ecoli.bam
