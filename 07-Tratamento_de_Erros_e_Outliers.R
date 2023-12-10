# Tratamento de Erros e Outliers

# Configurando o diretório de trabalho
setwd("C:/Users/Julia/Desktop/CienciaDeDados/1.Big-Data-Analytics-com-R-e-Microsoft-Azure-Machine-Learning/13.Data-Munging-no-Azure-Machine-Learning")
getwd()



#### Tratando Erros e Valores Outliers ####



## Voltando ao Azure ML

# - Criar um novo experimento.
# - Carregar o Módulo com o dataset "Bike Rental UCI dataset"


# -> É uma boa prática relizar a limpeza, remoção de ouliers ou valores duplicados antes de realizar transformação


## Tratando Valores Outliers

# - Procurar e arrastar o módulo "Clip Values" para a área de trabalho
# - Conectar o módulo "Bike Rental UCI dataset" no módulo "Clip Values"

# - Após selecionar o módulo "Clip Values", vamos ao menu direito configura-lo.

#  -> Set of thresholds: é o tipo de remoção de valores outliers

#     "ClipPeaks"           - remove todos os valores outliers
#     "ClipSubpeaks         - remove algo como sub valores outliers
#     "ClipPeaksAndSubPeaks - realiza as duas operações acima

#  -> Treshold: escolhe o tipo de regra.

#     Foi escolhido a regra "Percentil"

#  -> Agora deixamos no 1º campo 90 e no 2º campo 10 .
#     Ou seja, tudo que estiver acima do percentul 90 e abaixo do 10 será removido.

#  -> Substitute value for peaks: regra para substituir os valores outliers.

#     Podemos substitui-los por valores da média, mediana e também por valores MISSING.
#     Por isso a importância do fluxo de trabalho, se substituimos os valores outliers por missing, é importante 
#     que o módulo onde trata a limpeza de valores missing esteja abaixo no fluxo.

#  -> Ao final, escolheremos qual ou quais variáveis queremos aplicar. (para este exemplo foi escolhida a variável cnt)


#  -> Ou seja, iremos remover os valores que estiverem acima de 90 e abaixo de 10 percentil na variável cnt.








