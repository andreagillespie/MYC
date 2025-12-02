#!/usr/bin/env bash
#

#SBATCH --nodes=1
#SBATCH --cpus-per-task=4
#SBATCH --mem=8G
#SBATCH --time=0-08:00:00
#SBATCH --output=logs/rmats_%j.stdout
#SBATCH --mail-type=END,TIME_LIMIT_80
#SBATCH --mail-user=andrea.gillespie@petermac.org
#SBATCH --job-name="rmats"
#SBATCH --partition=prod_med

# load necessary version of miniconda
module load miniconda3/23.5.2

# activate conda env
conda activate /home/agillespie/rmats_turbo_v4_3_0/conda_envs/test_rmats

# only accepts 2 samples, so just run dTAG samples together here
~/rmats_turbo_v4_3_0/run_rmats \
--b1 /dawson_genomics/Projects/MYC/230420_TTseq/scripts/dP_rmats.txt \
--b2 /dawson_genomics/Projects/MYC/230420_TTseq/scripts/dD_rmats.txt \
--gtf /data/reference/dawson_labs/genomes/Hg38/Homo_sapiens.GRCh38.102.gtf \
-t paired --readLength 150 --nthread 4 --od rmats/dP_dD --tmp rmats/dP_dD/temp --novelSS

