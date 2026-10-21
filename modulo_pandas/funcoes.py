import re
import unicodedata

"""
Converter os textos para letras maiúsculas;
Remover acentos e caracteres especiais;
Eliminar espaços desnecessários.

"""

def limpar_turno(texto):

    # Convertendo para maiúsculas
    texto = texto.upper()

    # Removendo acentos
    texto = unicodedata.normalize("NFKD", texto)
    texto = texto.encode("ASCII", "ignore").decode("ASCII")

    # Removendo caracteres especiais
    texto = re.sub(r"[^A-Z0-9 ]", "", texto)

    # Removendo espaços extras
    texto = re.sub(r"\s+", " ", texto).strip()

    return texto