-- ==========================================================
-- CAMADA RAW
-- Armazena os dados brutos provenientes dos arquivos CSV.
-- Todas as colunas são inicialmente definidas como VARCHAR.
-- ==========================================================


-- TABELA DE DESLOCAMENTOS

DROP TABLE IF EXISTS raw_deslocamentos;

CREATE TABLE raw_deslocamentos (
    id_viagem              VARCHAR(20),    -- Identificador da viagem.
    num_proposta           VARCHAR(20),    -- Número da proposta.
    situacao               VARCHAR(50),    -- Situação da viagem.
    viagem_urgente         VARCHAR(5),     -- Indicador de urgência.
    justificativa_urgencia VARCHAR(4000),  -- Justificativa da urgência.
    cod_orgao_superior     VARCHAR(20),    -- Código do órgão superior.
    nome_orgao_superior    VARCHAR(255),   -- Nome do órgão superior.
    cod_orgao_solicitante  VARCHAR(20),    -- Código do órgão solicitante.
    nome_orgao_solicitante VARCHAR(255),   -- Nome do órgão solicitante.
    cpf_viajante           VARCHAR(20),    -- CPF do viajante.
    nome_viajante          VARCHAR(255),   -- Nome do viajante.
    cargo                  VARCHAR(255),   -- Cargo do viajante.
    funcao                 VARCHAR(255),   -- Função do viajante.
    descricao_funcao       VARCHAR(255),   -- Descrição da função.
    data_inicio            VARCHAR(10),    -- Data inicial da viagem.
    data_fim               VARCHAR(10),    -- Data final da viagem.
    destinos               VARCHAR(4000),  -- Destinos da viagem.
    motivo                 VARCHAR(4000),  -- Motivo da viagem.
    valor_diarias          VARCHAR(30),    -- Valor das diárias.
    valor_passagens        VARCHAR(30),    -- Valor das passagens.
    valor_devolucao        VARCHAR(30),    -- Valor das devoluções.
    valor_outros_gastos    VARCHAR(30)     -- Valor dos demais gastos.
);


-- TABELA DE GASTOS

DROP TABLE IF EXISTS raw_gastos;

CREATE TABLE raw_gastos (
    id_viagem           VARCHAR(20),   -- Identificador da viagem.
    num_proposta        VARCHAR(20),   -- Número da proposta.
    cod_orgao_superior  VARCHAR(20),   -- Código do órgão superior.
    nome_orgao_superior VARCHAR(255),  -- Nome do órgão superior.
    cod_orgao_pagador   VARCHAR(20),   -- Código do órgão pagador.
    nome_orgao_pagador  VARCHAR(255),  -- Nome do órgão pagador.
    cod_ug_pagadora     VARCHAR(20),   -- Código da unidade gestora pagadora.
    nome_ug_pagadora    VARCHAR(255),  -- Nome da unidade gestora pagadora.
    tipo_pagamento      VARCHAR(50),   -- Tipo de pagamento realizado.
    valor               VARCHAR(30)   -- Valor do pagamento.
);


-- TABELA DE EMBARQUES

DROP TABLE IF EXISTS raw_embarques;

CREATE TABLE raw_embarques (
    id_viagem            VARCHAR(20),  -- Identificador da viagem.
    num_proposta         VARCHAR(20),  -- Número da proposta.
    meio_transporte      VARCHAR(50),  -- Meio de transporte utilizado.
    pais_origem_ida      VARCHAR(60),  -- País de origem da ida.
    uf_origem_ida        VARCHAR(40),  -- UF de origem da ida.
    cidade_origem_ida    VARCHAR(80),  -- Cidade de origem da ida.
    pais_destino_ida     VARCHAR(60),  -- País de destino da ida.
    uf_destino_ida       VARCHAR(40),  -- UF de destino da ida.
    cidade_destino_ida   VARCHAR(80),  -- Cidade de destino da ida.
    pais_origem_volta    VARCHAR(60),  -- País de origem da volta.
    uf_origem_volta      VARCHAR(40),  -- UF de origem da volta.
    cidade_origem_volta  VARCHAR(80),  -- Cidade de origem da volta.
    pais_destino_volta   VARCHAR(60),  -- País de destino da volta.
    uf_destino_volta     VARCHAR(40),  -- UF de destino da volta.
    cidade_destino_volta VARCHAR(80),  -- Cidade de destino da volta.
    valor_passagem       VARCHAR(30),  -- Valor da passagem.
    taxa_servico         VARCHAR(30),  -- Valor da taxa de serviço.
    data_emissao         VARCHAR(10),  -- Data de emissão da passagem.
    hora_emissao         VARCHAR(8)    -- Hora de emissão da passagem.
);


