# Arquivo: conversor.py

def dolar_para_real(valor):
    return valor * 5.50

# O código abaixo serve APENAS para testar o arquivo diretamente
if __name__ == "__main__":
    print("--- MODO DE TESTE DO CONVERSOR ---")
    resultado_teste = dolar_para_real(10)
    print(f"10 dólares equivalem a: R$ {resultado_teste}")