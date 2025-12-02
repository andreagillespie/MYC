#!/bin/bash
 
#SBATCH --nodes=1
#SBATCH --ntasks=1
#SBATCH --mem=24G
#SBATCH --time=0-08:00:00
#SBATCH --output=logs/deeptoolsCov%j.stdout
#SBATCH --mail-user=andrea.gillespie@petermac.org
#SBATCH --mail-type=END,TIME_LIMIT_80
#SBATCH --job-name="bigwigs"
#SBATCH --partition=prod_med

module load deeptools/3.0.0

bname=`basename $1 .merged.sort.bam`

bamCoverage --bam $1 -o bigwigs/${bname}.merged.RPGC.forward.bw --binSize 10 --normalizeUsing RPGC --effectiveGenomeSize 3297535677 --filterRNAstrand forward
bamCoverage --bam $1 -o bigwigs/${bname}.merged.RPGC.reverse.bw --binSize 10 --normalizeUsing RPGC --effectiveGenomeSize 3297535677 --filterRNAstrand reverse

bamCoverage --bam $1 -of bedgraph -o bedgraphs/${bname}.merged.RPGC.forward.bdg --binSize 10 --normalizeUsing RPGC --effectiveGenomeSize 3297535677 --filterRNAstrand forward
bamCoverage --bam $1 -of bedgraph -o bedgraphs/${bname}.merged.RPGC.reverse.bdg --binSize 10 --normalizeUsing RPGC --effectiveGenomeSize 3297535677 --filterRNAstrand reverse
