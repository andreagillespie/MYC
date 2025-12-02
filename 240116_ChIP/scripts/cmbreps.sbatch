#!/bin/bash
 
#SBATCH --nodes=1
#SBATCH --ntasks=1
#SBATCH --mem-per-cpu=12G
#SBATCH --time=0-2:00:00
#SBATCH --output=logs/MACS%j.stdout
#SBATCH --mail-user=andrea.gillespie@petermac.org
#SBATCH --mail-type=END
#SBATCH --job-name="MACS"
#SBATCH --partition=prod_short

module load macs/2.2.7.1

dname=macs/broadpeaks

# narrow peaks calling with bedgraph outputs
macs2 cmbreps -i ${dname}/$1 ${dname}/$2 ${dname}/$3 -m mean -o ${dname}/$4
