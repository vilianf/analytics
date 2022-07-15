#Acumulado de ocorrencias durante o ano de 2021 por dia
SELECT DISTINCT `Incident Date`,
	   COUNT(ID) OVER (PARTITION BY DATE(CAST(`Incident Date` AS DATE)) ORDER BY `Incident Date`) as Quantidade
FROM datasf.fire_incidents;

#Meses com maior numero de incidentes com fogo
SELECT MONTH(`Incident Date`) as Mes, YEAR(`Incident Date`) AS Ano, COUNT(ID) AS Quantidade_Mes
FROM datasf.fire_incidents
GROUP BY 1, 2
ORDER BY 3 DESC;


#Feridos
SELECT ID, `Incident Date`, `Fire Injuries`, `Civilian Injuries`
FROM datasf.fire_incidents
WHERE `Civilian Fatalities` > 0
OR `Fire Injuries` > 0
ORDER BY 3, 4 DESC;

#Mortes
SELECT ID, `Incident Date`, `Fire Fatalities`, `Civilian Fatalities`
FROM datasf.fire_incidents
WHERE `Civilian Fatalities` > 0
OR `Fire Fatalities` > 0
ORDER BY 3, 4 DESC;

#Numero de ocorrencias por bairro
SELECT neighborhood_district, COUNT(id) as quantidade_bairro
FROM datasf.fire_incidents
GROUP BY 1
ORDER BY 2 DESC;

#Tempo entre acionamento até chegada ao local do incidente
SELECT resultado.id, 
       resultado.Hora_acionamento, 
       resultado.Hora_Chegada,
       TIMESTAMPDIFF(SECOND, resultado.Hora_Chegada, resultado.Hora_acionamento) AS Tempo_deslocamento
FROM
(SELECT ID,
	   CAST(REPLACE(`Alarm DtTm`, 'T', ' ') as DATETIME) as Hora_Acionamento,
       CAST(REPLACE(`Arrival DtTm`, 'T', ' ') as DATETIME) as Hora_Chegada
FROM datasf.fire_incidents
) resultado;

