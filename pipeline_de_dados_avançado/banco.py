import psycopg2
from psycopg2 import Error

# Importa o dicionário com as configurações de conexão.
from config import POSTGRES_CONFIG



# Define a função responsável pela conexão.
def conectar():

    # Tenta estabelecer a conexão com o PostgreSQL.
    try:
        return psycopg2.connect(**POSTGRES_CONFIG)
    # Os dois asteriscos (**) realizam o desempacotamento do dicionário,
    # transformando suas chaves e valores em argumentos nomeados da função.

    # Captura possíveis erros gerados pelo psycopg2.
    except Error as erro:

        # Gera uma exceção com uma mensagem mais detalhada.
        raise RuntimeError(
            f"Nao foi possivel conectar ao PostgreSQL em "
            f"{POSTGRES_CONFIG['host']}:{POSTGRES_CONFIG['port']} / database "
            f"'{POSTGRES_CONFIG['dbname']}'. Verifique o .env e se voce ja rodou "
            f"o script '0_criar_banco.sql'. Detalhe: {erro}"
        )


# Recebe uma conexão ativa e um comando SQL.
def executar(conexao, sql):

    # Cria um cursor para executar comandos SQL.
    cursor = conexao.cursor()

    # Envia o comando SQL ao PostgreSQL.
    cursor.execute(sql)

    # Confirma a transação no banco de dados.
    conexao.commit()

    # Fecha o cursor, mas mantém a conexão aberta.
    cursor.close()


# Recebe a conexão, o comando INSERT e os registros.
def inserir_em_lote(conexao, sql_insert, linhas):

    # Encerra a função caso não existam registros.
    if not linhas:
        return

    # Cria o cursor.
    cursor = conexao.cursor()

    # Executa o INSERT para cada registro recebido.
    cursor.executemany(sql_insert, linhas)

    # Confirma a transação no banco de dados.
    conexao.commit()

    # Fecha o cursor.
    cursor.close()