# load.py
import pandas as pd

def load_pib(df_pib):    

    df_pib.to_excel("PIB_Brasileiro.xlsx", index = False)

    print("Tabela PIB_Brasileiro.xlsx atualizada!")