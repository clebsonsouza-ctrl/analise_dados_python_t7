# transform.py
import pandas as pd

def transform_pib(df_pib_raw: pd.DataFrame) -> pd.DataFrame:
    df_pib = df_pib_raw.copy()

    # cria coluna mes_ano no formato mm-aaaa (igual ao seu código)
    df_pib['mes_ano'] = df_pib['data'].map(
        lambda x: x[3:10].replace('/', '-')
    )

    # converte 'valor' para número
    df_pib['valor'] = pd.to_numeric(df_pib['valor'], errors='coerce')

    # renomeia para pib_corrente (igual você fez)
    df_pib = df_pib.rename(columns={'valor': 'pib_corrente'})

    # opcional: converter data para datetime, se quiser
    df_pib['data'] = pd.to_datetime(df_pib['data'], format='%d/%m/%Y')

    # aqui deixamos só as colunas que interessam ao BD
    df_pib_final = df_pib[['data', 'mes_ano', 'pib_corrente']]

    return df_pib_final