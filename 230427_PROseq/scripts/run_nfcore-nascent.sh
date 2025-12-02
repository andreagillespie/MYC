#!/bin/bash

module purge
module load singularity/3.7.3
module load java/jdk-17.0.6
module load samtools/1.13

NXF_VER=23.04.1 /config/binaries/nextflow/23.04.1/nextflow run nf-core/nascent -profile singularity \
    --input /scratch/teams/dawson_genomics/Projects/MYC/230427_PROseq/scripts/samplesheet.csv \
    --outdir /scratch/teams/dawson_genomics/Projects/MYC/230427_PROseq/nf-core_nascent \
    --genome GRCh38 \
    --aligner bwamem2 \
    --email andrea.gillespie@petermac.org \
    --multiqc_title nf-core_nacent_multiqc \
    --assay_type PROseq \
    --with_umi \
    --umitools_dedup_stats \
    -resume

