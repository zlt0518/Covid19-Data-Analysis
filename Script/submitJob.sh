#! /bin/bash
#files="./executionFiles/*"
#for f in $FILES
i=1
while [ $i -ne 351 ]
do  
        sbatch --nodes=1 --time=12:00:00 --mem=256G /home/zhoulita/scratch/covid_data_unprocessed/executionFiles/executionfile$i.sh
        i=$(($i+1))
done
