# Executando Script R no Azure ML

# Configurando o diretório de trabalho
setwd("C:/Users/Julia/Desktop/CienciaDeDados/1.Big-Data-Analytics-com-R-e-Microsoft-Azure-Machine-Learning/13.Data-Munging-no-Azure-Machine-Learning")
getwd()



#### Executando Script R no Azure ML ####


## Criar Projeto

# - No menu inferior clicar em "+ new" e na sequência em "Blank Experiment"

# - E assim criamos o projeto "Data Munging 1 - Executando Script R"



## Carregando um dataset

# - No menu lateral esquerdo ir em "Saved Datasets' e na sequência em "Samples"

# - Iremos escolher o dataset "Bike Rental UCI dataset" e o arrastaremos para a área de trabalho.



## Executando Script R no Azure ML

# - Procurar e arrastar para área de trabalho o módulo "Execute R Script".

# - Ao análisar este módulo percebemos que ele possui 3 portas de entrada e 2 portas de saída.
#   A 1ª e 2ª porta de entrada espera receber um dataset.
#   A 3ª porta de entrada espera receber um arquivo Script Bundle, ou seja um arquivo ZIP com vários scripts em
#   linguagem R.
#   A 1ª porta de saída gera o resultado do dataset.
#   A 2ª porta de saída gera um R Device, ou seja é um plot a partir da saída desde módulo.

# - Ao clicarmos no módulo, ao lado direito aparece uma janela onde colocaremos o código em R.


# - Iremos deixar as seguintes linha de código nesta janela:

# Map 1-based optional input ports to variables
df <- maml.mapInputPort(1) # class: data.frame

# Select data.frame to be sent to the output Dataset port
maml.mapOutputPort("df");

# - Desta forma ao clicar na 1ª saída, visualizaremos o conteúdo do dataset

# - Após colocarmos o código necessário na Janela, modificar o R Version para "CRAN R 3.1.0"





## Exemplo

library(dplyr)
# Map 1-based optional input ports to variables
df <- maml.mapInputPort(1) # class: data.frame

df2 <- df
df2 <- df2 %>% select(yr, hr)

# Select data.frame to be sent to the output Dataset port
maml.mapOutputPort("df2");

print(2+2)

# - No código acima ao clicar na 1ª saída iremos visualizar o dataset modificado df2 apenas com as colunas selecionadas

# - Para visualizarmos "print(2+2)" e seu resultado, devemos clicar na 2ª saída











