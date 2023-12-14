# Criando Gráficos com ggplot2 no Azure ML

# Configurando o diretório de trabalho
setwd("~/Desktop/DataScience/CienciaDeDados/1.Big-Data-Analytics-com-R-e-Microsoft-Azure-Machine-Learning/13.Data-Munging-no-Azure-Machine-Learning")
getwd()



#### Como Criar Gráficos com ggplot2 no Azure ML ####


## Voltando ao Azure ML

# - Criar um novo experimento.
# - Carregar o módulo com o dataset "Bike Rental UCI dataset"

# - Carregar o módulo com o arquivo R "Tools.zip"

# - Carregar o módulo "Execute R Script"

# - Conectar o "Bike Rental UCI Dataset" na porta 1 de entrada de "Execute R Script"
# - COnectar o módulo com o arquivo R "Tools.zip" na porta 3 de entrada de "Execute R Script"


# Colar o seguinte código no módulo "Execute R Script"

# Variável que controla a execução do script
# (Se o valor for FALSE, o codigo sera executado no RStudio.)
Azure <- TRUE

if(Azure){
  source("src/Tools.R")
  Bikes <- maml.mapInputPort(1)
  Bikes$dteday <- set.asPOSIXct(Bikes)
}else{
  source("Tools.R")
  Bikes <- read.csv("datasets/bikes.csv", sep = ",", header = T, stringsAsFactors = F )
  Bikes$dteday <- char.toPOSIXct(Bikes)
}

require(dplyr)
Bikes <- Bikes %>% filter(hr == 9)

# ggplot2
require(ggplot2)
ggplot(Bikes, aes(x = dteday, y = cnt)) +
  geom_line() +
  ylab("Numero de Bikes") +
  xlab("Linha do Tempo") +
  ggtitle("Demanda por Bikes as 09:00") +
  theme(text = element_text(size = 20))


