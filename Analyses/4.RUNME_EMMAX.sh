#!/bin/bash
#SBATCH --job-name=array.%j
#SBATCH --mail-type=END
#SBATCH --mail-user=deamorimpeixotom@ufl.edu
#SBATCH --ntasks=1
#SBATCH --cpus-per-task=1
#SBATCH --nodes=1
#SBATCH --mem=1GB
#SBATCH --qos=mresende-b
#SBATCH --account=mresende
#SBATCH -t 1:00:00
#SBATCH --output=1.gwas/gwas.%a.%A.out
#SBATCH --error=2.error/Gwas.%a.array.%A.err
#SBATCH --array=1-1

mkdir EMMAX

	for trait in {1..26}
	do
		sbatch 1.GWAS2.sh ${trait}
	done