-- TABELA DE TRAJETOS

DROP TABLE IF EXISTS raw_trajetos;

CREATE TABLE raw_trajetos (
    id_viagem        VARCHAR(20),  -- Identificador da viagem.
    num_proposta     VARCHAR(20),  -- Número da proposta.
    sequencia_trecho VARCHAR(10),  -- Ordem do trecho na viagem.
    origem_data      VARCHAR(10),  -- Data de saída do trecho.
    origem_pais      VARCHAR(60),  -- País de origem.
    origem_uf        VARCHAR(40),  -- UF de origem.
    origem_cidade    VARCHAR(80),  -- Cidade de origem.
    destino_data     VARCHAR(10),  -- Data de chegada ao destino.
    destino_pais     VARCHAR(60),  -- País de destino.
    destino_uf       VARCHAR(40),  -- UF de destino.
    destino_cidade   VARCHAR(80),  -- Cidade de destino.
    meio_transporte  VARCHAR(50),  -- Meio de transporte utilizado.
    numero_diarias   VARCHAR(30),  -- Quantidade de diárias.
    missao           VARCHAR(5)    -- Indicador de missão.
);

-- ==========================================================
-- CAMADA SILVER
-- Armazena os dados limpos, padronizados e transformados.
-- Utiliza tipos adequados e restrições de integridade.
-- ==========================================================


-- Exclui primeiro as tabelas dependentes para evitar
-- conflitos com as restrições de chaves estrangeiras.

DROP TABLE IF EXISTS silver_trajetos;
DROP TABLE IF EXISTS silver_embarques;
DROP TABLE IF EXISTS silver_gastos;
DROP TABLE IF EXISTS silver_deslocamentos;


-- ==========================================================
-- TABELA PRINCIPAL: DESLOCAMENTOS
-- ==========================================================

CREATE TABLE silver_deslocamentos (
    id_viagem              VARCHAR(20) NOT NULL,  -- Identificador obrigatório.
    num_proposta           VARCHAR(20),           -- Número da proposta.
    situacao               VARCHAR(50),           -- Situação da viagem.
    viagem_urgente         VARCHAR(5),            -- Indicador de urgência.
    cod_orgao_superior     VARCHAR(20),           -- Código do órgão superior.
    nome_orgao_superior    VARCHAR(255) NOT NULL, -- Nome obrigatório do órgão.
    cod_orgao_solicitante  VARCHAR(20),           -- Código do órgão solicitante.
    nome_orgao_solicitante VARCHAR(255),          -- Nome do órgão solicitante.
    nome_viajante          VARCHAR(255),          -- Nome do viajante.
    cargo                  VARCHAR(255),          -- Cargo do viajante.
    data_inicio            DATE,                 -- Data inicial da viagem.
    data_fim               DATE,                 -- Data final da viagem.
    destinos               VARCHAR(4000),         -- Destinos da viagem.
    motivo                 VARCHAR(4000),         -- Motivo da viagem.
    valor_diarias          NUMERIC(10,2),         -- Valor das diárias.
    valor_passagens        NUMERIC(10,2),         -- Valor das passagens.
    valor_devolucao        NUMERIC(10,2),         -- Valor das devoluções.
    valor_outros_gastos    NUMERIC(10,2),         -- Valor dos demais gastos.

    -- NOVAS COLUNAS: calculadas durante o ETL.
    valor_total            NUMERIC(12,2),         -- Valor total da viagem.
    duracao_dias           INTEGER,               -- Duração da viagem em dias.

    -- Define o identificador único de cada viagem.
    PRIMARY KEY (id_viagem),

    -- Impede valores negativos para as diárias.
    CONSTRAINT chk_deslocamentos_diarias
        CHECK (valor_diarias >= 0)
);


-- ==========================================================
-- TABELA DEPENDENTE: GASTOS
-- ==========================================================

CREATE TABLE silver_gastos (

    -- NOVA COLUNA: identificador gerado automaticamente.
    id_pagamento        SERIAL,

    id_viagem           VARCHAR(20) NOT NULL,  -- Identificador da viagem.
    num_proposta        VARCHAR(20),           -- Número da proposta.
    nome_orgao_pagador  VARCHAR(255),          -- Nome do órgão pagador.
    nome_ug_pagadora    VARCHAR(255),          -- Nome da unidade gestora.
    tipo_pagamento      VARCHAR(50) NOT NULL,  -- Tipo de pagamento obrigatório.
    valor               NUMERIC(10,2),         -- Valor do pagamento.

    -- Define o identificador único de cada pagamento.
    PRIMARY KEY (id_pagamento),

    -- Relaciona o pagamento à tabela principal.
    FOREIGN KEY (id_viagem)
        REFERENCES silver_deslocamentos(id_viagem),

    -- Impede pagamentos com valores negativos.
    CONSTRAINT chk_gastos_valor
        CHECK (valor >= 0)
);


