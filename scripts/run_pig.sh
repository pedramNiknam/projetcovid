#!/bin/bash

# Download dataset closed company in an empty directory
rm -rf EntrepriseFermeFR

# create directory for closed company
mkdir EntrepriseFermeFR
cd EntrepriseFermeFR/

# downlod data of closed company and unzip the data
wget "https://www.insee.fr/fr/statistiques/serie/telecharger/001656092?ordre=antechronologique&transposition=donneescolonne&periodeDebut=1&anneeDebut=2018&periodeFin=11&anneeFin=2020" -O EntrepriseFermeFR.zip

unzip EntrepriseFermeFR.zip





#prepar the diroctory for data of closed compny in HDFS
#create
hadoop fs -mkdir -p /user/cloudera/EntrepriseFermeFR
hadoop fs -mkdir -p /user/cloudera/h1n1
hadoop fs -mkdir -p /user/cloudera/pig
#delete
hadoop fs -rm /user/cloudera/pig/EntroFermeFR/*
hadoop fs -rmdir /user/cloudera/pig/EntroFermeFR
hadoop fs -rm /user/cloudera/EntroFermeFR/*
#transfer
hadoop fs -put * /user/cloudera/EntroFermeFR
#Run Pig Scrip
pig EntroFermeFR.pig

#delete the directory of data
cd ..
rm -rf EntrepriseFermeFR


# Download dataset in an empty directory
rm -rf COVID-19

git clone https://github.com/CSSEGISandData/COVID-19.git

# Remove commas between double quotes
sed -i ':a;s/^\(\([^"]*,\?\|"[^",]*",\?\)*"[^",]*\),/\1 /;ta' COVID-19/csse_covid_19_data/csse_covid_19_daily_reports/*.csv

# Replace original file dates to match the dates included in the file names
for f in COVID-19/csse_covid_19_data/csse_covid_19_daily_reports/*.csv; do
    fdate=$(basename $f .csv | awk -F- {'print $3"-"$1"-"$2'})
    echo $fdate
    touch -d "$(date -d $fdate)" $f
done

# Copy the files to different directories depending on the date. They have different formats
mkdir format1
mkdir format2

find COVID-19/csse_covid_19_data/csse_covid_19_daily_reports/ -maxdepth 1 -not -newermt "2020-03-21" -exec basename \{} .po \; | grep csv | sort | xargs -I % mv COVID-19/csse_covid_19_data/csse_covid_19_daily_reports/% format1/
find COVID-19/csse_covid_19_data/csse_covid_19_daily_reports/ -maxdepth 1 -newermt "2020-03-21" -exec basename \{} .po \; | grep csv | sort | xargs -I % mv COVID-19/csse_covid_19_data/csse_covid_19_daily_reports/% format2/

# Prepare cloudera directories for PIG - Create and empty directories in the case there is data
hadoop fs -mkdir -p /user/cloudera/covid/format1

hadoop fs -mkdir -p /user/cloudera/covid/format2

hadoop fs -mkdir -p /user/cloudera/h1n1

hadoop fs -mkdir -p /user/cloudera/pig

hadoop fs -rm /user/cloudera/pig/covid_19_complete/*

hadoop fs -rmdir /user/cloudera/pig/covid_19_complete

hadoop fs -rm /user/cloudera/pig/covid_19_country_per_day/*

hadoop fs -rmdir /user/cloudera/pig/covid_19_country_per_day

hadoop fs -rm /user/cloudera/covid/format1/*

hadoop fs -rm /user/cloudera/covid/format2/*

hadoop fs -put format1/* /user/cloudera/covid/format1

hadoop fs -put format2/* /user/cloudera/covid/format2

# Run PIG Latin script - Should be in in the same directory
pig covid.pig

# Remove temporary directories
rm -rf format1
rm -rf format2
