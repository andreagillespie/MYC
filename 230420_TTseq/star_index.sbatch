#!/bin/bash
 
#SBATCH --nodes=1
#SBATCH --ntasks=1
#SBATCH --cpus-per-task=20
#SBATCH --mem=40G
#SBATCH --time=1-12:00:00
#SBATCH --output=logs/starIndex_%j.stdout
#SBATCH --mail-type=END,TIME_LIMIT_80
#SBATCH --mail-user=andrea.gillespie@petermac.org
#SBATCH --job-name="star_index"
#SBATCH --partition=prod

module load star/2.7.5b

STAR --runMode genomeGenerate --genomeDir /data/reference/dawson_labs/joint_genomes/Hg38Dm3/STAR --runThreadN 20 \
--genomeFastaFiles /data/reference/dawson_labs/joint_genomes/Hg38Dm3/Hg38Dm3.dna.toplevel.fa