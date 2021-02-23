csv_lines_covid_format = LOAD '/user/cloudera/covide19.csv' USING PigStorage(',') AS
(Date:datetime,
Pays:chararray,
Infections:chararray,
Deces:chararray,
Guerisons:chararray,
TauxDeces:chararray,
TauxGuerison:chararray,
TauxInfection:chararray);

---Eliminer les entetes

NoHeader_Covid = FILTER csv_lines_covid_format BY Pays != 'Pays';

--ajouter les geo (Alpha-2)

output_etl_complete_covidFinal = foreach NoHeader_Covid generate
 			ToString(Date, 'yyyy-MM-dd'),
            ToString(Date, 'yyyy-MM'),
            Pays,
            (CASE Pays
                WHEN 'Autriche' THEN 'AT'
                WHEN 'Belgique' THEN 'BE'
                WHEN 'Bulgarie' THEN 'BG'
                WHEN 'Suisse' THEN 'CH'
                WHEN 'Chypre' THEN 'CY'
                WHEN 'Tcheque'  THEN 'CZ'
                WHEN 'Allemagne' THEN 'DE'
                WHEN 'Danemark'  THEN 'DK'
                WHEN 'Belgique' THEN 'BE'
				WHEN 'Bulgarie'THEN 'BG'
				WHEN 'Tchéquie'THEN 'CZ'
				WHEN 'Danemark'THEN 'DK'
				WHEN 'Allemagne'THEN 'DE'
				WHEN 'Estonie'THEN 'EE'
				WHEN 'Irlande'THEN 'IE'
				WHEN 'Grèce'THEN 'EL'
				WHEN 'Espagne'THEN 'ES'
				WHEN 'France'THEN 'FR'
				WHEN 'Croatie'THEN 'HR'
				WHEN 'Italie'THEN 'IT'
				WHEN 'Chypre'THEN 'CY'
				WHEN 'Lettonie'THEN 'LV'
				WHEN 'Lituanie'THEN 'LT'
				WHEN 'Luxembourg'THEN 'LU'
				WHEN 'Hongrie'THEN 'HU'
				WHEN 'Malte'THEN 'MT'
				WHEN 'Pays-Bas'THEN 'NL'
				WHEN 'Autriche'THEN 'AT'
				WHEN 'Pologne'THEN 'PL'
				WHEN 'Portugal'THEN 'PT'
				WHEN 'Roumanie'THEN 'RO'
				WHEN 'Slovénie'THEN 'SI'
				WHEN 'Slovaquie'THEN 'SK'
				WHEN 'Finlande'THEN 'FI'
				WHEN 'Suède'THEN 'SE'
				WHEN 'Islande'THEN 'IS'
				WHEN 'Liechtenstein'THEN 'LI'
				WHEN 'Norvège'THEN 'NO'
				WHEN 'Suisse'THEN 'CH'
                ELSE 'Hors-Europe'
                END) as geo,
            Infections,
            Deces,
            Guerisons,
            TauxDeces,
            TauxGuerison,
            TauxInfection;
             --generete un fichier contenta tous les pays

output_etl_pays = foreach NoHeader_Covid generate

            Pays,
           (CASE Pays
            WHEN 'Belgique' THEN 'BE'
            WHEN 'Bulgarie'THEN 'BG'
            WHEN 'Tchéquie'THEN 'CZ'
            WHEN 'Danemark'THEN 'DK'
            WHEN 'Allemagne'THEN 'DE'
            WHEN 'Estonie'THEN 'EE'
            WHEN 'Irlande'THEN 'IE'
            WHEN 'Grèce'THEN 'EL'
            WHEN 'Espagne'THEN 'ES'
            WHEN 'France'THEN 'FR'
            WHEN 'Croatie'THEN 'HR'
            WHEN 'Italie'THEN 'IT'
            WHEN 'Chypre'THEN 'CY'
            WHEN 'Lettonie'THEN 'LV'
            WHEN 'Lituanie'THEN 'LT'
            WHEN 'Luxembourg'THEN 'LU'
            WHEN 'Hongrie'THEN 'HU'
            WHEN 'Malte'THEN 'MT'
            WHEN 'Pays-Bas'THEN 'NL'
            WHEN 'Autriche'THEN 'AT'
            WHEN 'Pologne'THEN 'PL'
            WHEN 'Portugal'THEN 'PT'
            WHEN 'Roumanie'THEN 'RO'
            WHEN 'Slovénie'THEN 'SI'
            WHEN 'Slovaquie'THEN 'SK'
            WHEN 'Finlande'THEN 'FI'
            WHEN 'Suède'THEN 'SE'
            WHEN 'Islande'THEN 'IS'
            ELSE 'Hors-Europe'
            END) as NomPayes;

--generete un Calandirer contenta tous les dates

output_etl_date = foreach NoHeader_Covid generate
			GetYear(Date),
            GetMonth(Date),
            GetDay(Date),
            GetWeek(Date);

output_etl_complete_date = DISTINCT output_etl_date;



--Save the results
STORE output_etl_pays into '/user/cloudera/datalake/prepared_data/pays_Data' using PigStorage(',');
STORE output_etl_complete_date into '/user/cloudera/datalake/prepared_data/date_Data' using PigStorage(',');
STORE output_etl_complete_covidFinal into '/user/cloudera/datalake/prepared_data/covid19_Data' using PigStorage(',');

