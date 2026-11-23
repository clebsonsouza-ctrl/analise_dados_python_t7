#pip install psycopg2-binary
import psycopg2
from config import DB_CONFIG

# cria conexão com o banco padrão postgres
conexao = psycopg2.connect(
    host = DB_CONFIG["host"],
    database = DB_CONFIG["database"],
    user = DB_CONFIG["user"],
    password = DB_CONFIG["password"], # minha senha
    port = DB_CONFIG["port"]
)

# O cursor é quem envia os comandos SQL e recebe os resultados.
cursor = conexao.cursor()

# cria a query de versão do postgre
query = """
SELECT version();
"""

# executa consulta para verificar a versão do PostgreSQL
cursor.execute(query)

# pega o resultado. versao do postgre
resultado = cursor.fetchone() # pega apenas uma linha da consulta - fetchall(): pega todas as linhas da consulta

print(resultado)

# fecha cursor e conexão
cursor.close()
conexao.close()

print("Conexão encerrada.")