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

SELECT -- (6º)
	c.cliente, -- 1 coluna
	c.cidade, -- 2 coluna
	c.estado, -- 3 coluna
	SUM(v.quantidade * p.preco) AS total_vendido -- (5º) -- 4 coluna
FROM clientes c -- (1º)
INNER JOIN vendas v ON c.id = v.cliente_id -- (2º)
INNER JOIN produtos p ON v.produto_id = p.id -- (3º)
GROUP BY c.cliente, c.cidade, c.estado; -- (4º)

--
SELECT -- (7º)
	c.cliente, -- 1 coluna
	c.cidade, -- 2 coluna
	c.estado, -- 3 coluna
	SUM(v.quantidade * p.preco) AS total_vendido -- (6º) -- 4 coluna
FROM clientes c -- (1º)
INNER JOIN vendas v ON c.id = v.cliente_id -- (2º)
INNER JOIN produtos p ON v.produto_id = p.id -- (3º)
WHERE v.data_venda >= '2026-01-01' -- (4º)
--WHERE EXTRACT(YEAR FROM v.data_venda) >= 2026
GROUP BY c.cliente, c.cidade, c.estado -- (5º)
ORDER BY total_vendido DESC; -- (8º)
--

SELECT -- (8º)
	c.cliente, -- 1 coluna
	c.cidade, -- 2 coluna
	c.estado, -- 3 coluna
	SUM(v.quantidade * p.preco) AS total_vendido -- (6º) -- 4 coluna
FROM clientes c -- (1º)
INNER JOIN vendas v ON c.id = v.cliente_id -- (2º)
INNER JOIN produtos p ON v.produto_id = p.id -- (3º)
WHERE v.data_venda >= '2026-01-01' -- (4º)
--WHERE EXTRACT(YEAR FROM v.data_venda) >= 2026
GROUP BY c.cliente, c.cidade, c.estado -- (5º)
HAVING SUM(v.quantidade * p.preco) > 2000 -- (7º)
ORDER BY total_vendido DESC; -- (9º)

---
SELECT
	v.data_venda,
	s.data_status,
	c.cliente,
	c.cidade,
	c.estado,
	TRIM(p.produto) AS produto,
	v.quantidade,
	p.preco,
	(v.quantidade * p.preco) AS valor_venda,
	s.status
FROM clientes c
INNER JOIN vendas v ON c.id = v.cliente_id 
INNER JOIN produtos p ON v.produto_id = p.id
INNER JOIN status_vendas s ON s.venda_id = v.id
WHERE status = 'ENTREGUE'
ORDER BY valor_venda DESC;
/*
1. FROM
2. JOIN
3. WHERE
4. GROUP BY
5. Funções agregadoras: SUM(), AVG(), COUNT(), MIN(), MAX()
6. HAVING
7. SELECT
8. ORDER BY

*/

-- FUNÇÃO CASE (CRIAR CONDIÇÕES)

-- Classifica os clientes por faixa etária, identificando-os como `JOVEM`, `ADULTO` ou `IDOSO`.

/* ESTURTURA DO CASE
CASE 
WHEN condição1 THEN valor1
WHEN condição2 THEN valor2
ELSE valor_padrao
END
*/

SELECT 
	cliente,
	idade,
	CASE
		WHEN idade < 30 THEN 'JOVEM'
		WHEN idade < 60 THEN 'ADULTO'
		ELSE 'IDOSO'
	END AS idade_condicao
FROM clientes;

-- Classifica cada cliente conforme o domínio do e-mail,
-- identificando se é `gmail`, `yahoo`, `outlook` ou outro.

SELECT 
	cliente,
	CASE
		WHEN email LIKE '%gmail%' THEN 'DOMINIO GMAIL'
		WHEN email LIKE '%yahoo%' THEN 'DOMINIO YAHOO'
		WHEN email LIKE '%outlook%' THEN 'DOMINIO OUTLOOK'
		ELSE 'OUTRO'
	END AS dominio
FROM clientes;

-- UNION E UNION ALL

SELECT 
	estado,
	cidade
FROM clientes
WHERE estado IN ('MG', 'SC');


SELECT 
	estado,
	cidade
FROM clientes
WHERE estado IN ('MG', 'PE');

-- UNION: Junta os resultados e remove duplicados.

SELECT 
	estado,
	cidade
FROM clientes
WHERE estado IN ('MG', 'SC')

UNION

SELECT 
	estado,
	cidade
FROM clientes
WHERE estado IN ('MG', 'PE');

