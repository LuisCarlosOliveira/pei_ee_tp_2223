import pandas as pd

# Carregar o arquivo CSV
df = pd.read_csv('SalesLines.csv')

# Verificar entradas duplicadas em 'codigoFatura'
duplicatas = df[df.duplicated(subset='codigoFatura', keep=False)]

if not duplicatas.empty:
    print("Há códigos de fatura repetidos:")
    print(duplicatas[['codigoFatura']])
else:
    print("Não há códigos de fatura repetidos.")

# Contar o número de "id_cliente" distintos
#unique_id_clientes = df['id_cliente'].nunique()
#print(f"Há {unique_id_clientes} 'id_cliente' distintos no arquivo.")

# Contar o número de "codigoFatura" distintos
unique_codigoFatura = df['codigoFatura'].nunique()
print(f"Há {unique_codigoFatura} 'codigoFatura' distintos no arquivo.")

