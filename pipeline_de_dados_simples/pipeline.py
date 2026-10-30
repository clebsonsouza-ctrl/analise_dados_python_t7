# pipeline.py
from extract import extract_pib
from transform import transform_pib
from load import load_pib

def run_pib_pipeline():
    print("Iniciando pipeline do PIB (ETL)...")

    # 1. EXTRACT
    print("Extraindo dados da API do BCB...")
    df_pib_raw = extract_pib(
        codigo=4380,
        data_inicial='01/01/2000',
        data_final='31/12/2025'  
    )

    # 2. TRANSFORM
    print("Transformando dados...")
    df_pib = transform_pib(df_pib_raw)

    # 3. LOAD
    load_pib(df_pib)   

    print("Pipeline finalizado com sucesso!")

if __name__ == "__main__":
    run_pib_pipeline()