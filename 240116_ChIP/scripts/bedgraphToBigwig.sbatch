#!/bin/bash
 
#SBATCH --nodes=1
#SBATCH --ntasks=1
#SBATCH --mem-per-cpu=12G
#SBATCH --time=0-20:00:00
#SBATCH --output=logs/DTBamCov%j.stdout
#SBATCH --mail-user=andrea.gillespie@petermac.org
#SBATCH --mail-type=END
#SBATCH --job-name="DTBamCov"
#SBATCH --partition=prod_med

module load ucsc-utils/20161019

bname=`basename $1 _treat_pileup.bdg`

# remove head to comply with bed format
sed -i -e '1d' $1

# sort
bedSort $1 macs/broadpeaks/${bname}_treat_pileup.sort.bdg

# convert to bw
bedGraphToBigWig macs/broadpeaks/${bname}_treat_pileup.sort.bdg /data/reference/dawson_labs/genome_size/Hg38_chrom.size bigwigs/${bname}.MACSnorm.bw
