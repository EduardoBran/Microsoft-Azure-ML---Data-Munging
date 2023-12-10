# Script R para Azure

# Configurando o diretório de trabalho
setwd("C:/Users/Julia/Desktop/CienciaDeDados/1.Big-Data-Analytics-com-R-e-Microsoft-Azure-Machine-Learning/13.Data-Munging-no-Azure-Machine-Learning")
getwd()




## Desenvolvendo Script R para Manipulação de Dados + Biblioteca de Utilitários

# - Foi criado uma pasta chamada "datasets" neste local de trabalho
#   Dentro desta pasta está o dataset "bikes.csv"

# - O script Tools.R (script que contém diversas funções utilitárias) se encontra na mesma pasta.


# -> Este código contém comandos para filtrar e plotar os dados de aluguel de bikes, dados que estão em nosso dataset
# -> Este código foi criado para executar tanto no Azure, quanto no RStudio.
# -> Para executar no Azure, altere o valor da variavel Azure para TRUE.
#    Se o valor for FALSE, o código sera executado no RStudio



# Variável que controla a execução do script
Azure <- FALSE


# Execução de acordo com o valor da variável
# Se for verdadeiro, estamos no azure e executa o primeiro bloco de código, caso contrário executa o else

if(Azure){
  source("src/Tools.R")
  Bikes <- maml.mapInputPort(1)
  Bikes$dteday <- set.asPOSIXct(Bikes)   # modifica a coluna dteday no dataframe Bikes e atribui a ela os valores de datas convertidos para o formato POSIXct.
}else{
  source("Tools.R")
  Bikes <- read.csv("datasets/bikes.csv", sep = ",", header = T, stringsAsFactors = F )
  Bikes$dteday <- char.toPOSIXct(Bikes)
}

require(dplyr)
print("Dimensões do dataframe antes das operações de transformação:")
print(dim(Bikes))


# Filtrando o dataframe
Bikes <- Bikes %>% filter(cnt > 100)

print("Dimensões do dataframe após as operações de transformação:")
print(dim(Bikes))


# ggplot2
require(ggplot2)
qplot(dteday, cnt, data = subset(Bikes, hr == 9), geom = "line")


# Resultado (apenas no Azure ML)
if(Azure) maml.mapOutputPort("Bikes")



## Após testar aqui no ambiente R o código acima, iremos usa-lo no ambiente Azure ML

# - Após criar um novo experimento, carregar os módulo "Bike Rental UCI dataset" e "Execute R Script"

# - Em "Execute R Script" iremos apagar todo o código existente e colar todo o código acima 
#   (não incluir parte do código com a Configurando o diretório de trabalho "setwd")


## E o Tools.R ? Como incluir no Azure ML ?

# - Primeiramente vamos até o arquivo Tools.R e criaremos um versão ZIP dele (Precisa ser .zip)

# - Feito isso, vamos na barra inferior, clicar em "+ new", depois em "dataset" e carregar o arquivo "Tools.zip"
#   Processo idêntico ao de carregar um arquivo csv.

# - Após carregar o arquivo, procurar em no menu datasets por ele e arrastar o módulo Tools.zip para a área de trabalho.

# - Quando carregado, o módulo Tools.zip, o Azure ML automaticamente já descompacta e colocar o scrip na pasta "src"
#   Tal como está escrita no nosso código.

# - Agora iremos conectar o módulo Tools.zip na 3ª porta de entrada do módulo "Execute R Scrip"


# -> Não esquecer de alterar a variável "Azure"


# - Após clicarmos em "run" e clicar na 2ª porta de saída, sera possível visualizar os print() e também o gráfico.


## Outras observações

#  -> Nem todos os pacotes estarão instalados.

#  -> Alguns pacotes como o dplyr e o ggplot2 já vem instalados no Azure ML, por isso apenas os carregamos.

#  -> Para visualizarmos o gráfico, como já foi dito anteriormente, basta clicar na 2ª porta de saída.






