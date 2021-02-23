create database impact_covid;

use database impact_covid;
Drop table if Exists covid_europe;
create external table covid_europe (
Date DATE,
DateST string,
Pays string,
geo string,
Infections int,
Deces int,
Guerisons int,
TauxDeces int,
TauxGuerison int,
TauxInfection int)
ROW FORMAT DELIMITED
FIELDS TERMINATED BY ','
STORED AS TEXTFILE
Location '/user/cloudera/datalake/prepared_data/covid19_final'

-----------------------------------------Tablechomage-------------------------------------------------------------

Drop table if Exists chomage;
create external table chomage (
Identifiant int,
Codepays string,
Date string,
Tauxchoamge double,
Pays string)
ROW FORMAT DELIMITED
FIELDS TERMINATED BY ';'
STORED AS TEXTFILE
Location '/user/cloudera/Economie';


-----------------------------------TablePays--------------------------------------------------
Drop table if Exists pays;
create external table pays (
Pays string,
geo string)
ROW FORMAT DELIMITED
FIELDS TERMINATED BY ','
STORED AS TEXTFILE
Location '/user/cloudera/DimensionPays'
---------------------------------------Date-------------------------------------------------------------

Drop table if Exists date;
create external table date (
Annee int,
Jour int,
Mois int,
SemaineAnnee int)
ROW FORMAT DELIMITED
FIELDS TERMINATED BY ','
STORED AS TEXTFILE
Location '/user/cloudera/DimensionDate'

--------------------------------------datamartcovid----------------------------------------------------------
create database if not exists data_mart_covid;
use data_mart_covid;
drop table if exists covid19_dataM;

create table covid19_dataM as select date, avg(deces) as MD , avg(tauxdeces) as ATD from impact_covid.covid_europe where pays='France'
Group by date


Select * from covid19_dataM;
-----------------------------datamartchomage--------------------------

create database if not exists data_mart_chomage;
use data_mart_chomage;
create table covid_chomage as select date, codepays, tauxchoamge from chomage
Group by date
-------------------------------choamgecoviddatamart------------------------

create database if not exists data_mart_economiecovid;
use data_mart_economiecovid;
create table infection_choamge as select chomage.date, chomage.pays, chomage.tauxchoamge, covid_europe.infections from chomage , covid_europe where
chomage.pays = covid_europe.pays
group by date




