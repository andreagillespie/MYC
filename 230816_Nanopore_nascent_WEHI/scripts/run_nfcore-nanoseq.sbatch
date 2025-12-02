#!/bin/bash
 
#SBATCH --nodes=1
#SBATCH --mem 200G 
#SBATCH --cpus-per-task 20
#SBATCH --time=3-00:00:00
#SBATCH --output=logs/nf-core%j.stdout
#SBATCH --mail-user=andrea.gillespie@petermac.org
#SBATCH --mail-type=END,TIME_LIMIT_80
#SBATCH --job-name="nfcore_nanoseq"
#SBATCH --partition=prod

module purge
module load singularity/3.7.3
module load java/jdk-17.0.6

NXF_VER=23.04.1 /config/binaries/nextflow/23.04.1/nextflow run nf-core/nanoseq \
    -profile singularity \
    -r 3.1.0 \
    --input /dawson_genomics/Projects/MYC/230816_Nanopore_nascent_WEHI/scripts/samplesheet.csv \
    --outdir /scratch/teams/dawson_genomics/Projects/MYC/230816_Nanopore_nascent_WEHI/nf-core_nanoseq \
    --protocol cDNA \
    --skip_demultiplexing \
    --quantification_method stringtie2 \
    --skip_fusion_analysis \
    --skip_modification_analysis \
    --email andrea.gillespie@petermac.org \
    -resume

