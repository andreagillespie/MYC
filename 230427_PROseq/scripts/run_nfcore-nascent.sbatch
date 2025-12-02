#!/bin/bash
 
#SBATCH --nodes=1
#SBATCH --mem 200G 
#SBATCH --cpus-per-task 20
#SBATCH --time=3-00:00:00
#SBATCH --output=logs/nf-core%j.stdout
#SBATCH --mail-user=andrea.gillespie@petermac.org
#SBATCH --mail-type=END,TIME_LIMIT_80
#SBATCH --job-name="nfcore_nascent"
#SBATCH --partition=prod

module purge
module load singularity/3.7.3
module load java/jdk-17.0.6
module load samtools/1.17

NXF_VER=23.04.1 /config/binaries/nextflow/23.04.1/nextflow run nf-core/nascent -profile singularity \
    -c /scratch/teams/dawson_genomics/Projects/MYC/230427_PROseq/scripts/nfcore_nascent.config \
    --input /scratch/teams/dawson_genomics/Projects/MYC/230427_PROseq/scripts/samplesheet.csv \
    --outdir /scratch/teams/dawson_genomics/Projects/MYC/230427_PROseq/nf-core_nascent \
    --genome GRCh38 \
    --aligner bwamem2 \
    --email andrea.gillespie@petermac.org \
    --multiqc_title nf-core_nacent_multiqc \
    --assay_type PROseq \
    --max_memory 200.GB \
    --max_cpus 20 \
    -resume

