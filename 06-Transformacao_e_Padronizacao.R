# Transformação e Padronização

# Configurando o diretório de trabalho
setwd("C:/Users/Julia/Desktop/CienciaDeDados/1.Big-Data-Analytics-com-R-e-Microsoft-Azure-Machine-Learning/13.Data-Munging-no-Azure-Machine-Learning")
getwd()



#### Transformação e Padronização ####


# - Ficar sempre atento ao fluxo correto de trabalho que é:

#  -> 1º limpar os dados
#  -> 2º aplicar se necessário algum tipo de padronização



## Voltando ao Azure ML

# - Criar um novo experimento.
# - Carregar o Módulo com o dataset "Bike Rental UCI dataset"


# - Para maior efetividade do exemplo, vamos supor que antes de aplicar a normalização dos dados, nós tratamos os 
#   valores duplicados.

# - Procurar e arrastar o módulo "Remove Duplicate Rows"
# - Agora vamos conectar o módulo do dataset ao módulo de tratamento de valores duplicados.

# - No menu direito iremos selecionar a coluna que queremos verificar se tem valores duplicados.
# - Para o nosso exemplo, escolhemos a coluna "dteday"

# - Após selecionar a colunada "dteday" , basta clicar em "run" e verificar o resultado.


## Normalizando os Dados (para variáveis numéricas)

# - Procurar e arrastar o módulo "Normalize Data" para a área de trabalho
# - Conectar o módulo "Remove Duplicate Rows" no módulo "Normalize Data"

# - Agora selecionar o módulo "Normalize Data" e no menu direito escolher a técnica de normalização.

# - Após escolha da técnica de normalização (neste exemplo foi escolhido o "ZScore"), escolhemos as colunas que 
#   será aplicada a técnica. Estas colunas precisam ser numéricas.


## Normalizando os Dados (para variáveis categóricas)

# - Procurar e arrastar o módulo "Edit Metadata"
# - Conectar o módulo "Remove Duplicate Rows" no módulo "Edit Metadata"

# - Para variáveis categóricas, a normalização envolve muitas vezes a correção dos metadados para refletir corretamente o
#   tipo de variável.

# - Clicar no módulo "Edit Metadata" e no menu direito selecionar a coluna season para a mestra ser transformada
#   de numérico para string (categórica)



## Dicas Adicionais

# -> Ao escolher a técnica de normalização, leve em consideração a natureza dos dados e os requisitos do modelo.

# -> Essa abordagem completa de normalização é essencial para garantir que os dados estejam em um formato adequado antes
#    de serem utilizados em modelos de machine learning.









