# 03_criar_tabela.py

import psycopg2
from config import DB_CONFIG

# conecta ao banco aula01
conexao = psycopg2.connect(
    host=DB_CONFIG["host"],
    database="aula02", # modificado para o banco criado
    user=DB_CONFIG["user"],
    password=DB_CONFIG["password"],
    port=DB_CONFIG["port"]
)

cursor = conexao.cursor()

query = """
CREATE TABLE IF NOT EXISTS alunos (
    id SERIAL PRIMARY KEY,
    nome VARCHAR(100) NOT NULL,
    idade INTEGER,
    cidade VARCHAR(100),
    data_cadastro TIMESTAMP DEFAULT CURRENT_TIMESTAMP);
"""

# cria a tabela alunos
cursor.execute(query)

# confirma a criação da tabela
conexao.commit()

print("Tabela alunos criada com sucesso.")

cursor.close()
conexao.close()

print("Conexão com o banco aula02 encerrada.")

#python 03_criar_tabela.py