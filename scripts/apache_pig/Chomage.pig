csv_lines_Chomage_format = LOAD '/user/cloudera/ChomageDataBrutFromPandas.csv' USING PigStorage(',') AS (
			id:chararray,
			freq:chararray,
            s_adj:chararray,
            age: chararray,
            unit: chararray,
            sex:chararray,
            geo:chararray,
            date:chararray,
            rate:chararray);


---Eliminer les entetes
NoHeader_Chomage = FILTER csv_lines_Chomage_format BY freq != 'freq';

---ajoute clonne  de Pays

output_etl_complete_ChomageFinal = foreach NoHeader_Chomage generate
            id,
            geo,
            date,
            rate,
            (CASE geo
                WHEN 'AT' THEN 'Autriche'
                WHEN 'BE' THEN 'Belgique'
				WHEN 'BG' THEN 'Bulgarie'
				WHEN 'CH' THEN 'Suisse'
				WHEN 'CY' THEN 'Chypre'
				WHEN 'CZ' THEN 'Tcheque'
				WHEN 'DE' THEN 'Allemagne'
                WHEN 'DK' THEN 'Danemark'
				WHEN 'EE' THEN 'Estonie'
                WHEN 'EL' THEN 'Grece'
				WHEN 'ES' THEN 'Espagne'
				WHEN 'FI' THEN 'Finlande'
				WHEN 'FR' THEN 'France'
                WHEN 'HR' THEN 'Croatie'
				WHEN 'HU' THEN 'Hongrie'
				WHEN 'IE' THEN 'Irlande'
				WHEN 'IS' THEN 'Islande'
				WHEN 'IT' THEN 'Italie'
				WHEN 'LT' THEN 'Lituanie'
				WHEN 'LU' THEN 'Luxembourg'
				WHEN 'LV' THEN 'Lettonie'
				WHEN 'MT' THEN 'Malte'
				WHEN 'NL' THEN 'Pays-Bas'
                WHEN 'NO' THEN 'Norvege'
				WHEN 'PL' THEN 'Pologne'
				WHEN 'PT' THEN 'Portugal'
				WHEN 'RO' THEN 'Roumanie'
				WHEN 'SE' THEN 'Suede'
				WHEN 'SI' THEN 'Slovenie'
				WHEN 'SK' THEN 'Slovaquie'
				WHEN 'TR' THEN 'Turquie'
				WHEN 'UK' THEN 'Royaume-Uni'
				WHEN 'US' THEN 'Etats-Unis Amerique'
				WHEN 'EU27_2020' THEN 'europe hors UK'
                ELSE geo
                END) as Paye;



STORE output_etl_complete_ChomageFinal into '/user/cloudera/datalake/prepared_data/Chomage_Data' using PigStorage(';');
