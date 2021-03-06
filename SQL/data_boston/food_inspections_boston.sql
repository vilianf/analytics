#Quais estabelecimentos com mais violacoes nas inspecoes?
SELECT  businessname,
        COUNT(licenseno) as Quantidade
FROM databt.food_inspections
WHERE violstatus LIKE 'fail'
GROUP BY 1
ORDER BY 2 DESC;

#Quais estabelecimentos com mais violacoes graves *** ?
SELECT  businessname,
        COUNT(licenseno) as Quantidade
FROM databt.food_inspections
WHERE viollevel LIKE '***'
GROUP BY 1
ORDER BY 2 DESC;

#Quantas violacoes mais graves *** ocorreram por ano?
SELECT  YEAR(STR_TO_DATE(violdttm, '%Y-%m-%d')) as Ano,
        COUNT(licenseno) as Quantidade
FROM databt.food_inspections
WHERE viollevel LIKE '***'
GROUP BY 1
ORDER BY 2 DESC;

#Comparado ao Total de inspecoes, quantas sao aprovadas?
SELECT  COALESCE(violstatus, 'Total') as Status,
		COUNT(*) as Quantidade
FROM databt.food_inspections
GROUP BY 1 WITH ROLLUP;

#Entre inspecoes que apresentaram problemas, a quantidade por nota e por Ano
SELECT  COALESCE(viollevel, 'Total Inspecoes') as Nivel_violacao,
		COALESCE(YEAR(STR_TO_DATE(violdttm, '%Y-%m-%d')), 'Total Ano') AS Ano,
		COUNT(*) as Quantidade
FROM databt.food_inspections
GROUP BY 1, 2 WITH ROLLUP;

#Verificado que subway foi o estabelecimento com mais violacoes. Levantamento de cada avaliacao, ao longo do tempo
SELECT  businessname,
		viollevel,
		DATE(STR_TO_DATE(violdttm, '%Y-%m-%d')),
        COUNT(licenseno) OVER (PARTITION BY businessname ORDER BY DATE(STR_TO_DATE(violdttm, '%Y-%m-%d'))) AS Quantidade_Dia
FROM databt.food_inspections
WHERE violstatus LIKE 'fail'
AND businessname LIKE 'Subway';

#Historico ao longo do tempo de inspecoes com violacoes graves (***)
SELECT  businessname,
		DATE(STR_TO_DATE(violdttm, '%Y-%m-%d')) as Ano,
        COUNT(licenseno) OVER (PARTITION BY businessname ORDER BY DATE(STR_TO_DATE(violdttm, '%Y-%m-%d')))as Quantidade
FROM databt.food_inspections
WHERE viollevel LIKE '***'
