import pandas as pd
import numpy as np
from datetime import datetime
import requests
import json

#télécharge des données de la part de eurostat
url="https://ec.europa.eu/eurostat/api/dissemination/sdmx/2.1/data/UNE_RT_M/M.SA.TOTAL.PC_ACT.T.EU27_2020+EU28+EU27_2007+EU25+EA+EA19+EA18+BE+BG+CZ+DK+DE+EE+IE+EL+ES+FR+HR+IT+CY+LV+LT+LU+HU+MT+NL+AT+PL+PT+RO+SI+SK+FI+SE+IS+NO+CH+UK+TR+US+JP/?format=TSV&compressed=false&startPeriod=2020-04&endPeriod=2021-01"
r = requests.get(url)
data=r.content.decode("utf-8")
data=r.content

#mis à jour dés
startPeriod="2020-04"
endPeriod="2021-01"
data=pd.read_csv(url, sep='\t')
# new data frame with split value columns
new= data["freq,s_adj,age,unit,sex,geo\TIME_PERIOD"].str.split(",", expand= True)

# making separate first name column from new data frame

data["freq"]= new[0]
# making separate last name column from new data frame
data["s_adj"]= new[1]
data["age"]= new[2]
data["unit"]= new[3]
data["sex"]= new[4]
data["geo"]= new[5]
# Dropping old Name columns

data.drop(columns=["freq,s_adj,age,unit,sex,geo\TIME_PERIOD"], inplace= True)

data.head()


cols = ['freq','s_adj','age','unit','sex','geo']

final_data = data.melt(id_vars=cols , var_name='date', value_name='rate')
final_data['rate'].replace(":",0, inplace=True, regex=True)
final_data['rate'].replace("e",0, inplace=True, regex=True)

final_data.head()
final_data.to_csv('ChomageDataBrutFromPandas.csv')
