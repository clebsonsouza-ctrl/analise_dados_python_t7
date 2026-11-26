-- ============================================================
-- QUESTÃO 01 - IDENTIFICAÇÃO DE DADOS AUSENTES
-- ============================================================

-- CONTEXTO:
-- Uma empresa de comércio eletrônico está realizando uma
-- revisão dos cadastros de seus clientes para melhorar
-- a qualidade das informações armazenadas.
--
-- Durante essa análise, foram identificados registros com
-- idade ou cidade não preenchidas (NULL), além de clientes
-- com o campo de e-mail vazio ('').

-- DESAFIO:
-- Elabore uma consulta SQL que identifique os clientes
-- que apresentam pelo menos uma dessas inconsistências:
--
-- 1. Cidade com valor NULL;
-- 2. Idade com valor NULL;
-- 3. E-mail preenchido com uma string vazia ('').
--
-- REQUISITOS:
-- a) Exibir as colunas: id, cliente, email, cidade e idade.
-- b) Considerar qualquer uma das três condições.
-- c) Ordenar os resultados pelo nome do cliente (A-Z).

-- ESCREVA SUA CONSULTA SQL ABAIXO:

SELECT
    id,
    cliente,
    email,
    cidade,
    idade
FROM clientes                   -- (1) Seleciona a tabela.
WHERE cidade IS NULL            -- (2) Verifica cidade nula.
   OR idade IS NULL             -- (2) Verifica idade nula.
   OR email = ''                 -- (2) Verifica e-mail vazio.
ORDER BY cliente ASC;           -- (4) Ordena por nome.

-- ORDEM LÓGICA DE EXECUÇÃO:
-- 1. FROM     → Identifica a tabela.
-- 2. WHERE    → Filtra os registros.
-- 3. SELECT   → Seleciona as colunas.
-- 4. ORDER BY → Ordena os resultados.


-- ============================================================
-- QUESTÃO 02 - TRATAMENTO DE DADOS TEXTUAIS
-- ============================================================

-- CONTEXTO:
-- Uma empresa identificou nomes de produtos com espaços
-- desnecessários e diferenças entre letras maiúsculas
-- e minúsculas.

-- DESAFIO:
-- Elabore uma consulta SQL que padronize os nomes dos
-- produtos, removendo espaços no início e no final
-- e convertendo todos os caracteres para maiúsculas.

-- REQUISITOS:
-- 1. Exibir: id, produto e preco.
-- 2. Criar a coluna produto_tratado com o nome padronizado.
-- 3. Ordenar pelo nome do produto tratado (A-Z).


-- ESCREVA SUA CONSULTA SQL ABAIXO:

SELECT
    id,
    produto,
    preco,
    UPPER(TRIM(produto)) AS produto_tratado -- (3) Remove espaços e converte para maiúsculas.
FROM produtos                              -- (1) Seleciona a tabela.
ORDER BY produto_tratado ASC;              -- (4) Ordena pelo nome tratado.

-- ORDEM LÓGICA DE EXECUÇÃO:
-- 1. FROM     → Identifica a tabela.
-- 2. SELECT   → Seleciona as colunas.
-- 3. TRIM/UPPER → Trata o nome do produto no SELECT.
-- 4. ORDER BY → Ordena os resultados.

-- ============================================================
-- QUESTÃO 03 - ANÁLISE DE VENDAS POR PERÍODO
-- ============================================================

-- CONTEXTO:
-- Uma empresa precisa analisar o desempenho das vendas
-- realizadas em 2026 para acompanhar os resultados
-- comerciais.

-- DESAFIO:
-- Elabore uma consulta SQL que apresente, por mês,
-- a quantidade de vendas realizadas e o valor total
-- vendido durante o ano de 2026.

-- REQUISITOS:
-- 1. Exibir: mês, total_vendas e faturamento.
-- 2. Considerar apenas vendas realizadas em 2026.
-- 3. Desconsiderar valores nulos no cálculo do faturamento.
-- 4. Ordenar os resultados por mês, em ordem crescente.

-- ESCREVA SUA CONSULTA SQL ABAIXO:

SELECT                                      -- (4) Exibe os resultados.
    EXTRACT(MONTH FROM data_venda) AS mes,
    COUNT(*) AS total_vendas,
    SUM(valor_total) AS faturamento
FROM vendas                                 -- (1) Seleciona a tabela.
WHERE data_venda >= '2026-01-01'           -- (2) Filtra o ano de 2026.
  AND data_venda < '2027-01-01'
GROUP BY EXTRACT(MONTH FROM data_venda)     -- (3) Agrupa por mês.
ORDER BY mes ASC;                           -- (5) Ordena os meses.

-- ORDEM LÓGICA DE EXECUÇÃO:
-- 1. FROM     → Identifica a tabela.
-- 2. WHERE    → Filtra as vendas de 2026.
-- 3. GROUP BY → Agrupa as vendas por mês.
-- 4. SELECT   → Calcula COUNT() e SUM() por grupo.
-- 5. ORDER BY → Ordena os meses.

