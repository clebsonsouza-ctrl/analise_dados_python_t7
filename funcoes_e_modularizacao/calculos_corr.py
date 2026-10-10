def calcular_media(valores):
    return sum(valores) / len(valores)


if __name__ == "__main__":

    vendas = [1000, 1500, 2000]

    print(calcular_media(vendas))