#!/bin/bash
#SBATCH --job-name=xpclr.%j
#SBATCH --ntasks=1
#SBATCH --cpus-per-task=4
#SBATCH --nodes=1
#SBATCH --mem=32GB
#SBATCH --qos=mresende
#SBATCH --account=mresende
#SBATCH -t 295:59:00
#SBATCH --partition=hpg-milan
#SBATCH --output=9.tmp/3.jobs/xpclr.%x.%A.%a.out
#SBATCH --array=4

module load bcftools
module load htslib
module load xpclr/1.1.1


BCF=$1
rPop=$2
qPop=$3

chr=${SLURM_ARRAY_TASK_ID}
OUT=$(basename $BCF .bcf)

vcf="vcfs/${OUT}.vcf.gz"

sampleA="lists/${rPop}.txt"
sampleB="lists/${qPop}.txt"

xpclr --out ./output/starchtime/${rPop}.${qPop}/${OUT}_Chr${chr}_${rPop}.${qPop}.maxsnp1000 --format vcf --input ${vcf} \
      --samplesA ${sampleA} --samplesB ${sampleB} \
      --minsnps 100 --maxsnps 1000 --size 100000 --step 10000 --rrate 1e-8 --chr Chr${chr}