-- ============================================================
-- QUESTÃO 04 - ANÁLISE DE VENDAS POR CLIENTE
-- ============================================================

-- CONTEXTO:
-- Uma empresa deseja identificar os clientes que mais
-- contribuíram para o faturamento durante o ano de 2026.

-- DESAFIO:
-- Elabore uma consulta SQL que apresente o valor total
-- das compras realizadas por cada cliente em 2026.

-- REQUISITOS:
-- 1. Relacionar as tabelas clientes e vendas.
-- 2. Exibir: cliente, estado, total_compras e total_gasto.
-- 3. Considerar apenas as vendas realizadas em 2026.
-- 4. Exibir somente clientes com total gasto acima de R$ 2.000.
-- 5. Ordenar pelo maior valor gasto.

-- ESCREVA SUA CONSULTA SQL ABAIXO:

SELECT                                      -- (6) Exibe os resultados.
    c.cliente,
    c.estado,
    COUNT(v.id) AS total_compras,
    SUM(v.valor_total) AS total_gasto
FROM clientes AS c                                                      -- (1) Seleciona a tabela clientes.
INNER JOIN vendas AS v ON c.id = v.cliente_id                           -- (2) Relaciona as tabelas.    
WHERE v.data_venda >= '2026-01-01' AND v.data_venda < '2027-01-01'      -- (3) Filtra as vendas de 2026.  
GROUP BY c.id, c.cliente, c.estado                                      -- (4) Agrupa por cliente.
HAVING SUM(v.valor_total) > 2000                                        -- (5) Filtra os grupos.
ORDER BY total_gasto DESC;                                              -- (7) Ordena pelo maior gasto.

-- ORDEM LÓGICA DE EXECUÇÃO:
-- 1. FROM     → Identifica a tabela principal.
-- 2. JOIN     → Relaciona clientes e vendas.
-- 3. WHERE    → Filtra as vendas de 2026.
-- 4. GROUP BY → Agrupa as vendas por cliente.
-- 5. HAVING   → Mantém grupos com gasto acima de R$ 2.000.
-- 6. SELECT   → Calcula COUNT() e SUM() por cliente.
-- 7. ORDER BY → Ordena pelo maior valor gasto.

-- ============================================================
-- QUESTÃO 05 - IDENTIFICAÇÃO DE VENDAS SEM STATUS
-- ============================================================

-- CONTEXTO:
-- Uma empresa precisa identificar vendas que apresentam
-- problemas no registro de seus status, para melhorar
-- o acompanhamento dos pedidos.

-- DESAFIO:
-- Elabore uma consulta SQL que identifique vendas sem
-- registro na tabela status_vendas ou com status NULL.

-- REQUISITOS:
-- 1. Relacionar as quatro tabelas.
-- 2. Exibir: id_venda, data_venda, cliente, produto e status.
-- 3. Remover espaços nas extremidades dos nomes dos produtos.
-- 4. Identificar vendas sem registro de status ou com status NULL.
-- 5. Criar uma coluna situacao_status usando CASE:
--    'SEM REGISTRO' para vendas sem histórico de status;
--    'STATUS NULO' para registros com status NULL.
-- 6. Ordenar pelo id da venda em ordem crescente.

-- ESCREVA SUA CONSULTA SQL ABAIXO:
SELECT
    v.id AS id_venda,
    v.data_venda,
    c.cliente,
    TRIM(p.produto) AS produto,
    s.status,
    CASE
        WHEN s.id IS NULL THEN 'SEM REGISTRO'
        WHEN s.status IS NULL THEN 'STATUS NULO'
    END AS situacao_status
FROM vendas AS v                                                 -- (1) Tabela principal.
INNER JOIN clientes AS c ON v.cliente_id = c.id                  -- (2) Relaciona os clientes.    
INNER JOIN produtos AS p ON v.produto_id = p.id                  -- (2) Relaciona os produtos.    
LEFT JOIN status_vendas AS s ON v.id = s.venda_id                -- (2) Preserva vendas sem status.    
WHERE s.id IS NULL                                               -- (3) Sem registro de status.
   OR s.status IS NULL                                           -- (3) Status nulo.
ORDER BY v.id ASC;                                               -- (5) Ordena por venda.

-- ORDEM LÓGICA DE EXECUÇÃO:
-- 1. FROM     → Identifica a tabela principal.
-- 2. JOIN     → Relaciona as quatro tabelas.
-- 3. WHERE    → Filtra as inconsistências.
-- 4. SELECT   → Exibe colunas e aplica TRIM() e CASE.
-- 5. ORDER BY → Ordena os resultados.


-- ============================================================
-- QUESTÃO 06 - CLIENTES COM GASTOS ACIMA DA MÉDIA
-- ============================================================

