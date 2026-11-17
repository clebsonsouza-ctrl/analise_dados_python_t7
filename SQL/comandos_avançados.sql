-- COMANDOS AVANÇADOS

-- AGRUPAMENTOS

-- Conta quantos clientes existem em cada estado.

SELECT 
	estado,
	COUNT(cliente)
FROM clientes
GROUP BY estado;

-- Calcula a média de idade dos clientes por estado e ordena da maior para a menor méd

SELECT
	estado,
	ROUND(AVG(idade), 2) AS Media_idade
FROM clientes
GROUP BY estado
ORDER BY Media_idade DESC;

-- agrupando por estado e cidade, qual a idade média?

SELECT 
	estado,
	cidade,
	ROUND(AVG(idade), 2) AS Media_idade
FROM clientes
GROUP BY estado, cidade
ORDER BY estado ASC, Media_idade DESC;

-- WHERE E HAVING

-- FILTRAR ANTES DE AGRUPAR: WHERE
-- primeiro pega apenas clientes com idade maior ou igual a 30;
-- depois agrupa por estado
-- depois calcula a média de idade

-- Considerando apenas os clientes com idade maior ou igual a 30 anos,
-- qual é a média de idade dos clientes por estado??

SELECT 
	estado,
	ROUND(AVG(idade), 2) AS Media_idade -- (4)
FROM clientes         -- (1)
WHERE idade >= 30     -- (2)
GROUP BY estado -- (3)
ORDER BY Media_idade DESC; -- (5)

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

-- RELACIONAR TABELAS --

-- LEFT JOIN: traz todos os registros da tabela da esquerda, mesmo sem correspondência na da direita.
-- Todos os clientes aparecem no resultado;
-- se um cliente tiver várias vendas, ele será repetido uma vez para cada venda.
-- obs.: Bruno Lima aparece nulo.

SELECT 
	clientes.cliente,
	vendas.quantidade
FROM clientes
LEFT JOIN vendas ON clientes.id = vendas.cliente_id;

-- RIGHT JOIN: traz todos os registros da tabela da direita, mesmo sem correspondência na da esquerda

SELECT 
	clientes.cliente,
	vendas.quantidade
FROM clientes
RIGHT JOIN vendas ON clientes.id = vendas.cliente_id;

-- INNER JOIN: traz apenas os registros que existem nas duas tabelas (OU JOIN)
-- obs.: Bruno Lima não apareceu.

SELECT 
	clientes.cliente,
	vendas.quantidade
FROM clientes
INNER JOIN vendas ON clientes.id = vendas.cliente_id;

-- FULL OUTER JOIN: retorna todos os registros das duas tabelas
SELECT 
	clientes.cliente,
	vendas.quantidade
FROM clientes
FULL OUTER JOIN vendas ON clientes.id = vendas.cliente_id;

-- vamos acrescentar mais uma relação com a tabela produtos (2 RELAÇOES E 3 TABELAS)

SELECT 
	clientes.cliente,
	vendas.quantidade,
	produtos.produto		
FROM clientes
LEFT JOIN vendas ON clientes.id = vendas.cliente_id
LEFT JOIN produtos ON vendas.produto_id = produtos.id;

-- INNER JOIN “quebra” o efeito de preservação do LEFT JOIN

SELECT 
	clientes.cliente,
	vendas.quantidade,
	produtos.produto		
FROM clientes
LEFT JOIN vendas ON clientes.id = vendas.cliente_id
INNER JOIN produtos ON vendas.produto_id = produtos.id;

-- 3 RELAÇOES E 4 TABELAS

SELECT -- (5)
	clientes.cliente,
	vendas.data_venda,
	vendas.quantidade,
	produtos.produto,
	status_vendas.status
FROM clientes --(1)
LEFT JOIN vendas ON clientes.id = vendas.cliente_id -- (2)
LEFT JOIN produtos ON vendas.produto_id = produtos.id -- (3)
LEFT JOIN status_vendas ON vendas.id = status_vendas.venda_id; -- (4)

-- com GROUP BY
-- agrupa as vendas por cliente, cidade e estado para calcular o total (quntidade * preco) vendido de cada cliente.

SELECT
	c.cliente,
	c.cidade,
	c.estado,
	SUM(v.quantidade * p.preco) AS total_vendido -- (5º)
FROM clientes c -- (1º)
INNER JOIN vendas v ON c.id = v.cliente_id -- (2º)
INNER JOIN produtos p ON v.produto_id = p.id -- (3º)
GROUP BY c.cliente, c.cidade, c.estado; -- (4º)



-----------------
SELECT * FROM clientes;

SELECT * FROM produtos;

SELECT * FROM vendas;

SELECT * FROM status_vendas;



