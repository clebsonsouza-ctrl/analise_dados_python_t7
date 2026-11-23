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














