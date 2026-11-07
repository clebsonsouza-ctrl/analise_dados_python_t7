-- =========================================================
-- CRIAÇÃO DE TABELAS NO POSTGRESQL
-- =========================================================

CREATE TABLE exemplo_texto ( -- Cria uma tabela chamada exemplo_texto
	id int, -- Armazena um número inteiro
    sigla_estado CHAR(2), -- Armazena uma sigla de estado com tamanho fixo de 2 caracteres    
    nome_cliente VARCHAR(100), -- Armazena o nome do cliente com até 100 caracteres    
    observacao TEXT -- Armazena textos de tamanho variável, sem limite definido na coluna
);

SELECT * FROM exemplo_texto;

-- INSERIR DADOS
 
INSERT INTO exemplo_texto (
	id,
    sigla_estado,
    nome_cliente,
    observacao
)
VALUES (
	1,
    'SP',
    'Paulo Renan',
    'Cliente realizou uma compra e solicitou entrega no período da tarde.'
),
(	
	2,
    'SC',
    'Marcos luis',
    'Cliente realizou uma compra e solicitou entrega no período da tarde.'
);

SELECT * FROM exemplo_texto;

-------------

CREATE TABLE exemplo_numero ( -- Cria a tabela exemplo_numero
    id SERIAL PRIMARY KEY,    -- Identificador sequencial automático e chave primária
    produto VARCHAR(100),     -- Texto com até 100 caracteres
    quantidade INT,           -- Número inteiro
    preco DECIMAL(10,2),      -- Número decimal com 10 dígitos, sendo 2 casas decimais
    peso_kg DOUBLE PRECISION  -- Número decimal de ponto flutuante
);

INSERT INTO exemplo_numero (produto, quantidade, preco, peso_kg)
VALUES ('Notebook', 2, 3500.90, 1.85);

SELECT * FROM exemplo_numero;

-------------

CREATE TABLE exemplo_data (                          -- Cria a tabela exemplo_data
    criado_em TIMESTAMP DEFAULT CURRENT_TIMESTAMP,   -- Data e hora atuais preenchidas automaticamente
    descricao TEXT,                                  -- Texto de tamanho variável
    data_evento DATE,                                -- Armazena apenas a data (AAAA-MM-DD)
    hora_evento TIME,                                -- Armazena apenas a hora (HH:MM:SS)
    data_hora_evento TIMESTAMP                       -- Armazena data e hora
);

-- Inserção de um registro
INSERT INTO exemplo_data (
    descricao,
    data_evento,
    hora_evento,
    data_hora_evento
)
VALUES (
    'Aula_02',
    '2026-06-22',
    '14:30:00',
    '2026-06-22 14:30:00'
);

-- Consulta dos dados
SELECT * FROM exemplo_data;

----------------

-- ATUALIZAR DADOS

UPDATE exemplo_texto
SET sigla_estado = 'RJ';
WHERE ID = 1; -- atualizar um valor de uma tabela

SELECT * FROM exemplo_texto;

-- DELETAR DADOS

DELETE FROM exemplo_texto
WHERE id = 2;

SELECT * FROM exemplo_texto;

-- ALTERAR TABELA
-- adicionar coluna email
ALTER TABLE exemplo_texto
ADD COLUMN email VARCHAR(255);

SELECT * FROM exemplo_texto;

ALTER TABLE exemplo_texto
ALTER COLUMN nome_cliente TYPE VARCHAR(150);

SELECT * FROM exemplo_texto;

-- TRUNCATE TABLE

-- Remove todos os registros da tabela, mantendo sua estrutura

SELECT * FROM exemplo_data;

TRUNCATE TABLE exemplo_data;

SELECT * FROM exemplo_data;

-- EXCLUIR TABELA

DROP TABLE exemplo_texto;
DROP TABLE exemplo_numero;
DROP TABLE exemplo_data;
DROP TABLE IF EXISTS exemplo_data;

-- =============================================================

-- =========================================================
-- TABELA 1: CLIENTES
-- Armazena as informações dos clientes
-- =========================================================

CREATE TABLE clientes (

    -- Chave primária com numeração automática
    -- Não permite valores nulos nem duplicados
    id SERIAL PRIMARY KEY,

    -- Nome do cliente (obrigatório)
    cliente VARCHAR(100) NOT NULL,

    -- E-mail do cliente (obrigatório)
    email VARCHAR(255) NOT NULL,

    -- Cidade do cliente
    cidade VARCHAR(100),

    -- Estado com dois caracteres
    estado CHAR(2),

    -- Idade do cliente
    idade INTEGER,

    -- Informações adicionais do cliente
    observacoes TEXT,

    -- Data de cadastro do cliente
    data_cadastro DATE,

    -- CONSTRAINT 1: impede e-mails duplicados
    CONSTRAINT uq_clientes_email
        UNIQUE (email)

);

