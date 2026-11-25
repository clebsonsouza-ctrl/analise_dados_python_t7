
# Permite manipular arquivos compactados no formato ZIP.
import zipfile

# Permite baixar arquivos do Google Drive.
import gdown

# Permite ler e manipular os arquivos CSV.
import pandas as pd

# Importa as configurações do projeto.
import config

# Importa as funções de comunicação com o PostgreSQL.
import banco

# Responsável por baixar o arquivo compactado e armazená-lo na pasta data.
def baixar_zip():

    # Cria a pasta data, caso ela ainda não exista.
    config.PASTA_DADOS.mkdir(exist_ok=True)

    # Define o caminho onde o arquivo será armazenado.
    destino = config.PASTA_DADOS / "bases.zip"

    # Verifica se o arquivo já existe.
    if destino.exists():

        # Evita realizar um novo download.
        print("[1/3] O arquivo ja foi baixado antes - pulando o download.")

    else:

        print("[1/3] Baixando o arquivo do Google Drive...")

        # Realiza o download utilizando o identificador do arquivo.
        gdown.download(
            id=config.DRIVE_FILE_ID,
            output=str(destino)
        )

    # Retorna o caminho do arquivo ZIP.
    return destino


# ---------------------------------------------------------------------------
# Passo 2 - Carregar um CSV dentro da sua tabela RAW
# ---------------------------------------------------------------------------
def carregar_csv(conexao, zip_aberto, nome_csv, tabela):
    """Le um CSV de dentro do zip e insere todas as linhas na tabela do PostgreSQL.

    As colunas do CSV estao na MESMA ordem das colunas da tabela
    (definidas no 0_criar_banco.sql). Por isso conseguimos inserir "na ordem",
    sem precisar escrever o nome de cada coluna.
    """
    print("      Carregando", tabela, "...")

    # esvazia a tabela antes de carregar (assim, rodar de novo nao duplica dados)
    banco.executar(conexao, f"TRUNCATE TABLE {tabela}")

    total = 0

    # Abre um arquivo CSV localizado dentro do ZIP.
    with zip_aberto.open(nome_csv) as arquivo:
        # le o CSV em pedacos, para nao encher a memoria do PC
        pedacos = pd.read_csv( # Realiza a leitura do CSV em blocos.
            arquivo,

            ## Define o separador das colunas.
            sep=config.CSV_SEPARADOR,

            # Define a codificação dos caracteres.
            encoding=config.CSV_ENCODING,

            # Importa todas as colunas como texto.
            dtype=str,

            # Preserva campos vazios como strings vazias.
            keep_default_na=False,

            # Define a quantidade de linhas por bloco.
            chunksize=config.TAMANHO_BLOCO,
        )

        # Percorre cada bloco retornado pelo Pandas.
        for pedaco in pedacos:
            
            # Converte os registros do DataFrame em uma lista de listas.
            linhas = pedaco.values.tolist()

            # Cria um marcador %s para cada coluna.
            marcadores = ", ".join(["%s"] * len(pedaco.columns)) #Essa lógica permite utilizar a mesma função para arquivos com diferentes quantidades de colunas. ["%s","%s","%s"] 3 colunas por exemplo.

            # Monta dinamicamente o comando SQL.
            comando = f"INSERT INTO {tabela} VALUES ({marcadores})"

            # Insere os registros do bloco no PostgreSQL.
            banco.inserir_em_lote(conexao, comando, linhas)

            # Acumula a quantidade de registros inseridos.
            total += len(linhas)

    print("      ->", total, "linhas em", tabela)


# Responsável por coordenar a execução de todas as etapas anteriores.
def main():

    print("=== FASE 1: EXTRACAO + CAMADA RAW ===")

    try:

        # Estabelece a conexão com o PostgreSQL.
        conexao = banco.conectar()

        # Baixa o ZIP ou recupera o arquivo existente.
        caminho_zip = baixar_zip()

        print("[2/3] Abrindo o arquivo zip...")
        print("[3/3] Carregando as 4 tabelas RAW...")

        # Abre o arquivo compactado.        
        with zipfile.ZipFile(caminho_zip) as zip_aberto:

            # Percorre as configurações dos quatro arquivos.
            for arquivo in config.ARQUIVOS.values():

                # Aqui utilizamos o dicionário ARQUIVOS, definido anteriormente no config.py.
                # A mesma função será executada quatro vezes,
                # alterando automaticamente o arquivo de origem e a tabela de destino.


                # Executa a função de carregamento para cada CSV.
                carregar_csv(conexao,
                             zip_aberto,
                             arquivo["csv"],
                             arquivo["tabela_raw"])
                
        # Encerra a conexão com o PostgreSQL.
        conexao.close()

        print("=== Camada RAW concluida com sucesso! ===")

    # Captura possíveis erros durante o processo.    
    except Exception as erro:

        # Exibe uma mensagem de erro.
        print("[ERRO] Algo deu errado:", erro)

        # Relança a exceção original.
        raise


# Verifica se o arquivo está sendo executado diretamente.
if __name__ == "__main__":
    main()