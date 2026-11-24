#pip install psycopg2-binary
import psycopg2
from config import DB_CONFIG

# cria conexão com o banco padrão postgres
conexao = psycopg2.connect(
    host = DB_CONFIG["host"],
    database = "aula02", # modificado para o banco criado
    user = DB_CONFIG["user"],
    password = DB_CONFIG["password"], # minha senha
    port = DB_CONFIG["port"]
)

# O cursor é quem envia os comandos SQL e recebe os resultados.
cursor = conexao.cursor()

query = """
INSERT INTO alunos (nome, idade, cidade)
VALUES
    ('Ana', 25, 'João Pessoa'),
    ('Carlos', '30', 'Recife');

"""

# insere duas linhas na tabela alunos
cursor.execute(query)

# confirma a inserção
conexao.commit()

print("Dados inseridos com sucesso.")

cursor.close()
conexao.close()

print("Conexão com o banco aula02 encerrada.")