-- =========================================================
-- TABELA 2: PRODUTOS
-- Armazena os produtos comercializados
-- =========================================================

CREATE TABLE produtos (

    -- Chave primária com numeração automática
    id SERIAL PRIMARY KEY,

    -- Nome do produto (obrigatório)
    produto VARCHAR(100) NOT NULL,

    -- Preço do produto com duas casas decimais
    preco NUMERIC(10,2) NOT NULL

);

-- =========================================================
-- TABELA 3: VENDAS
-- Registra as vendas realizadas
-- =========================================================

CREATE TABLE vendas (

    -- Chave primária com numeração automática
    id SERIAL PRIMARY KEY,

    -- Data da venda
    data_venda DATE,

    -- Horário da venda
    hora_venda TIME,

    -- Data e hora do registro
    data_hora_registro TIMESTAMP,

    -- Chave estrangeira do cliente
    -- Pode se repetir em diferentes vendas
    cliente_id INTEGER NOT NULL,

    -- Chave estrangeira do produto
    -- Pode se repetir em diferentes vendas
    produto_id INTEGER NOT NULL,

    -- Quantidade de produtos vendidos
    quantidade INTEGER,

    -- Valor total da venda
    valor_total NUMERIC(10,2),

    -- Relaciona a venda com um cliente existente
    CONSTRAINT fk_vendas_clientes
        FOREIGN KEY (cliente_id)
        REFERENCES clientes(id),

    -- Relaciona a venda com um produto existente
    CONSTRAINT fk_vendas_produtos
        FOREIGN KEY (produto_id)
        REFERENCES produtos(id),

    -- CONSTRAINT 2: impede valores negativos
    CONSTRAINT ck_vendas_valor
        CHECK (valor_total >= 0)

);

-- =========================================================
-- TABELA 4: STATUS_VENDAS
-- Armazena o histórico de status das vendas
-- =========================================================

CREATE TABLE status_vendas (

    -- Chave primária com numeração automática
    id SERIAL PRIMARY KEY,

    -- Chave estrangeira da venda
    -- Pode se repetir para diferentes atualizações
    venda_id INTEGER NOT NULL,

    -- Data da atualização do status
    data_status DATE,

    -- Situação da venda
    -- Exemplos: Pendente, Pago, Cancelado
    status VARCHAR(20),

    -- Relaciona o status com uma venda existente
    CONSTRAINT fk_status_vendas
        FOREIGN KEY (venda_id)
        REFERENCES vendas(id)

);

----------------------------------------------------------


-- =====================================================
-- INSERÇÃO DE 20 CLIENTES
-- Tabela: clientes
-- =====================================================

-- O id será gerado automaticamente pelo SERIAL
-- Alguns registros apresentam inconsistências intencionais

INSERT INTO clientes
    (cliente, email, cidade, estado, idade,
     observacoes, data_cadastro)
