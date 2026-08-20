#!/bin/bash
#SBATCH --job-name=emmax.%j
#SBATCH --mail-type=NONE
#SBATCH --mail-user=deamorimpeixotom@ufl.edu
#SBATCH --ntasks=1
#SBATCH --cpus-per-task=4
#SBATCH --nodes=1
#SBATCH --mem=256GB
#SBATCH --qos=mresende-b
#SBATCH --account=mresende
#SBATCH -t 12:00:00
#SBATCH --output=1.gwas/gwas.%a.%A.out
#SBATCH --error=2.error/Gwas.%a.array.%A.err

module load emmax

# assign variables

geno_db="Ia453_sweetcap_v0.4_16M"
kin_db="Ia453_sweetcap_v0.4_16M.BN.kinf"
pheno_db="EMMAX/PhenoValuesBLUES"
trait_db="EMMAX/TraitNames_BLUEs"

trait_id=${1}
trait_name=$(sed -n ${trait_id}p ${trait_db})

# make results folder
mkdir EMMAX/${trait_name}

# get pheno file
tail -n +2 ${pheno_db} | cut -f1,2,$(($trait_id + 2)) > EMMAX/${trait_name}/${trait_name}.tsv

# run association
emmax -v -d 10 \
      -t vcfs/${geno_db} \
      -p EMMAX/${trait_name}/${trait_name}.tsv \
      -k vcfs/${kin_db} \
      -c EMMAX/emmax_cov_3COV3PC.tsv \
      -o EMMAX/${trait_name}/${trait_name}

