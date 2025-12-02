#!/usr/bin/env bash
#

#SBATCH --nodes=1
#SBATCH --ntasks=1
#SBATCH --cpus-per-task=1
#SBATCH --mem=12G
#SBATCH --time=0-02:00:00
#SBATCH --output=logs/fastqScreen_%j.stdout
#SBATCH --mail-type=END
#SBATCH --mail-user=andrea.gillespie@petermac.org
#SBATCH --job-name="fastqScreen"
#SBATCH --partition=prod_short

module load fastq-screen/0.15.3
module load bowtie2/2.3.4.1

fastq_screen --conf /data/reference/dawson_labs/genomes/FastQ_Screen_Genomes/fastq_screen.conf --outdir fastq_screen $1