VALUES
    
    ('Ana Martins', 'ana.martins@gmail.com', 'Joinville', 'SC', 28, NULL, '2025-09-10'),    
    ('Bruno Lima', 'bruno.lima@outlook.com', 'Blumenau', 'SC', 42, NULL, '2025-10-01'),    
    ('  Carla Weber  ', ' carla.weber@gmail.com ', 'Florianópolis', 'SC', 32, 'Cliente frequente', '2025-11-22'),
    ('Diego Ribeiro', 'diego.ribeiro@yahoo.com', 'Chapecó', 'SC', 25, NULL, '2025-12-01'),
    ('Elisa Souza', 'elisa.souza@outlook.com', 'Itajaí', 'SC', 52, 'Cliente empresarial', '2025-12-15'),    
    ('fernanda müller', 'fernanda.muller@gmail.com', ' Criciúma ', 'SC', 37, NULL, '2026-01-12'),    
    ('Gustavo Oliveira', 'gustavo.oliveira@gmail.com', 'Curitiba', 'PR', 22, NULL, '2026-01-31'),    
    ('Helena Prado', 'helena.prado@outlook.com', 'São Paulo', 'SP', 30, NULL, '2026-02-15'),
    ('Igor Santos', 'igor.santos@gmail.com', 'Campinas', 'SP', 45, 'Cliente frequente', '2026-02-20'),    
    ('Júlia Carvalho', 'julia.carvalho@yahoo.com', 'Belo Horizonte', 'MG', 34, NULL, '2026-03-01'),
    ('Lucas Almeida', 'lucas.almeida@outlook.com', 'Uberlândia', 'MG', 62, NULL, '2026-03-10'),    
    ('Marina Costa', 'marina.costa@gmail.com', 'Porto Alegre', 'RS', 29, NULL, '2026-04-01'),    
    ('Natália Pires', 'natalia.pires@gmail.com', 'Recife', 'PE', 41, NULL, '2026-04-15'),
    ('Otávio Ferreira', 'otavio.ferreira@outlook.com', 'Olinda', 'PE', 26, NULL, '2026-04-30'),    
    ('Patrícia Nunes', 'patricia.nunes@gmail.com', 'Rio de Janeiro', 'RJ', 50, NULL, '2026-05-01'),    
    ('Rafael Teixeira', 'rafael.teixeira@outlook.com', 'São José', 'SC', 31, NULL, '2026-05-18'),    
    ('Sofia Andrade', 'SOFIA.ANDRADE@GMAIL.COM', NULL, 'SC', NULL, NULL, '2026-07-10'),    
    ('Thiago  Costa', '', 'São Paulo', 'SP', 20, NULL, NULL),    
    ('Valéria Souza', 'valeria.souza@yahoo.com', 'Juiz de Fora', 'MG', 38, NULL, '2026-06-01'),    
    ('William Rocha', 'william.rocha@gmail.com', 'Lages', 'sc', 43, NULL, '2026-05-03');


-- =====================================================
-- INSERÇÃO DE 12 PRODUTOS
-- Tabela: produtos
-- =====================================================

-- O id será gerado automaticamente
-- Alguns nomes possuem espaços e letras inconsistentes

INSERT INTO produtos (produto, preco)
VALUES
    
    ('Notebook 15 Polegadas', 3499.90),
    ('Mouse Sem Fio', 75.90),
    ('Teclado Mecânico', 299.90),    
    ('  SSD 500GB  ', 389.90),
    ('Monitor 24 Polegadas', 899.00),
    ('Cadeira Ergonômica', 1299.90),
    ('Fone Bluetooth', 199.99),
    ('Impressora Laser', 1590.00),
    ('Cabo HDMI 2m', 39.90),    
    ('Webcam Full HD', 249.00),
    ('HD Externo 1TB', 450.00),    
    ('suporte para notebook  ', 89.90);

-- =====================================================
-- INSERÇÃO DE 30 VENDAS
-- Tabela: vendas
-- =====================================================

-- cliente_id referencia a tabela clientes
-- produto_id referencia a tabela produtos
-- As chaves estrangeiras podem se repetir
-- Os IDs consideram as tabelas inicialmente vazias

INSERT INTO vendas
    (cliente_id, produto_id, data_venda,
     hora_venda, data_hora_registro,
     quantidade, valor_total)
