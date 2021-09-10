#! /bin/bash
if [ ! -d "processingScripts" ]
then
    mkdir processingScripts
fi
if [ ! -d "dataFrame" ]
then 
    mkdir dataFrame
fi
i=1
while [ $i -ne 351 ]
do
if [ $i -lt 10 ]
then
    name_dir='~/scratch/covid_data_unprocessed/covid_19_tweets/corona_tweets_0'$i'_data.txt'
else
    name_dir='~/scratch/covid_data_unprocessed/covid_19_tweets/corona_tweets_'$i'_data.txt'
fi
cat <<EOF >~/scratch/covid_data_unprocessed/processingScripts/processfile$i.py
import numpy as np
import pandas as pd
import ast

with open("~/scratch/covid_data_unprocessed/covid_19_tweets/places.txt", encoding="utf8") as pls_file:
    pl=[]
    line= pls_file.readlines()
    for row in range(len(line)):
        temp = ast.literal_eval(line[row])
        pl.append(temp)

    pls_df=pd.DataFrame(pl)

#helper function to calculate the average and apply them to all
def average(number1, number2):
    return (number1 + number2) / 2.0

#compute the average data of latitude and lontitude 
pls_df['Lontitude'] = pls_df.apply(lambda x: average (x['geo']['bbox'][0],x['geo']['bbox'][2]),axis = 1)
pls_df['Latitude'] = pls_df.apply(lambda x: average (x['geo']['bbox'][1],x['geo']['bbox'][3]),axis = 1)


#open the file of the tweets
with open("$name_dir", encoding="utf8") as corona_file:
    tw=[]
    for line in corona_file:
        temp = ast.literal_eval(line)
        if(temp.get("geo","no") == "no"):
            continue
        elif(temp["geo"].get("place_id","no") == "no"):
            continue                                     
        tw.append(temp)
    tws_df=pd.DataFrame(tw)
    
#merge the two dataframe with the geo-id
tws_df['geo_id'] = tws_df.apply(lambda x: x['geo']['place_id'],axis = 1)
tws_merge = pd.merge(tws_df,pls_df,how = 'inner',left_on = 'geo_id',right_on = 'id')

#save the file

tws_merge.to_csv("~/scratch/covid_data_unprocessed/dataFrame/tweet_df_loc_$i.csv")
EOF
#sbatch --node=1 --time=12:00 --mem=256G ./processingScripts/processfile$i.py
i=$(($i+1))
done
