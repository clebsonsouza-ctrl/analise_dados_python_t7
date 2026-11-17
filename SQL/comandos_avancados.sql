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



-- RELACIONAR TABELAS -- 

-- LEFT JOIN: traz todos os registros da tabela da esquerda, mesmo sem correspondência na da direita.
-- Todos os clientes aparecem no resultado;
-- se um cliente tiver várias vendas, ele será repetido uma vez para cada venda.
-- obs.: Bruno Lima aparece nulo.
SELECT 
	clientes.cliente,
    vendas.quantidade    
FROM clientes
LEFT JOIN vendas ON clientes.id = vendas.cliente_id; -- COLUNA COM VALORES EM COMUM EM AMBAS AS TABELAS

SELECT * FROM clientes;
SELECT * FROM vendas;

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
INNER JOIN produtos ON vendas.produto_id = produtos.id;

-- INNER JOIN “quebra” o efeito de preservação do LEFT JOIN
SELECT 
    clientes.cliente,
    vendas.quantidade,
    produtos.produto
FROM clientes
LEFT JOIN vendas ON clientes.id = vendas.cliente_id
INNER JOIN produtos ON vendas.produto_id = produtos.id;

-- 3 RELAÇOES E 4 TABELAS
SELECT 
    clientes.cliente,
    vendas.data_venda,
    vendas.quantidade,
    produtos.produto,
    status_vendas.status
FROM clientes
LEFT JOIN vendas ON clientes.id = vendas.cliente_id
LEFT JOIN produtos ON vendas.produto_id = produtos.id
LEFT JOIN status_vendas ON vendas.id = status_vendas.venda_id;

(*)
-- A consulta pode deixar de trazer todos os clientes e
-- passar a priorizar todos os produtos, mesmo produtos sem venda.
-- Nesse contexto, eu recomendaria não misturar LEFT JOIN com RIGHT JOIN.

SELECT 
    clientes.cliente,
    vendas.data_venda,
    vendas.quantidade,
    produtos.produto,
    status_vendas.status
FROM clientes
LEFT JOIN vendas ON clientes.id = vendas.cliente_id
RIGHT JOIN produtos ON vendas.produto_id = produtos.id
LEFT JOIN status_vendas ON vendas.id = status_vendas.venda_id;

-- com GROUP BY
-- agrupa as vendas por cliente, cidade e estado para calcular o total vendido de cada cliente.
SELECT -- (7)
    c.cliente,
    c.cidade,
    c.estado,
    SUM(v.quantidade * p.preco) AS total_vendido --(6)
FROM clientes c --(1)
INNER JOIN vendas v ON c.id = v.cliente_id --(2)
INNER JOIN produtos p ON p.id = v.produto_id -- (3)
WHERE v.data_venda >= '2026-01-01' --(4)
-- WHERE EXTRACT(YEAR FROM v.data_venda) >= 2026;
GROUP BY c.cliente, c.cidade, c.estado; --(5)
--GROUP BY c.estado; (NESSE CASO COMENTA c.cliente, c.cidade)

/*
1. FROM
2. JOIN
3. WHERE
4. GROUP BY
5. SUM()
6. SELECT

Primeiro o PostgreSQL junta as tabelas,
depois filtra as vendas de 2026 em diante,
agrupa por cliente, cidade e estado,
e por fim calcula o total vendido de cada grupo.
*/

(*)

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

SELECT -- (8)
    c.cliente,
    c.cidade,
    c.estado,
    SUM(v.quantidade * p.preco) AS total_vendido -- (6)
FROM clientes c -- (1)
INNER JOIN vendas v ON c.id = v.cliente_id -- (2)
INNER JOIN produtos p ON p.id = v.produto_id -- (3)
WHERE v.data_venda >= '2026-01-01' -- (4)
GROUP BY c.cliente, c.cidade, c.estado -- (5)
HAVING SUM(v.quantidade * p.preco) > 2000 -- (7)
ORDER BY total_vendido DESC; -- (9)

(*)
--
SELECT
	vendas.data_venda,
    status_vendas.data_status,
	clientes.cliente,
    clientes.cidade,
    clientes.estado,    
    TRIM(produtos.produto) AS produto,
    vendas.quantidade,
    produtos.preco,
    (vendas.quantidade * produtos.preco) AS valor_venda,
    status_vendas.status
