import banco


# 1) Esvaziar as tabelas SILVER (idempotencia).
#    A ordem importa por causa das FKs: apagamos as filhas antes da principal.
LIMPAR_SILVER = [
    "DELETE FROM silver_trajetos",
    "DELETE FROM silver_embarques",
    "DELETE FROM silver_gastos",
    "DELETE FROM silver_deslocamentos",
]

# 2) Copiar RAW -> SILVER convertendo os tipos.

SQL_DESLOCAMENTOS = """
INSERT INTO silver_deslocamentos (
    id_viagem, num_proposta, situacao, viagem_urgente,
    cod_orgao_superior, nome_orgao_superior,
    cod_orgao_solicitante, nome_orgao_solicitante,
    nome_viajante, cargo, data_inicio, data_fim, destinos, motivo,
    valor_diarias, valor_passagens, valor_devolucao, valor_outros_gastos
)
SELECT -- Busca os registros existentes em raw_deslocamentos
    id_viagem, num_proposta, situacao, viagem_urgente,
    cod_orgao_superior, nome_orgao_superior,
    cod_orgao_solicitante, nome_orgao_solicitante,
    nome_viajante, cargo,
    TO_DATE(NULLIF(TRIM(data_inicio), ''), 'DD/MM/YYYY'),
    TO_DATE(NULLIF(TRIM(data_fim), ''), 'DD/MM/YYYY'),
    destinos, motivo,
    CAST(REPLACE(REPLACE(NULLIF(TRIM(valor_diarias),       ''), '.', ''), ',', '.') AS NUMERIC(10,2)), -- converte para texto em valor brasileiro. depois converte para decimal
    CAST(REPLACE(REPLACE(NULLIF(TRIM(valor_passagens),     ''), '.', ''), ',', '.') AS NUMERIC(10,2)),
    CAST(REPLACE(REPLACE(NULLIF(TRIM(valor_devolucao),     ''), '.', ''), ',', '.') AS NUMERIC(10,2)),
    CAST(REPLACE(REPLACE(NULLIF(TRIM(valor_outros_gastos), ''), '.', ''), ',', '.') AS NUMERIC(10,2))
FROM raw_deslocamentos
ON CONFLICT (id_viagem) DO NOTHING -- Caso já exista uma viagem com o mesmo id_viagem, o PostgreSQL não insere uma nova linha e não gera erro.
"""

SQL_GASTOS = """
INSERT INTO silver_gastos (
    id_viagem, num_proposta, nome_orgao_pagador, nome_ug_pagadora, tipo_pagamento, valor
)
SELECT
    id_viagem, num_proposta, nome_orgao_pagador, nome_ug_pagadora, tipo_pagamento,
    CAST(REPLACE(REPLACE(NULLIF(TRIM(valor), ''), '.', ''), ',', '.') AS NUMERIC(10,2))
FROM raw_gastos
WHERE id_viagem IN (SELECT id_viagem FROM silver_deslocamentos)
"""

SQL_EMBARQUES = """
INSERT INTO silver_embarques (
    id_viagem, meio_transporte,
    pais_origem_ida, uf_origem_ida, cidade_origem_ida,
    pais_destino_ida, uf_destino_ida, cidade_destino_ida,
    valor_passagem, taxa_servico, data_emissao
)
SELECT
    id_viagem, meio_transporte,
    pais_origem_ida, uf_origem_ida, cidade_origem_ida,
    pais_destino_ida, uf_destino_ida, cidade_destino_ida,
    CAST(REPLACE(REPLACE(NULLIF(TRIM(valor_passagem), ''), '.', ''), ',', '.') AS NUMERIC(10,2)),
    CAST(REPLACE(REPLACE(NULLIF(TRIM(taxa_servico),   ''), '.', ''), ',', '.') AS NUMERIC(10,2)),
    TO_DATE(NULLIF(TRIM(data_emissao), ''), 'DD/MM/YYYY')
FROM raw_embarques
WHERE id_viagem IN (SELECT id_viagem FROM silver_deslocamentos)
"""

SQL_TRAJETOS = """
INSERT INTO silver_trajetos (
    id_viagem, sequencia_trecho,
    origem_data, origem_uf, origem_cidade,
    destino_data, destino_uf, destino_cidade,
    meio_transporte, numero_diarias
)
SELECT
    id_viagem,
    CAST(NULLIF(TRIM(sequencia_trecho), '') AS INTEGER),
    TO_DATE(NULLIF(TRIM(origem_data), ''), 'DD/MM/YYYY'), origem_uf, origem_cidade,
    TO_DATE(NULLIF(TRIM(destino_data), ''), 'DD/MM/YYYY'), destino_uf, destino_cidade,
    meio_transporte,
    CAST(REPLACE(REPLACE(NULLIF(TRIM(numero_diarias), ''), '.', ''), ',', '.') AS NUMERIC(10,2))
FROM raw_trajetos
WHERE id_viagem IN (SELECT id_viagem FROM silver_deslocamentos)
"""

# 3) Calcular as colunas derivadas de silver_viagem.
#   valor_total = valor_diarias + valor_passagens + valor_outros_gastos - valor_devolucao
SQL_CALCULOS = """
UPDATE silver_deslocamentos
SET valor_total = COALESCE(valor_diarias, 0) -- Caso seja NULL, retorna zero.
                + COALESCE(valor_passagens, 0)
                + COALESCE(valor_outros_gastos, 0)
                - COALESCE(valor_devolucao, 0),
    duracao_dias = (data_fim - data_inicio)
"""


def main(): #Cria a função principal responsável por controlar todas as etapas.

    # responsável por coordenar todas as etapas de transformação e carregamento da camada Silver,
    #  executando os comandos SQL definidos anteriormente.


    print("=== FASE 2: TRANSFORMACAO + CAMADA SILVER ===")

    # Inicia o bloco de tratamento de erros.
    try:
        conexao = banco.conectar() #Chama a função conectar() do arquivo banco.py.

        print("[1/3] Esvaziando as tabelas SILVER...")
        for comando in LIMPAR_SILVER: #Percorre cada comando da lista. Em cada repetição, comando recebe um SQL.
            banco.executar(conexao, comando) #Envia o comando ao PostgreSQL.

        print("[2/3] Copiando e convertendo RAW -> SILVER...")
        banco.executar(conexao, SQL_DESLOCAMENTOS) #Carrega silver_viagem
        print("      silver_deslocamentos    OK")
        banco.executar(conexao, SQL_GASTOS)
        print("      silver_gastos OK")
        banco.executar(conexao, SQL_EMBARQUES)
        print("      silver_embarques  OK")
        banco.executar(conexao, SQL_TRAJETOS)
        print("      silver_trajetos    OK")

        print("[3/3] Calculando valor_total e duracao_dias...")
        banco.executar(conexao, SQL_CALCULOS) #Atualiza valor_total e duracao_dias em silver_viagem

        conexao.close()
        print("=== Camada SILVER concluida com sucesso! ===")

    # Captura exceções ocorridas durante o processo.    
    except Exception as erro:
        print("[ERRO] Algo deu errado:", erro)
        raise


if __name__ == "__main__":
    main()