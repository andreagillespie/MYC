#!/bin/bash
 
#SBATCH --nodes=1
#SBATCH --ntasks=1
#SBATCH --mem-per-cpu=10G
#SBATCH --time=0-2:00:00
#SBATCH --output=logs/MACS%j.stdout
#SBATCH --mail-type=END
#SBATCH --mail-user=andrea.gillespie@petermac.org
#SBATCH --job-name="CnR_MACS"
#SBATCH --partition=prod_short

module load macs/2.1.1

bname=`basename $1 .sort.bam`

macs2 callpeak -t $1 -g hs -n $bname --outdir macs/narrowpeaks -q 0.05 -B --SPMR --keep-dup all 

macs2 callpeak -t $1 -g hs -n $bname --broad --outdir macs/broadpeaks -q 0.05 -B --SPMR --keep-dup all


