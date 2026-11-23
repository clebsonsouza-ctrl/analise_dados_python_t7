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

# necessário para executar CREATE DATABASE
conexao.autocommit = True

# O cursor é quem envia os comandos SQL e recebe os resultados.
cursor = conexao.cursor()

# verifica se o banco aula02 já existe
cursor.execute("SELECT 1 FROM pg_database WHERE datname = 'aula02';")

banco_existe = cursor.fetchone() # fetchone pega apenas uma linha da consult

if banco_existe:
       print("O banco aula02 já existe.")
else:
       cursor.execute("CREATE DATABASE aula02;")
       print("Banco aula02 criado com sucesso.")

# fecha cursor e conexão
cursor.close()
conexao.close()

print("Conexão encerrada.")