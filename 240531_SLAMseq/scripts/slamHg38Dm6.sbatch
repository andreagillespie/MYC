#!/bin/bash

#SBATCH --nodes=1
#SBATCH --cpus-per-task=4
#SBATCH --mem=24G
#SBATCH --time=1-00:00:00
#SBATCH --output=logs/slam%j.stdout
#SBATCH --mail-user=andrea.gillespie@petermac.org
#SBATCH --mail-type=END
#SBATCH --job-name="slamdunk"
#SBATCH --partition=prod_med

module load slamdunk/0.2.4
module load fastqc/0.11.6
module load trimgalore/0.4.4
module load fastq-screen/0.15.3

bname=`basename $1 _R1_001.fastq.gz`
rl=100
Ref=/data/reference/dawson_labs/joint_genomes/GRCh38BDGP6/GRCh38BDGP6.reheaded.fa
utr=/data/reference/dawson_labs/joint_genomes/GRCh38BDGP6/GRCh38BDGP6_3utr.bed

mkdir slamdunk/${bname}

#fastq_screen --conf /data/reference/dawson_labs/genomes/FastQ_Screen_Genomes/fastq_screen.conf --threads 8 --outdir fastq_screen $1

#fastqc -o fastqc/ -t 4 $1

#trim_galore --fastqc -o trimmed_fastqs $1

slamdunk all -r $Ref -b $utr -fb $utr -o slamdunk/${bname} -5 12 -n 100 -t 4 -m -mv 0.2 -mbq 27 -rl $rl trimmed_fastqs/${bname}_R1_001_trimmed.fq.gz

alleyoop collapse -o slamdunk/collapse/ -t 4 slamdunk/${bname}/count/*tcount.tsv &

alleyoop snpeval -o slamdunk/${bname}/ -s slamdunk/${bname}/snp/ -r $Ref -b $utr -l $rl -t 4 slamdunk/${bname}/filter/*_slamdunk_mapped_filtered.bam &
alleyoop rates -o slamdunk/${bname}/ -r $Ref -t 4 slamdunk/${bname}/filter/*_slamdunk_mapped_filtered.bam &
alleyoop tccontext -o slamdunk/${bname}/ -r $Ref -t 4 slamdunk/${bname}/filter/*_slamdunk_mapped_filtered.bam &
alleyoop tcperutrpos -o slamdunk/${bname}/ -r $Ref -b $utr -s slamdunk/${bname}/snp/ -l $rl -t 4 slamdunk/${bname}/filter/*_slamdunk_mapped_filtered.bam &
alleyoop tcperreadpos -o slamdunk/${bname}/ -r $Ref -s slamdunk/${bname}/snp/ -l $rl -t 4 slamdunk/${bname}/filter/*_slamdunk_mapped_filtered.bam &
alleyoop utrrates -o slamdunk/${bname}/ -r $Ref -l $rl -t 4 -b $utr slamdunk/${bname}/filter/*_slamdunk_mapped_filtered.bam &

wait
