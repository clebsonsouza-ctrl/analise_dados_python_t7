
# Permite acessar e manipular variáveis de ambiente.
import os
# Permite trabalhar com caminhos de arquivos e pastas.
from pathlib import Path


#Essa linha descobre automaticamente a pasta onde o arquivo config.py está localizado.
PASTA_RAIZ = Path(__file__).resolve().parent

# Essa linha monta o caminho da pasta data
PASTA_DADOS = PASTA_RAIZ / "data"

# Define a função responsável por carregar as variáveis de ambiente.
def carregar_env():

    # Define o caminho do arquivo .env.
    arquivo_env = PASTA_RAIZ / ".env"

    # Encerra a função caso o arquivo não exista.
    if not arquivo_env.exists():
        return

    # Lê o conteúdo do arquivo e percorre cada linha.
    for linha in arquivo_env.read_text(encoding="utf-8").splitlines(): # .splitlines() - Divide o conteúdo em linhas.

        # Remove espaços no início e no final da linha.
        linha = linha.strip()

        # Ignora linhas vazias, comentários e linhas sem "=".
        if not linha or linha.startswith("#") or "=" not in linha: # .startswith() - Verifica como a linha começa
            continue

        # Separa o nome da variável do seu respectivo valor.
        chave, valor = linha.split("=", 1) #1: realiza a divisão apenas na primeira ocorrência do separador.

        # Adiciona a variável ao ambiente caso ainda não exista.
        os.environ.setdefault(chave.strip(), valor.strip())


#Execução da função
carregar_env() #É nessa linha que a função realmente é executada.

# Cria um dicionário com as configurações de conexão.
POSTGRES_CONFIG = {

    #O método os.environ.get() recupera o valor de uma variável de ambiente.
    "host": os.environ.get("POSTGRES_HOST"),
    "port": int(os.environ.get("POSTGRES_PORT")),
    "user": os.environ.get("POSTGRES_USER"),
    "password": os.environ.get("POSTGRES_PASSWORD"),
    "dbname": os.environ.get("POSTGRES_DATABASE")
}


ANO = "2025"

DRIVE_FILE_ID = "1mJAs3_cKk_HBXIUfHCIj_f42YyIspet1"
# https://drive.google.com/file/d/1mJAs3_cKk_HBXIUfHCIj_f42YyIspet1/view?usp=sharing

# Tamanho do bloco de leitura/insercao (numero de linhas por vez).
# Ler tudo de uma vez estouraria a memoria; por isso lemos em "pedacos".
TAMANHO_BLOCO = 100


# Mapeamento: cada arquivo CSV dentro do .zip -> tabela RAW correspondente
# Relaciona os arquivos CSV originais às respectivas tabelas Raw.
# Temos um dicionário de dicionários, que permite automatizar a identificação dos arquivos e das respectivas tabelas de destino.
ARQUIVOS = {
    "deslocamentos": {"csv": "deslocamentos.csv",    "tabela_raw": "raw_deslocamentos"},
    "gastos":        {"csv": "gastos.csv",           "tabela_raw": "raw_gastos"},
    "embarques":     {"csv": "embarques.csv",        "tabela_raw": "raw_embarques"},
    "trajetos":      {"csv": "trajetos.csv",         "tabela_raw": "raw_trajetos"},
}

# Caracteristicas dos arquivos CSV do Portal da Transparencia:
CSV_SEPARADOR = ";"
CSV_ENCODING = "latin-1"   # acentuacao no padrao ISO-8859-1

#####################