import pandas as pd
import psycopg2
from config import DB_CONFIG

# conecta ao banco aula01
conexao = psycopg2.connect(
    host=DB_CONFIG["host"],
    database="aula02",
    user=DB_CONFIG["user"],
    password=DB_CONFIG["password"],
    port=DB_CONFIG["port"]
)

query = """
SELECT * FROM alunos;
"""

# executa a consulta e transforma o resultado em DataFrame
# !!!!!nao é o método mais recomendado pela documentação!!!!!
df_alunos = pd.read_sql_query(query, conexao)

# exibe o DataFrame
print(df_alunos)

# fecha a conexão
conexao.close()

print("Conexão com o aula02 encerrada.")