FROM clientes
INNER JOIN vendas ON clientes.id = vendas.cliente_id
INNER JOIN produtos ON produtos.id = vendas.produto_id
INNER JOIN status_vendas ON status_vendas.venda_id = vendas.id
WHERE status = 'ENTREGUE'
ORDER BY valor_venda DESC;

(*)
-- Apelido da tabela
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
INNER JOIN produtos p ON p.id = v.produto_id
INNER JOIN status_vendas s ON s.venda_id = v.id
WHERE status = 'ENTREGUE'
ORDER BY valor_venda DESC;

-- FUNÇÃO CASE (CRIAR CONDIÇÕES)

/* ESTURTURA DO CASE
CASE 
WHEN condição1 THEN valor1
WHEN condição2 THEN valor2
ELSE valor_padrao
END
*/

-- Classifica os clientes por faixa etária, identificando-os como `JOVEM`, `ADULTO` ou `IDOSO`.
SELECT 
	cliente,
	idade,
	CASE
		WHEN idade < 30 THEN 'JOVEM'
		WHEN IDADE < 60 THEN 'ADULTO'
		ELSE 'IDOSO'
	END AS idade_condicao
FROM clientes;

-- Classifica cada cliente conforme o domínio do e-mail, identificando se é `gmail`, `yahoo`, `outlook` ou outro.
SELECT 
    cliente,
    CASE
        WHEN email LIKE '%gmail%' THEN 'Dominio gmail'
        WHEN email LIKE '%yahoo%' THEN 'Dominio yahoo'
        WHEN email LIKE '%outlook%' THEN 'Dominio outllok'
        ELSE 'OUTRO'
    END AS dominio
FROM clientes;

-- UNION E UNION ALL

/*
As consultas unidas precisam ter:

o mesmo número de colunas

colunas em ordem compatível (se nao fica colunas com valores distintos)

so para entender a mecãnica

SELECT COLUNA_X AS informacao
FROM TABELA_1

UNION

SELECT COLUNA_Y AS informacao
FROM TABELA_2;
*/

SELECT estado, cidade
FROM clientes
WHERE estado IN ('PE', 'MG');

SELECT estado, cidade
FROM clientes
WHERE estado IN ('MG', 'SC');

-- UNION: Junta os resultados e remove duplicados.

SELECT * FROM clientes;

SELECT estado, cidade
FROM clientes
WHERE estado IN ('PE', 'MG')

UNION

SELECT estado, cidade
FROM clientes
WHERE estado IN ('MG', 'SC');

-- UNION ALL: Junta os resultados e mantém tudo, inclusive duplicados.
SELECT estado, cidade
FROM clientes
WHERE estado IN ('PE', 'MG')

UNION ALL

SELECT estado, cidade
FROM clientes
WHERE estado IN ('MG', 'SC');

-- SUBQUERIES (CONSULTA DENTRO DE UMA CONSULTA)

-- Exemplo subquery no SELECT: mostrar cada cliente e a média geral de idade da tabela

SELECT AVG(idade) FROM clientes; -- 36,15

-- Mostra cada cliente com sua idade e adiciona uma coluna com a média geral de idade de todos os clientes.
SELECT
    cliente,
    -- idade - 36.7 AS dist_media
    idade,
    (SELECT AVG(idade) FROM clientes) AS media_idade
    -- AVG(IDADE) AS media_idade -- NÃO FUNCIONA    
FROM clientes;

-- Mostra cada cliente com sua idade e calcula a diferença entre a idade e a media geral do cliente.
SELECT
	cliente,
	idade,
	idade - (SELECT AVG(idade) FROM clientes) AS media_idade	
FROM clientes;

-- Subquery no WHERE: clientes com idade acima da média
SELECT AVG(idade) FROM clientes; -- 36.7

-- Seleciona os clientes cuja idade é maior que a média geral de idade da tabela clientes.
SELECT
    cliente,
    idade,
    cidade,
    estado
FROM clientes
-- WHERE idade > 36.7; tambem funciona, apenas exemplo didático.
WHERE idade > (SELECT AVG(idade) FROM clientes);

