#! /bin/bash
i=1
if [ ! -d "executionFiles" ]
then 
    mkdir executionFiles
fi
while [ $i -ne 351 ]
do
cat <<EOF > /home/zhoulita/scratch/covid_data_unprocessed/executionFiles/executionfile$i.sh
#! /bin/bash
python /home/zhoulita/scratch/covid_data_unprocessed/processingScripts/processfile$i.py
EOF
i=$(($i+1))
done
