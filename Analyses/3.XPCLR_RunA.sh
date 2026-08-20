#!/bin/bash
#SBATCH --job-name=xpclr%j
#SBATCH --ntasks=1
#SBATCH --cpus-per-task=1
#SBATCH --nodes=1
#SBATCH --mem=4GB
#SBATCH --qos=mresende
#SBATCH --account=mresende
#SBATCH -t 1:00:00
#SBATCH --output=9.tmp/3.jobs/2.byPop.xpclr.1.sh.%x.%a.%A.out
#SBATCH --array=1-1

while IFS= read -r bcf
do
  OUT=$(basename $bcf .bcf)
  mkdir output/starchtime

  cat lists/new_pop_key_starch.csv | sed "s/\"//g" | while IFS=$'\t' read -r pop1 pop2 ; do
    name1=$(echo $pop1 | sed 's/ /_/g')
    name2=$(echo $pop2 | sed 's/ /_/g')
    echo "Runing $name1 vs. $name2"
    mkdir output/starchtime/${name1}.${name2}	

    sbatch 4.byPop.xpclr.2.sh $bcf $name1 $name2  
  done	
done < "key.trial4.txt"

78