VALUES

    
    (1, 1, '2025-11-18', '09:10:00', '2025-11-18 09:10:00', 1, 3499.90),
    (1, 2, '2025-12-02', '14:40:00', '2025-12-02 14:40:00', 2, 151.80),    
    (3, 4, '2026-01-10', '10:15:00', '2026-01-10 10:15:00', 3, 1169.70),
    (4, 9, '2026-01-18', '11:20:00', '2026-01-18 11:20:00', 5, 199.50),    
    (5, 6, '2026-02-03', '16:35:00', '2026-02-03 16:35:00', 2, 2599.80),
    (6, 3, '2026-02-14', '13:50:00', '2026-02-14 13:50:00', 2, 599.80),    
    (7, 7, '2026-03-02', '09:05:00', '2026-03-02 09:05:00', 4, 799.96),
    (8, 5, '2026-03-10', '15:40:00', '2026-03-10 15:40:00', 3, 2697.00),
    (9, 8, '2026-03-22', '14:00:00', '2026-03-22 14:00:00', 2, 3180.00),    
    (10, 1, '2026-04-04', '10:10:00', '2026-04-04 10:10:00', 1, 3499.90),
    (11, 11, '2026-04-12', '17:20:00', '2026-04-12 17:20:00', 5, 2250.00),
    (12, 4, '2026-04-19', '12:25:00', '2026-04-19 12:25:00', 1, 389.90),    
    (13, 6, '2026-05-02', '08:30:00', '2026-05-02 08:30:00', 1, 1299.90),
    (14, 9, '2026-05-09', '16:15:00', '2026-05-09 16:15:00', 10, 399.00),    
    (15, 2, '2026-05-20', '11:50:00', NULL, 3, 227.70),    
    (16, 5, '2026-06-01', '09:40:00', '2026-06-01 09:40:00', 2, 1798.00),
    (18, 3, '2026-06-10', '13:00:00', '2026-06-10 13:00:00', 2, 599.80),
    (19, 11, '2026-06-18', '18:00:00', '2026-06-18 18:00:00', 2, 900.00),
    (20, 7, '2026-06-24', '08:10:00', '2026-06-24 08:10:00', 1, 199.99),    
    (1, 8, '2026-07-03', '14:20:00', '2026-07-03 14:20:00', 1, 1590.00),
    (3, 5, '2026-07-11', '10:55:00', '2026-07-11 10:55:00', 1, 899.00),
    (5, 1, '2026-07-21', '16:30:00', '2026-07-21 16:30:00', 2, 6999.80),    
    (8, 6, '2026-08-05', '12:45:00', '2026-08-05 12:45:00', 1, 1299.90),
    (10, 2, '2026-08-17', '09:35:00', '2026-08-17 09:35:00', 6, 455.40),
    (13, 3, '2026-08-25', '15:05:00', '2026-08-25 15:05:00', 4, 1199.60),    
    (17, 1, '2026-09-04', '10:20:00', '2026-09-04 10:20:00', 1, 3499.90),    
    (19, 9, '2026-09-12', '14:10:00', '2026-09-12 14:10:00', NULL, NULL),
    (20, 4, '2026-09-20', '11:15:00', '2026-09-20 11:15:00', 3, 1169.70),    
    (16, 11, '2026-10-02', '16:50:00', '2026-10-02 16:50:00', 2, 900.00),
    (18, 12, '2026-10-18', '09:25:00', '2026-10-18 09:25:00', 5, 449.50);



-- =====================================================
-- INSERÇÃO DE 35 REGISTROS DE STATUS
-- Tabela: status_vendas
-- =====================================================

-- O venda_id referencia a chave primária de vendas
-- Uma venda pode possuir vários registros de status
-- Alguns status apresentam inconsistências intencionais

INSERT INTO status_vendas
    (venda_id, data_status, status)
VALUES

    
    (1, '2025-11-18', 'PENDENTE'),
    (1, '2025-11-19', 'PAGO'),
    (1, '2025-11-23', 'ENTREGUE'),    
    (2, '2025-12-04', 'ENTREGUE'),    
    (3, '2026-01-10', 'PAGO'),
    (3, '2026-01-14', 'ENTREGUE'),    
    (4, '2026-01-19', 'CANCELADO'),    
    (5, '2026-02-03', 'PAGO'),
    (5, '2026-02-08', 'ENTREGUE'),    
    (6, '2026-02-14', 'PENDENTE'),
    (7, '2026-03-05', 'ENTREGUE'),    
    (8, '2026-03-10', 'PAGO'),
    (8, '2026-03-14', 'ENTREGUE'),    
    (9, '2026-03-26', 'ENTREGUE'),
    (10, '2026-04-09', 'ENTREGUE'),
    (11, '2026-04-14', 'ENVIADO'),
    (12, '2026-04-23', 'ENTREGUE'),    
    (13, '2026-05-02', 'pago'),
    (13, '2026-05-07', 'entregue'),    
    (14, '2026-05-10', 'CANCELADO'),
    (15, '2026-05-20', 'PENDENTE'),
    (16, '2026-06-05', 'ENTREGUE'),
    (17, '2026-06-13', 'ENTREGUE'),    
    (18, '2026-06-22', 'ENTREGUE '),    
    (19, '2026-06-24', 'PAGO'),
    (20, '2026-07-07', 'ENTREGUE'),
    (21, '2026-07-15', 'ENTREGUE'),
    (22, '2026-07-26', 'ENTREGUE'),    
    (23, '2026-08-05', 'PENDENTE'),
    (24, '2026-08-19', 'ENTREGUE'),
    (25, '2026-08-29', 'ENTREGUE'),
    (26, '2026-09-06', 'ENVIADO'),
    (27, '2026-09-13', 'PENDENTE'),    
    (28, '2026-09-21', NULL),    
    (29, NULL, 'PAGO');

-- A venda 30 permanece sem registro de status
-- Isso permitirá demonstrar resultados com LEFT JOIN

SELECT * FROM clientes;
SELECT * FROM produtos;
SELECT * FROM vendas;
SELECT * FROM status_vendas;