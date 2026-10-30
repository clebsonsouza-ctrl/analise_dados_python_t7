# extract.py
import requests
import pandas as pd

def extract_pib(codigo=4380,
                data_inicial='01/01/2018',
                data_final='31/12/2025'):
    url = (
        f'https://api.bcb.gov.br/dados/serie/bcdata.sgs.{codigo}/dados'
        f'?formato=json&dataInicial={data_inicial}&dataFinal={data_final}'
    )

    response = requests.get(url)
    response.raise_for_status()  #dispara erro

    dados = response.json()
    df_pib = pd.DataFrame(dados)

    return df_pib