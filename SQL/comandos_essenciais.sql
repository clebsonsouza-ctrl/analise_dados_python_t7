-- COMANDOS ESSENCIAIS 

-- COMANDOS DE SELEÇÃO --
SELECT * FROM clientes;

SELECT * FROM produtos;

SELECT * FROM vendas;

SELECT * FROM status_vendas;

-- Seleciona os 5 primeiros registros da tabela `status_vendas`.
SELECT * FROM status_vendas 
LIMIT 5;

-- Seleciona apenas os status diferentes existentes na tabela `status_vendas`, sem repetir valores.
SELECT DISTINCT status FROM status_vendas;

-- Seleciona os nomes dos clientes e suas cidades.
SELECT cliente, 
	   cidade
FROM clientes;

-- Seleciona os nomes dos clientes e suas cidades, renomeando as colunas exibidas como `Clientes` e `Municípios`.
SELECT cliente AS Clientes, 
	   cidade AS Municípios 
FROM clientes;

-- Seleciona 5 registros da tabela vendas, ignorando os 5 primeiros resultados.
SELECT * FROM vendas
LIMIT 5
OFFSET 5;

-- 

-- COMANDOS DE ORDENAÇÃO --

--Seleciona todas as vendas, ordenando da data mais recente para a mais antiga.
SELECT * FROM vendas
ORDER BY data_venda DESC;

-- 

-- COMANDOS DE FILTRAGENS

-- Seleciona todos os clientes que moram no estado de Santa Catarina (SC).
SELECT * FROM clientes
WHERE estado = 'SC';

-- Seleciona todos os clientes de Santa Catarina (`SC`) com idade menor ou igual a 30 anos.
SELECT * FROM clientes
WHERE estado = 'SC' AND idade <= 30;

-- Seleciona todos os clientes que moram em Santa Catarina (`SC`) ou São Paulo (`SP`).
SELECT * FROM clientes
WHERE estado = 'SC' OR estado = 'SP';

-- Seleciona todos os clientes que moram nos estados de São Paulo (`SP`), Pernambuco (`PE`) ou Santa Catarina (`SC`).
SELECT * FROM clientes
WHERE estado IN ('SP', 'PE', 'SC');

-- Seleciona clientes com idade entre 30 e 50 anos,
-- exibindo cliente, cidade e estado com nomes de colunas personalizados.
SELECT cliente AS Clientes,
		cidade AS Município,
        estado AS UF        
FROM clientes
WHERE idade BETWEEN 30 AND 50;

-- Seleciona o cliente e o e-mail dos clientes cujo e-mail contém `gmail`.
SELECT cliente, email FROM clientes
WHERE email LIKE '%gmail%';

-- Seleciona o cliente e o e-mail dos clientes cujo e-mail contém `gmail` ou `outlook`.
SELECT cliente, email FROM clientes
WHERE email LIKE '%gmail%' OR email LIKE '%outlook%';

-- Seleciona clientes cuja idade termina com o número 2, convertendo a idade para texto.
SELECT cliente, email, idade
FROM clientes
WHERE idade::TEXT LIKE '%2'; -- termina com 2

-- Seleciona clientes cuja idade começa com o número `2`, convertendo a idade para texto.
SELECT cliente, email, idade FROM clientes
WHERE idade ::TEXT LIKE '2%'; -- começa com 2

-- Seleciona todos os clientes que não possuem idade cadastrado.
SELECT * 
FROM clientes
WHERE idade IS NULL;

-- 

-- FUNÇOES MATEMÁTICAS

-- Conta o total de registros existentes na tabela `clientes`.
SELECT count(*) FROM clientes;

-- Conta quantos status diferentes existem na tabela `status_vendas`.
SELECT count(DISTINCT status) FROM status_vendas;

-- Soma todas as quantidades registradas na tabela `vendas`.
SELECT SUM(quantidade) FROM vendas;

-- Calcula a média das idades dos clientes e arredonda o resultado para 2 casas decimais.
SELECT round(AVG(idade), 2) FROM clientes;

-- Retorna o menor e o maior preço cadastrados na tabela `produtos`.
SELECT MIN(preco), MAX(preco) FROM produtos;

-- FUNÇÕES DE TRATAMENTO

-- UPPER (tudo maiúsculo)

-- Mostra o nome original dos produtos e uma versão em letras maiúsculas.
SELECT 
	produto AS produto_original,
    UPPER(produto) AS produto_maiusculo
FROM produtos;

-- LOWER (tudo minúsculo)

-- Mostra o nome original dos produtos e uma versão em letras minúsculas.
SELECT 
	produto AS produto_original,
    LOWER(produto) AS produto_minusculo
FROM produtos;

-- CONCAT (junta textos)

-- Concatena o nome do produto, o texto `R$` e o preço em uma única informação do produto.
SELECT  
	id,
    CONCAT(produto, ' - ', 'R$', preco) AS info_produto
FROM produtos;

-- COALESCE (trata valores null)

-- Mostra o campo "observacoes" original e substitui valores nulos por `Sem informação`.
SELECT observacoes,
    COALESCE(observacoes, 'Sem informação') AS observacoes_tratada
FROM clientes;

-- TRIM (remove espaços)

-- Mostra todos os dados dos produtos e cria uma coluna com o nome do produto sem espaços no início e no fim.
SELECT *,
 TRIM(produto) AS prod_tratado
 FROM produtos;

-- REPLACE (substitui texto)

-- Mostra todos os produtos e cria uma coluna substituindo `SSD 500GB` por `SSD 250GB`.
SELECT 
    *,
    REPLACE(produto, 'SSD 500GB', 'SSD 250GB') AS prod_corrigido
FROM produtos;

-- SUBSTRING (extrair parte do texto) - EXTRAIR O ANO

-- Mostra todas as vendas e cria uma coluna com o ano extraído da data da venda.
SELECT *,
SUBSTRING(data_venda::TEXT,1,4) AS ano
FROM vendas;

-- função DATE_TRUNC()

-- SELECT
--     data_venda,
--     DATE_TRUNC('month', data_venda) AS mes_venda
-- FROM vendas;

-- SPLIT_PART (a partir de um caracter) - antes do arroba

-- Mostra o e-mail e extrai a parte antes do @, identificando o usuário do e-mail.
SELECT 
    email,
    SPLIT_PART(email, '@', 1) AS usuario
FROM clientes;

-- 
