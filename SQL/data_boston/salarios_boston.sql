#Teste de Correção na base, que tinha vírgula na coluna Salario
SELECT CAST(REPLACE(REGULAR, ',', '') AS DECIMAL(10,2))
FROM databt.salarios
ORDER BY 1 DESC;

#Media por departamento
SELECT DEPARTMENT_NAME, 
	   ROUND(AVG(CAST(REPLACE(REGULAR, ',', '') AS DECIMAL(10,2))), 2) AS Media_Departamento
FROM databt.salarios
GROUP BY 1
ORDER BY 2 DESC;

#Relacao de pessoas que receberam indenizacao por ferimentos em serviço
SELECT NAME,
       DEPARTMENT_NAME,
       CAST(REPLACE(INJURED, ',', '') AS DECIMAL(10,2)) AS Indenizacao
FROM databt.salarios
ORDER BY 3 DESC;

#Relacao media de departamentos que mais recebem hora extra e que seja acima de 1000
SELECT DEPARTMENT_NAME,
	   ROUND(AVG(CAST(REPLACE(OVERTIME, ',', '') AS DECIMAL(10,2))), 2) as Media
FROM databt.salarios
GROUP BY 1
HAVING Media > 1000
ORDER BY 2 DESC;

# Vencimento mais baixo, mais alto e Media do departametno de polícia (Juntando salario, horas extras e demais acrescimos)
SELECT DEPARTMENT_NAME,
	   ROUND(AVG(CAST(REPLACE(TOTAL_GROSS, ',', '') AS DECIMAL(10,2))), 2) as Media_Salarial,
       MIN(CAST(REPLACE(TOTAL_GROSS, ',', '') AS DECIMAL(10,2))) AS Piso_Rendimento,
       MAX(CAST(REPLACE(TOTAL_GROSS, ',', '') AS DECIMAL(10,2))) AS Teto_Rendimento
FROM databt.salarios
WHERE DEPARTMENT_NAME LIKE 'Boston Police Department'
GROUP BY 1;

# Piso, teto e media de rendimento dos professores
SELECT TITLE,
	   ROUND(AVG(CAST(REPLACE(TOTAL_GROSS, ',', '') AS DECIMAL(10,2))), 2) as Media_Salarial,
       MIN(CAST(REPLACE(TOTAL_GROSS, ',', '') AS DECIMAL(10,2))) AS Piso_Rendimento,
       MAX(CAST(REPLACE(TOTAL_GROSS, ',', '') AS DECIMAL(10,2))) AS Teto_Rendimento
FROM databt.salarios
WHERE TITLE LIKE 'Teacher'
GROUP BY 1;

# Media salarial por cargos que tenham mais de 20 pessoas
SELECT resultado.TITLE,
	   resultado.Quantidade,
       resultado.Media_Rendimento_Cargo
FROM
(SELECT TITLE,
		COUNT(*) as Quantidade,
	    ROUND(AVG(CAST(REPLACE(TOTAL_GROSS, ',', '') AS DECIMAL(10,2))), 2) as Media_Rendimento_Cargo
FROM databt.salarios
GROUP BY 1) resultado
WHERE resultado.Quantidade > 20
ORDER BY 2 DESC;
