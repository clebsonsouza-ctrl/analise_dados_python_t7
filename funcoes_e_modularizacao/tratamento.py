import re
import unicodedata

def tratar_nome(nome):

    nome = re.sub(r"\s+", " ", nome)

    return nome.strip().upper()


def remover_acentos(texto):
    # Normaliza o texto (separa letras de acentos: 'á' vira 'a' + '´')
    texto_normalizado = unicodedata.normalize('NFD', texto)
    # Remove os acentos mantendo apenas o que não for marca de combinação
    return re.sub(r'[\u0300-\u036f]', '', texto_normalizado)  