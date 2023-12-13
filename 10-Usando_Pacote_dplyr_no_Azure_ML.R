# Usando o pacote dplyr no Azure ML

# Configurando o diretório de trabalho
setwd("~/Desktop/DataScience/CienciaDeDados/1.Big-Data-Analytics-com-R-e-Microsoft-Azure-Machine-Learning/13.Data-Munging-no-Azure-Machine-Learning")
getwd()



#### Usando o pacote dplyr no Azure ML ####

## Voltando ao Azure ML

# - Criar um novo experimento.
# - Carregar os Módulos de datasets "Restaurant feature data" e "Restaurant ratings"

# - Após carregar os datasets para a área de trabalho, vamos fazer o DOWNLOAD dos dois.


## Executando R no Azure ML

# - Procurar e arrastar para área de trabalho o módulo "Execute R Script"

# - Conectar os dois datasets nas duas protas de entrada do módulo "Execute R Script"

# - Coṕiar o código abaixo e colar no módulo "Execute R Script"
# - Alterar valor da variável Azure
# - Alterar configuração do "R version" para CRAN 3.1.0

# Agora vamos análisar o código R abaixo que também estará em arquivo R separado:


# Variável que controla a execução do script (Se o valor for FALSE, o codigo sera executado no RStudio.)
Azure = FALSE

if(Azure){
  restaurantes <- maml.mapInputPort(1)
  ratings <- maml.mapInputPort(2) 
}else{
  restaurantes  <- read.csv("Restaurant_feature_data.csv", sep = ",", header = T, stringsAsFactors = F )
  ratings <- read.csv("Restaurant_ratings.csv", sep = ",", header = T, stringsAsFactors = F)
}

# Filtrando o dataset restaurantes
restaurantes <- restaurantes[restaurantes$franchise == 'f' & restaurantes$alcohol != 'No_Alcohol_Served', ]

require(dplyr)

# Combinando os datasets com base em regras

df <- as.data.frame(restaurantes %>%
                      inner_join(ratings, by = 'placeID') %>%
                      select(name, rating) %>%
                      group_by(name) %>%
                      summarize(ave_Rating = mean(rating)) %>%
                      arrange(desc(ave_Rating))) 

# -> inner_join(ratings, by = 'placeID') realiza um inner join entre os dataframes restaurantes e ratings usando a coluna 'placeID' como chave de ligação.
# -> select(name, rating): Seleciona as colunas 'name' e 'rating' do resultado do inner join.
# -> group_by(name) %>% summarize(ave_Rating = mean(rating)):
#    Agrupa os dados pelo nome do restaurante ('name') e, em seguida, calcula a média (mean()) das avaliações ('rating') para cada grupo.
# -> arrange(desc(ave_Rating)): Ordena o dataframe resultante de forma decrescente com base na coluna 'ave_Rating'.


# Visualizando dataset criado
df
head(df)
View(df)


if(Azure) maml.mapOutputPort("df")

# - Este código contém comandos para filtrar e plotar os dados de aluguel de bikes, dados que estão em nosso dataset.
# - Este código foi criado para executar tanto no Azure, quanto no RStudio.
# - Para executar no Azure, altere o valor da variavel Azure para TRUE. 
# - Se o valor for FALSE, o codigo sera executado no RStudio.