-- CONTEXTO:
-- Uma empresa deseja identificar clientes que possuem
-- gastos superiores à média dos clientes em 2026,
-- para orientar suas estratégias comerciais.

-- DESAFIO:
-- Elabore uma consulta SQL que identifique os clientes
-- cujo valor total gasto em 2026 seja superior à média
-- de gastos por cliente no mesmo período.

-- REQUISITOS:
-- 1. Relacionar as tabelas clientes e vendas.
-- 2. Calcular o total gasto por cliente em 2026.
-- 3. Calcular a média desses totais por cliente,
--    utilizando uma CTE ou subconsulta.
-- 4. Exibir: cliente, estado e total_gasto.
-- 5. Considerar apenas vendas com valor_total não nulo.
-- 6. Exibir somente clientes com gasto acima da média.
-- 7. Ordenar pelo maior valor gasto.

-- ESCREVA SUA CONSULTA SQL ABAIXO:

-- QUESTÃO 06 - CLIENTES COM GASTOS ACIMA DA MÉDIA

-- (1) Calcula o total gasto por cliente em 2026.
WITH gastos_clientes AS (
    SELECT
        cliente_id,
        SUM(valor_total) AS total_gasto
    FROM vendas
    WHERE data_venda >= '2026-01-01' AND data_venda < '2027-01-01' AND valor_total IS NOT NULL
    GROUP BY cliente_id
)

-- (2) Consulta os totais calculados.
SELECT
    c.cliente,
    c.estado,
    g.total_gasto
FROM gastos_clientes AS g

-- (3) Relaciona os gastos aos clientes.
INNER JOIN clientes AS c ON g.cliente_id = c.id

-- (4) Filtra clientes com gastos acima da média.
WHERE g.total_gasto > (
    SELECT AVG(total_gasto)
    FROM gastos_clientes
)

-- (5) Ordena pelo maior gasto.
ORDER BY g.total_gasto DESC;


-- ORDEM LÓGICA DE EXECUÇÃO:
-- 1. CTE      → Filtra e agrupa as vendas por cliente.
-- 2. SUM()    → Calcula o total gasto por cliente.
-- 3. FROM     → Consulta os totais calculados.
-- 4. JOIN     → Relaciona os clientes.
-- 5. AVG()    → Calcula a média dos gastos por cliente.
-- 6. WHERE    → Filtra os gastos acima da média.
-- 7. SELECT   → Exibe as colunas.
-- 8. ORDER BY → Ordena pelo maior gasto.


-- ============================================================
-- QUESTÃO 07 - CRIAÇÃO DE VIEW PARA ANÁLISE DE VENDAS
-- ============================================================

-- CONTEXTO:
-- Uma empresa deseja disponibilizar uma base de vendas
-- para consultas diárias utilizando Python e Power BI.

-- DESAFIO:
-- Crie uma VIEW chamada vw_relatorio_vendas que reúna
-- informações das quatro tabelas em uma única consulta.

-- REQUISITOS:
-- 1. Relacionar as quatro tabelas.
-- 2. Exibir os dados dos clientes, produtos, vendas
--    e histórico de status.
-- 3. Remover espaços dos nomes de clientes e produtos.
-- 4. Substituir status NULL por 'SEM STATUS'.
-- 5. Manter as vendas que não possuem status cadastrado.
-- 6. Não utilizar GROUP BY nem funções de agregação.
-- 7. Consultar a VIEW ordenando pelas vendas mais recentes.

-- ESCREVA SUA CONSULTA SQL ABAIXO:

CREATE OR REPLACE VIEW vw_relatorio_vendas AS

SELECT
    v.id AS id_venda,
    v.data_venda,
    TRIM(c.cliente) AS cliente,
    TRIM(c.cidade) AS cidade,
    UPPER(TRIM(c.estado)) AS estado,
    TRIM(p.produto) AS produto,
    v.quantidade,
    p.preco,
    v.valor_total,
    s.data_status,
    COALESCE(UPPER(TRIM(s.status)), 'SEM STATUS') AS status

FROM vendas AS v                                      -- (1) Tabela principal.
INNER JOIN clientes AS c ON v.cliente_id = c.id       -- (2) Relaciona clientes.    
INNER JOIN produtos AS p ON v.produto_id = p.id       -- (3) Relaciona produtos.    
LEFT JOIN status_vendas AS s ON v.id = s.venda_id;    -- (4) Mantém vendas sem status.
    

-- ============================================================
-- CONSULTA DIÁRIA DA VIEW
-- ============================================================

SELECT *
FROM vw_relatorio_vendas
ORDER BY data_venda DESC, id_venda DESC;


-- ORDEM LÓGICA DE EXECUÇÃO:
-- 1. FROM       → Identifica a tabela principal.
-- 2. INNER JOIN → Relaciona clientes e produtos.
-- 3. LEFT JOIN  → Relaciona o histórico de status.
-- 4. SELECT     → Seleciona e trata as colunas.
-- 5. ORDER BY   → Ordena a consulta final da VIEW.