(*)
SELECT
    cliente,
    estado
FROM clientes
WHERE estado IN (
				SELECT estado
				FROM clientes
				GROUP BY estado
				HAVING COUNT(*) > 1);



-- Subquery no FROM (tabela derivada/temporária): média de idade por estado, e depois filtrar apenas médias maiores que 30

-- EXEMPLO DIDÁTICO
SELECT
	estado,
	AVG(idade) AS media_idade
FROM clientes
GROUP BY estado;
-- HAVING AVG (idade) > 30; -- NÃO PRECISARIA DE UMA SUBQUERY

-- Calcula a média de idade por estado em uma tabela temporária (resumo_estados) e
-- depois mostra apenas os estados com média maior que 30 anos

SELECT *
FROM (
    SELECT
        estado,
        AVG(idade) AS media_idade
    FROM clientes
    GROUP BY estado
) AS resumo_estados -- toda tabela derivada precisa ter o seu próprio alias (pode tambem retirar o AS)
WHERE media_idade > 30;

-- Calcular o total vendido por cliente e depois mostrar só quem comprou acima de 2000.
SELECT
        v.cliente_id,
        SUM(v.quantidade * p.preco) AS total_gasto
    FROM vendas v
    INNER JOIN produtos p ON v.produto_id = p.id	
    GROUP BY v.cliente_id; -- primeiro cria essa tabela resumo		
	-- HAVING SUM(v.quantidade * p.preco) > 2000; tambem funciona

-- Calcula o total gasto por cliente em uma subconsulta e mostra apenas os clientes com total acima de 2000.
SELECT
    resumo.cliente_id,
    resumo.total_gasto
FROM (
    SELECT
        v.cliente_id,
        SUM(v.quantidade * p.preco) AS total_gasto
    FROM vendas v
    INNER JOIN produtos p ON v.produto_id = p.id
    GROUP BY v.cliente_id
) AS resumo
WHERE resumo.total_gasto > 2000;

-- VIEW -- 
-- é como uma “consulta salva” no banco de dados.

--Sem VIEW, a consulta ficaria assim:

SELECT
    c.cliente,
    c.cidade,
    c.estado,
    v.data_venda,
    TRIM(p.produto) AS produto,
    v.quantidade,
    p.preco,
    v.quantidade * p.preco AS valor_venda
FROM clientes c
INNER JOIN vendas v ON c.id = v.cliente_id
INNER JOIN produtos p ON p.id = v.produto_id;

-- COM A VIEW

CREATE VIEW vw_resumo_vendas AS
SELECT
    c.cliente,
    c.cidade,
    c.estado,
    v.data_venda,
    TRIM(p.produto) AS produto,
    v.quantidade,
    p.preco,
    v.quantidade * p.preco AS valor_venda
FROM clientes c
INNER JOIN vendas v ON c.id = v.cliente_id
INNER JOIN produtos p ON p.id = v.produto_id;

-- CONSULTANDO A VIEW

SELECT *
FROM vw_resumo_vendas;

-- CTE --

/*
Uma CTE é uma consulta temporária criada dentro de outra consulta para organizar melhor o SQL.
Ela existe apenas durante a execução daquele comando.


*/

WITH resumo_clientes AS (
    SELECT
        v.cliente_id,
        SUM(v.quantidade * p.preco) AS total_gasto
    FROM vendas v
    INNER JOIN produtos p ON v.produto_id = p.id
    GROUP BY v.cliente_id
)

SELECT
    resumo_clientes.cliente_id,
    resumo_clientes.total_gasto
FROM resumo_clientes
WHERE resumo_clientes.total_gasto > 2000;

-----------------

SELECT
    c.cliente,
    c.cidade,
    c.estado,
    v.data_venda,
    TRIM(p.produto) AS produto,
    v.quantidade,
    p.preco,
    v.quantidade * p.preco AS valor_venda
FROM clientes c 
INNER JOIN vendas v ON c.id = v.cliente_id 
INNER JOIN produtos p ON p.id = v.produto_id
WHERE v.data_venda >= '2026-01-01';
--WHERE EXTRACT(YEAR FROM v.data_venda) >= 2026;