-- ==========================================================
-- TABELA DEPENDENTE: EMBARQUES
-- ==========================================================

CREATE TABLE silver_embarques (

    -- NOVA COLUNA: identificador gerado automaticamente.
    id_passagem        SERIAL,

    id_viagem          VARCHAR(20) NOT NULL,  -- Identificador da viagem.
    meio_transporte    VARCHAR(50),           -- Meio de transporte utilizado.
    pais_origem_ida    VARCHAR(60),           -- País de origem.
    uf_origem_ida      VARCHAR(40),           -- UF de origem.
    cidade_origem_ida  VARCHAR(80),           -- Cidade de origem.
    pais_destino_ida   VARCHAR(60),           -- País de destino.
    uf_destino_ida     VARCHAR(40),           -- UF de destino.
    cidade_destino_ida VARCHAR(80),           -- Cidade de destino.
    valor_passagem     NUMERIC(10,2),         -- Valor da passagem.
    taxa_servico       NUMERIC(10,2),         -- Valor da taxa de serviço.
    data_emissao       DATE,                 -- Data de emissão da passagem.

    -- Define o identificador único de cada passagem.
    PRIMARY KEY (id_passagem),

    -- Relaciona a passagem à tabela principal.
    FOREIGN KEY (id_viagem)
        REFERENCES silver_deslocamentos(id_viagem),

    -- Impede valores negativos para as passagens.
    CONSTRAINT chk_embarques_valor
        CHECK (valor_passagem >= 0),

    -- Impede valores negativos para as taxas de serviço.
    CONSTRAINT chk_embarques_taxa
        CHECK (taxa_servico >= 0)
);


-- ==========================================================
-- TABELA DEPENDENTE: TRAJETOS
-- ==========================================================

CREATE TABLE silver_trajetos (

    -- NOVA COLUNA: identificador gerado automaticamente.
    id_trecho        SERIAL,

    id_viagem        VARCHAR(20) NOT NULL,  -- Identificador da viagem.
    sequencia_trecho INTEGER,              -- Ordem do trecho na viagem.
    origem_data      DATE,                 -- Data de saída.
    origem_uf        VARCHAR(40),           -- UF de origem.
    origem_cidade    VARCHAR(80),           -- Cidade de origem.
    destino_data     DATE,                 -- Data de chegada.
    destino_uf       VARCHAR(40),           -- UF de destino.
    destino_cidade   VARCHAR(80),           -- Cidade de destino.
    meio_transporte  VARCHAR(50),           -- Meio de transporte utilizado.
    numero_diarias   NUMERIC(10,2),         -- Quantidade de diárias.

    -- Define o identificador único de cada trecho.
    PRIMARY KEY (id_trecho),

    -- Relaciona o trecho à tabela principal.
    FOREIGN KEY (id_viagem)
        REFERENCES silver_deslocamentos(id_viagem),

    -- Impede quantidades negativas de diárias.
    CONSTRAINT chk_trajetos_diarias
        CHECK (numero_diarias >= 0),

    -- Impede a repetição da sequência de trecho na mesma
    -- viagem, quando a sequência estiver preenchida.
    CONSTRAINT uq_trajetos
        UNIQUE (id_viagem, sequencia_trecho)
);


-- SELECT * FROM raw_deslocamentos;
-- SELECT * FROM raw_gastos;
-- SELECT * FROM raw_trajetos;
-- SELECT * FROM raw_embarques;

-- SELECT * FROM silver_deslocamentos;
-- SELECT * FROM silver_gastos;
-- SELECT * FROM silver_trajetos;
-- SELECT * FROM silver_embarques;

-- ==========================================================
-- EXCLUIR AS TABELAS SILVER
-- Primeiro as tabelas dependentes, depois a tabela principal.
-- ==========================================================

-- DROP TABLE IF EXISTS silver_trajetos;
-- DROP TABLE IF EXISTS silver_embarques;
-- DROP TABLE IF EXISTS silver_gastos;
-- DROP TABLE IF EXISTS silver_deslocamentos;


-- -- ==========================================================
-- -- EXCLUIR AS TABELAS RAW
-- -- Essas tabelas não possuem chaves estrangeiras.
-- -- ==========================================================

-- DROP TABLE IF EXISTS raw_trajetos;
-- DROP TABLE IF EXISTS raw_embarques;
-- DROP TABLE IF EXISTS raw_gastos;
-- DROP TABLE IF EXISTS raw_deslocamentos;





