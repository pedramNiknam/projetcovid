test = LOAD '/user/cloudera/EntrepriseFermeFR/valeurs_mensuelles.csv' USING PigStorage(';') AS (
            date : chararray,
            NBFerme : chararray,
            rate : chararray);




 	 testun = FILTER test BY date != 'date';

     testdeux = FOREACH testun GENERATE REPLACE(date,'[\\"]',''), REPLACE(NBFerme,'[\\"]',''), REPLACE(rate,'[\\"]','');




STORE testdeux into '/user/cloudera/datalake/prepared_data/EntrepriseFermeFR_Data15' using PigStorage(';');
