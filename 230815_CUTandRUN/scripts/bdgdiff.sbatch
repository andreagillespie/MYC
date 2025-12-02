#!/bin/bash
 
#SBATCH --nodes=1
#SBATCH --ntasks=1
#SBATCH --mem-per-cpu=10G
#SBATCH --time=0-2:00:00
#SBATCH --output=../../logs/bdgdiff%j.stdout
#SBATCH --mail-user=andrea.gillespie@petermac.org
#SBATCH --mail-type=END
#SBATCH --job-name="bdgdiff"
#SBATCH --partition=prod_short

module load macs/2.1.1

macs2 bdgdiff --t1 $1 --c1 $2 --t2 $3 --c2 $4 --o-prefix $5 --outdir bdgdiff
