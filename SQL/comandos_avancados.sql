-- COMANDOS AVANÇADOS

-- AGRUPAMENTOS

-- Conta quantos clientes existem em cada estado.
SELECT estado, count(cliente) FROM clientes
GROUP BY estado;

SELECT * FROM clientes;


-- Qual a média de idade dos meus clientes por estado?
-- Calcula a média de idade dos clientes por estado e ordena da maior para a menor média.
SELECT estado, round(AVG(IDADE),2) as Media_idade
FROM clientes
GROUP BY estado
ORDER BY Media_idade DESC;

-- Calcula a média de idade dos clientes para cada combinação de estado e cidade.
-- agrupando por estado e cidade, qual a idade média?
SELECT
    estado,
    cidade,
    AVG(idade) AS media_idade
FROM clientes
GROUP BY estado, cidade;

-- (*)
-- Calcula a média de idade por estado e cidade;
-- o `DISTINCT` é desnecessário porque o `GROUP BY` já retorna combinações únicas.

SELECT DISTINCT
    estado,
    cidade,
    AVG(idade) AS media_idade
FROM clientes
GROUP BY estado, cidade;

-- WHERE E HAVING

-- FILTRAR ANTES DE AGRUPAR: WHERE
-- primeiro pega apenas clientes com idade maior ou igual a 30;
-- depois agrupa por estado
-- depois calcula a média de idade

-- Considerando apenas os clientes com idade maior ou igual a 30 anos,
-- qual é a média de idade dos clientes por estado??

-- Calcula a média de idade por estado considerando apenas clientes com idade maior ou igual a 30 anos.
SELECT estado, 
AVG(IDADE) AS Media_idade
FROM clientes
WHERE idade >= 30
GROUP BY estado
ORDER BY Media_idade DESC;

-- FILTRAR DEPOIS DE AGRUPAR: HAVING
-- primeiro agrupa os clientes por estado
-- depois calcula a média de idade de cada estado;
-- depois mostra apenas os estados cuja média é maior ou igual a 30.

-- Quais estados possuem média de idade dos clientes maior ou igual a 30 anos?
-- Calcula a média de idade por estado e mostra apenas os estados cuja média seja maior ou igual a 30 anos.
SELECT 
    estado, 
    AVG(idade) AS media_idade
FROM clientes
GROUP BY estado
HAVING AVG(idade) >= 30
ORDER BY media_idade DESC;

-- continua...