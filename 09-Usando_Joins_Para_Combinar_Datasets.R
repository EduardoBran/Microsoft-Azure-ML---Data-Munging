# Usando Joins Para Combinar Datasets no Azure ML

# Configurando o diretório de trabalho
setwd("C:/Users/Julia/Desktop/CienciaDeDados/1.Big-Data-Analytics-com-R-e-Microsoft-Azure-Machine-Learning/13.Data-Munging-no-Azure-Machine-Learning")
getwd()



#### Usando Joins Para Combinar Datasets no Azure MLL ####


## Voltando ao Azure ML

# - Criar um novo experimento.
# - Carregar os Módulos de datasets "Restaurant feature data" e "Restaurant ratings"


## Utilizando Join

# - Procurar e arrastar o módulo "Join Data" 

# - Conectar os dois módulos de datasets nas portas de entrada do módulo "Join Data"

# - Ao selecionar o módulo "Join Data", configurar as propriedades no menu direito.

#  -> Selecionar a coluna para ligação da tabela 1
#  -> Selecionar a coluna para ligação da tabela 2

# - Neste exemplo será usado a coluna "placeID" que está presente em ambos os datasets.

# - Depois escolher o tipo de Join e clicar em "Run"


# - Desta forma conseguimos realizar a junção das tabelas de uma maneira mais rápida (aqui não conseguimos aplicar filtros)