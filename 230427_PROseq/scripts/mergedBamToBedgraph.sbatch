#!/bin/bash
 
#SBATCH --nodes=1
#SBATCH --cpus-per-task=2
#SBATCH --mem=16G
#SBATCH --time=0-08:00:00
#SBATCH --output=logs/deeptoolsCov%j.stdout
#SBATCH --mail-user=andrea.gillespie@petermac.org
#SBATCH --mail-type=END,TIME_LIMIT_80
#SBATCH --job-name="bigwigs"
#SBATCH --partition=prod_med

module load deeptools/3.5.0

bname=`basename $1 .merged.sort.bam`

# make RPGC norm bedgraphs w/ binsize 1
bamCoverage --bam $1 -of bedgraph -o bedgraphs/${bname}.merged.RPGC.forward.bdg --binSize 1 --normalizeUsing RPGC --effectiveGenomeSize 3297535677 --filterRNAstrand forward
bamCoverage --bam $1 -of bedgraph -o bedgraphs/${bname}.merged.RPGC.reverse.bdg --binSize 1 --normalizeUsing RPGC --effectiveGenomeSize 3297535677 --filterRNAstrand reverse

# make reverse strand bdg w/negative values
awk '{print $1,$2,$3,$4*-1}' OFS='\t' bedgraphs/${bname}.merged.RPGC.reverse.bdg > bedgraphs/${bname}.merged.RPGC.reverse.neg.bdg

# same for spike in norm
bamCoverage --bam $1 -of bedgraph -o bedgraphs/${bname}.merged.spikein.forward.bdg --binSize 1 --scaleFactor $2 --filterRNAstrand forward
bamCoverage --bam $1 -of bedgraph -o bedgraphs/${bname}.merged.spikein.reverse.bdg --binSize 1 --scaleFactor $2 --filterRNAstrand reverse

# make reverse strand bdg w/negative values
awk '{print $1,$2,$3,$4*-1}' OFS='\t' bedgraphs/${bname}.merged.spikein.reverse.bdg > bedgraphs/${bname}.merged.spikein.reverse.neg.bdg

