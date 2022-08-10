#Acidentes de helicoptero com fatalidades
SELECT codigo_ocorrencia, 
	ocorrencia_dia, 
       aeronave_tipo_veiculo, 
       aeronave_fatalidades_total
FROM cenipa.aeronave A, cenipa.ocorrencia O
WHERE A.codigo_ocorrencia2 = O.codigo_ocorrencia
AND A.aeronave_tipo_veiculo LIKE 'HELICOPTERO'
AND A.aeronave_fatalidades_total > 0;

#Acidentes com maior numero de fatalidades
SELECT A.ocorrencia_dia,
	B.aeronave_tipo_veiculo,
       B.aeronave_fatalidades_total
FROM cenipa.ocorrencia A, cenipa.aeronave B
WHERE A.codigo_ocorrencia = B.codigo_ocorrencia2
AND B.aeronave_fatalidades_total > 0
ORDER BY 3 DESC
LIMIT 10;

#Fatores mais presentes em acidentes com fatalidades
SELECT fator_nome,
	COUNT(*) AS Quantidade
FROM cenipa.fator_contribuinte A, cenipa.ocorrencia B, cenipa.aeronave C
WHERE A.codigo_ocorrencia3 = B.codigo_ocorrencia
AND B.codigo_ocorrencia = C.codigo_ocorrencia2
AND C.aeronave_fatalidades_total > 0
GROUP BY 1
ORDER BY 2 DESC;

#Dias em que ocorreram fatalidades
SELECT DATE(STR_TO_DATE(A.ocorrencia_dia, '%d/%m/%Y')) AS Data,
	SUM(B.aeronave_fatalidades_total) OVER (PARTITION BY DATE(STR_TO_DATE(A.ocorrencia_dia, '%d/%m/%Y'))) AS Quantidade_fatalidades
FROM cenipa.ocorrencia A, cenipa.aeronave B
WHERE A.codigo_ocorrencia = B.codigo_ocorrencia2
AND B.aeronave_fatalidades_total > 0;

#Tempo medio entre data do acidente ate o relatorio da cenipa
SELECT A.codigo_ocorrencia,
	DATE(STR_TO_DATE(A.ocorrencia_dia, '%d/%m/%Y')) AS Data_acidente,
	B.recomendacao_dia_assinatura AS Data_Relatorio,
       ROUND(AVG(DATEDIFF(B.recomendacao_dia_assinatura, STR_TO_DATE(A.ocorrencia_dia, '%d/%m/%Y'))), 0) AS Tempo_Media_Dias
FROM cenipa.ocorrencia A, cenipa.recomendacao B
WHERE A.codigo_ocorrencia = B.codigo_ocorrencia4
GROUP BY 1;

#Quais modelos com mais ocorrencias?
SELECT aeronave_modelo,
	COUNT(DISTINCT codigo_ocorrencia2) AS Quantidade
FROM cenipa.aeronave
GROUP BY 1
ORDER BY 2 DESC;

#Em ocorrencias com fatalidades, quais os principais operadores?
SELECT aeronave_operador_categoria,
	COUNT(DISTINCT codigo_ocorrencia2) AS Quantidade
FROM cenipa.aeronave
WHERE aeronave_fatalidades_total > 0
GROUP BY 1
ORDER BY 2 DESC;

#Relacao de quantidade de ocorrencias por ano de fabricacao da aeronave
SELECT YEAR(STR_TO_DATE(aeronave_ano_fabricacao, '%Y')) as Ano,
       COUNT(DISTINCT codigo_ocorrencia2) as Quantidade_Ocorrencias
FROM cenipa.aeronave
GROUP BY 1
ORDER BY 2 DESC;

#Quantidade de incidentes considerados graves por ano
SELECT YEAR(STR_TO_DATE(ocorrencia_dia, '%d/%m/%Y')) as Ano,
	   COUNT(DISTINCT codigo_ocorrencia) as Quantidade_Incidentes_Graves
FROM cenipa.ocorrencia
WHERE ocorrencia_classificacao LIKE 'INCIDENTE GRAVE'
GROUP BY 1
ORDER BY 2 DESC;

#Em qual fase mais ocorrem os incidentes?
SELECT aeronave_fase_operacao,
	   COUNT(DISTINCT codigo_ocorrencia2) as Quantidade
FROM cenipa.aeronave
GROUP BY 1
ORDER BY 2 DESC;
