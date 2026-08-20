#!/bin/bash
#SBATCH --job-name=GAP.%j
#SBATCH --mail-type=ALL
#SBATCH --mail-user=deamorimpeixotom@ufl.edu
#SBATCH --account=mresende
#SBATCH --qos=mresende-b
#SBATCH --nodes=1
#SBATCH --ntasks=1
#SBATCH --cpus-per-task=20
#SBATCH --mem=900GB
#SBATCH --time=96:00:00
#SBATCH --output=1.tmp/gapit.%a.array.%A.out
#SBATCH --error=2.error/gapit.%a.array.%A.err

module purge
module load R

Rscript 4.GWAS_GAPIT.R