-- UNION ALL: Junta os resultados e mantém tudo, inclusive duplicados.

SELECT 
	estado,
	cidade
FROM clientes
WHERE estado IN ('MG', 'SC')

UNION ALL

SELECT 
	estado,
	cidade
FROM clientes
WHERE estado IN ('MG', 'PE');

-- SUBQUERIES (CONSULTA DENTRO DE UMA CONSULTA)

-- Exemplo subquery no SELECT: mostrar cada cliente
-- e a média geral de idade da tabela

SELECT AVG(idade) FROM clientes; -- 36.157...

SELECT
	cliente,
	idade,
	(SELECT AVG(idade) FROM clientes) AS media_idade
	-- AVG(idade) AS media_cliente -- não funciona
FROM clientes;


-- Mostra cada cliente com sua idade e calcula
-- a diferença entre a idade e a media geral do cliente.

SELECT
	cliente,
	idade,
	idade - (SELECT AVG(idade) FROM clientes) AS dist_media	
FROM clientes;

-- Subquery no WHERE: clientes com idade acima da média
SELECT
	cliente,
	idade,
	cidade,
	estado
FROM clientes
WHERE idade >= (SELECT AVG(idade) FROM clientes);

SELECT
	cliente,
	estado
FROM clientes
WHERE estado IN (SELECT 
					estado
				FROM clientes
				GROUP BY estado
				HAVING COUNT (*) > 1);

-- Subquery no FROM (tabela derivada/temporária): média de idade por estado,
-- e depois filtrar apenas médias maiores que 30

-- EXEMPLO DIDÁTICO
SELECT 
	estado,
	AVG(idade) AS media_idade
FROM clientes
GROUP BY estado
-- HAVING AVG (idade) > 30; -- NAO PRECISARIA DE UMA SUBQUERY

SELECT 
	*
FROM (SELECT 
	estado,
	AVG(idade) AS media_idade
	FROM clientes
	GROUP BY estado)
WHERE media_idade > 30;

-- Calcular o total vendido por cliente e depois
-- mostrar só quem comprou acima de 2000.

SELECT 
	v.cliente_id,
	SUM(v.quantidade * p.preco) AS total_gasto
FROM vendas v
INNER JOIN produtos p ON v.produto_id = p.id
GROUP BY v.cliente_id;

SELECT
	resumo.cliente_id,
	resumo.total_gasto
FROM (SELECT 
	v.cliente_id,
	SUM(v.quantidade * p.preco) AS total_gasto
	FROM vendas v
	INNER JOIN produtos p ON v.produto_id = p.id
	GROUP BY v.cliente_id) AS resumo
WHERE total_gasto > 2000;

-- VIEW -- 
-- é como uma “consulta salva” no banco de dados.
	
-- sem a VIEW

SELECT 
	c.cliente,
	c.cidade,
	c.estado,
	v.data_venda,
	TRIM(p.produto) AS produto,
	v.quantidade,
	p.preco,
	(v.quantidade * p.preco) AS valor_total
FROM clientes c
INNER JOIN vendas v ON c.id = v.cliente_id
INNER JOIN produtos p ON p.id = v.produto_id;

-- com a VIEW

CREATE VIEW vw_resumo_vendas AS
SELECT 
	c.cliente,
	c.cidade,
	c.estado,
	v.data_venda,
	TRIM(p.produto) AS produto,
	v.quantidade,
	p.preco,
	(v.quantidade * p.preco) AS valor_total
FROM clientes c
INNER JOIN vendas v ON c.id = v.cliente_id
INNER JOIN produtos p ON p.id = v.produto_id;

-- CONSULTAR A VIEW
SELECT
	*
FROM vw_resumo_vendas;

-- CTE --

/*
Uma CTE é uma consulta temporária criada dentro de outra
consulta para organizar melhor o SQL.
Ela existe apenas durante a execução daquele comando.
*/

WITH resumo_clientes AS (
	SELECT 
		v.cliente_id,
		SUM(v.quantidade * p.preco) AS valor_total
	FROM vendas v
	INNER JOIN produtos p ON v.produto_id = p.id
	GROUP BY v.cliente_id		
)
SELECT 
	resumo_clientes.cliente_id,
	resumo_clientes.valor_total
FROM resumo_clientes
WHERE resumo_clientes.valor_total > 2000;

-----------------
SELECT * FROM clientes;

SELECT * FROM produtos;

SELECT * FROM vendas;

SELECT * FROM status_vendas;



