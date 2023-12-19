# Lista de Exercício - Parte 1

# Configurando o diretório de trabalho
setwd("~/Desktop/DataScience/CienciaDeDados/1.Big-Data-Analytics-com-R-e-Microsoft-Azure-Machine-Learning/13.Data-Munging-no-Azure-Machine-Learning")
getwd()



#### Exercício 1 ####


## Instalando e importando pacotes

# install.packages("e1071", dependencies = TRUE) # invocando o método NaiveBayes
library(e1071)

# install.packages("mlbench", dependencies = TRUE)
library(mlbench)

# install.packages("mice", dependencies = TRUE)  # Imputação Estatística de valores ausentes
library(mice)

# install.packages("VIM", dependencies = TRUE) #  Imputação Estatística de valores ausentes
library(VIM)

library(randomForest)
library(caTools)   # contém a função sample.split() que cria uma amostra que irá fazer a divisão entre dados de treinos e testes
library(caret)     # contém a função createDataPartition para fazer a divisão entre dados de treinos e testes

set.seed(100)



# - Para este script, vamos usar o dataset mlbench (Machine Learning Benchmark Problems)
#   https://cran.r-project.org/web/packages/mlbench/mlbench.pdf

# - Este pacote contém diversos datasets e usaremos um com os dados de votação do congresso americano. 


#  -> Seu trabalho é prever os votos em republicanos e democratas (variável Class)




#####################  Resposta Gabarito  #####################


## Carregando o dataset
?HouseVotes84
data("HouseVotes84")

head(HouseVotes84)
View(HouseVotes84)


## Analise exploratória de dados (gerando gráficos para melhor entendimento do dataset)
plot(as.factor(HouseVotes84[,2]))
title(main = "Votes cast for issue", xlab = "vote", ylab = "# reps")
plot(as.factor(HouseVotes84[HouseVotes84$Class == 'republican', 2]))
title(main = "Republican votes cast for issue 1", xlab = "vote", ylab = "# reps")
plot(as.factor(HouseVotes84[HouseVotes84$Class == 'democrat',2]))
title(main = "Democrat votes cast for issue 1", xlab = "vote", ylab = "# reps")


## Funções usadas para imputation

# Função que retorna o numeros de NA's por voto e classe (democrat or republican)
na_by_col_class <- function (col,cls){return(sum(is.na(HouseVotes84[,col]) & HouseVotes84$Class==cls))}

p_y_col_class <- function(col,cls){
  sum_y <- sum(HouseVotes84[,col] == 'y' & HouseVotes84$Class == cls, na.rm = TRUE)
  sum_n <- sum(HouseVotes84[,col] == 'n' & HouseVotes84$Class == cls, na.rm = TRUE)
  return(sum_y/(sum_y+sum_n))}

# Testando a função
p_y_col_class(2,'democrat')
p_y_col_class(2,'republican')
na_by_col_class(2,'democrat')
na_by_col_class(2,'republican')

# Impute missing values (imputando valores ao valores NA)
for (i in 2:ncol(HouseVotes84)) {
  if(sum(is.na(HouseVotes84[,i])>0)) {
    c1 <- which(is.na(HouseVotes84[,i]) & HouseVotes84$Class == 'democrat',arr.ind = TRUE)
    c2 <- which(is.na(HouseVotes84[,i]) & HouseVotes84$Class == 'republican',arr.ind = TRUE)
    HouseVotes84[c1,i] <- ifelse(runif(na_by_col_class(i,'democrat'))<p_y_col_class(i,'democrat'),'y','n')
    HouseVotes84[c2,i] <- ifelse(runif(na_by_col_class(i,'republican'))<p_y_col_class(i,'republican'),'y','n')}
}

# Gerando dados de treino e dados de teste
HouseVotes84[,"train"] <- ifelse(runif(nrow(HouseVotes84)) < 0.80,1,0)
trainColNum <- grep("train",names(HouseVotes84))

# Gerando os dados de treino e de teste a partir da coluna de treino
trainHouseVotes84 <- HouseVotes84[HouseVotes84$train == 1, -trainColNum]
testHouseVotes84 <- HouseVotes84[HouseVotes84$train == 0, -trainColNum]

# -> Lembrando sempre que: Treinamos o modelo com dados de TREINO e fazemos predições com dados de TESTE


## Utilizando o método NaiveBayes

# Exercício 1 - Crie o modelo NaiveBayes e faça as previsões

# Treine o modelo
modelo_nb <- naiveBayes(Class ~ ., data = trainHouseVotes84)

# Visualizando o modelo
modelo_nb
summary(modelo_nb)
str(modelo_nb)


## Realizando previsões
previsoes <- predict(modelo_nb, newdata = testHouseVotes84)

## Confusion Matrix
table(pred = previsoes, true = testHouseVotes84$Class)

## Média
mean(previsoes == testHouseVotes84$Class)


## Conferindo as previsões
resultados <- cbind.data.frame(Class_Real = testHouseVotes84$Class, predictions = previsoes)
head(resultados)

## Criando um vetor de TRUE/FALSE indicando previsões CORRETAS/INCORRETAS
resultados_vetor <- resultados$predictions == testHouseVotes84$Class

table(resultados_vetor)                    # FALSE 6                 TRUE 96
prop.table(table(resultados_vetor))        # FALSE 0.05882353        TRUE 0.94117647







#####################  Resposta Pessoal  #####################


## Sobre o Conjunto de Dados:

# - O conjunto de dados contém informações sobre o voto de cada representante em questões específicas, representadas por colunas
#   binárias (sim ou não).
# - A variável "Class" indica a afiliação partidária do representante (democrata ou republicano).

## Objetivo:
  
# - O objetivo é treinar um modelo de previsão usando o método Naive Bayes para fazer previsões sobre a afiliação partidária
#  (democrata ou republicano) com base nos padrões de votação.

## Passos Gerais:
  
# -> Realizar análise exploratória dos dados.
# -> Tratar valores ausentes, se necessário.
# -> Converter variáveis categóricas para fatores.
# -> Dividir o conjunto de dados em conjuntos de treino e teste.
# -> Treinar um modelo Naive Bayes usando os dados de treino.
# -> Avaliar o desempenho do modelo usando os dados de teste.

## Avaliação:
  
# - A avaliação do desempenho do modelo pode ser feita usando métricas como a matriz de confusão, precisão, recall, F1-score, entre outras.

## Sobre o Algoritmo Naive Bayes

# - O modelo de Naive Bayes será treinado usando os padrões de votação dos representantes em questões específicas para prever a afiliação
#   partidária (democrata ou republicano).
# - O  modelo utiliza a relação entre votos em questões específicas e afiliação partidária para aprender padrões e fazer previsões sobre 
#   a afiliação partidária de representantes com base em seus votos.

## Resumindo

# - O objetivo é criar um modelo que possa aprender padrões nos votos dos representantes e fazer previsões sobre a afiliação
#   partidária com base nesses padrões. O método escolhido para essa tarefa é o Naive Bayes.



#### Carregando os dados

dados = HouseVotes84
head(dados)
View(dados)


#### Análise Exploratória

## Renomear as colunas, mantendo "Class" e "train" com seus nomes originais

new_colnames <- c("Class", "Handicapped Infants", "Water Project Cost Sharing", 
                  "Adoption of the Budget Resolution", "Physician Fee Freeze", 
                  "El Salvador Aid", "Religious Groups in Schools", 
                  "Anti-Satellite Test Ban", "Aid to Nicaraguan Contras", 
                  "MX Missile", "Immigration", "Synfuels Corporation Cutback", 
                  "Education Spending", "Superfund Right to Sue", "Crime", 
                  "Duty-Free Exports", "Export Administration Act South Africa")

colnames(dados) <- new_colnames
colnames(dados) <- make.names(colnames(dados))  # retira " " dos nomes das colunas

head(dados)
View(dados)


#### Tipo de dados

str(dados)
summary(dados)
dim(dados)

# Verificando dados ausentes
any(is.na(dados))
colSums(is.na(dados))
any(dados == "")
colSums(dados == "")


#### Tratando dados ausentes (substituindo pela Moda)

## Substituir valores ausentes pela moda

# - Descrição  : Substituir os valores ausentes pelo valor mais frequente (moda) em cada variável.
# - Quando usar: Apropriado quando a variável é dominada por uma categoria e essa categoria pode ser considerada como uma boa 
#                representação da tendência central.

dados_moda <- dados
for (col in colnames(dados_moda)) {
  moda <- names(sort(table(dados_moda[[col]]), decreasing = TRUE))[1]
  dados_moda[[col]][is.na(dados_moda[[col]])] <- moda
}

any(is.na(dados_moda))


## Substituir valores ausentes por valores aleatórios

# - Descrição  : Substituir os valores ausentes por amostras aleatórias das categorias existentes.
# - Quando usar: Pode ser útil quando a distribuição das categorias é relativamente uniforme e não existe uma categoria dominante.

dados_aleatorio <- dados
for (col in colnames(dados_aleatorio)) {
  categorias <- levels(dados_aleatorio[[col]])
  dados_aleatorio[[col]][is.na(dados_aleatorio[[col]])] <- sample(categorias, sum(is.na(dados_aleatorio[[col]])), replace = TRUE)
}

any(is.na(dados_aleatorio))


## Substituir valores ausentes por MICE (Imputação Estatística Múltipla)

# - Descrição  : Imputação estatística que leva em consideração as relações entre variáveis para imputar os valores ausentes.
# - Quando usar: Pode ser útil quando as variáveis categóricas estão correlacionadas e a imputação precisa considerar essas relações.

dados_imputacao_mice <- dados
imputed_data <- mice(dados_imputacao_mice, method = "logreg")  # logreg para imputação com regressão logística
dados_imputacao_mice <- complete(imputed_data)

any(is.na(dados_imputacao_mice))


## Substituir valores ausentes por VIM (Vizinhos mais próximos)

# - Descrição  : Imputação com base nos vizinhos mais próximos em termos de padrões de votação.
# - Quando usar: Pode ser útil quando as observações com padrões de votação semelhantes tendem a ter valores categóricos semelhantes.

dados_imputacao_vim <- dados
dados_imputacao_vim <- hotdeck(dados_imputacao_vim)

any(is.na(dados_imputacao_vim))


## Comparando tratamento de valores ausentes

summary(dados)
summary(dados_moda)
summary(dados_aleatorio)
summary(dados_imputacao_mice)
summary(dados_imputacao_vim)

# - A imputação pela moda é uma escolha simples, mas pode não ser ideal se houver relações complexas entre variáveis.
# - A imputação aleatória pode ser menos preferida, pois introduz variabilidade sem considerar as características específicas dos
#   dados.
# - O método "MICE" e a imputação usando "VIM" (KNN) tendem a ser escolhas razoáveis, pois consideram a relação entre variáveis. 
#   A escolha entre eles pode depender da eficácia em preservar as características do conjunto de dados original e da praticidade 
#   computacional.


#### Utilizando NaiveBayes (utilizando dataset dados_imputacao_mice)

set.seed(100)

## Divindo dados em treino e teste
indices <- createDataPartition(dados_imputacao_mice$Class, p = 0.85, list = FALSE)

dados_treino <- dados_imputacao_mice[indices, ]
dados_teste <- dados_imputacao_mice[-indices, ]

# -> Lembrando sempre que: Treinamos o modelo com dados de TREINO e fazemos predições com dados de TESTE


## Aplicando Método
modelo <- naiveBayes(Class ~ ., data = dados_treino)
modelo

## Realizando previsões
previsoes <- predict(modelo, newdata = dados_teste)

## Conferindo as previsões
resultados <- cbind.data.frame(Class_Real = dados_teste$Class, predictions = previsoes)
head(resultados)

# Criando um vetor de TRUE/FALSE indicando previsões CORRETAS/INCORRETAS
resultados_vetor <- resultados$predictions == dados_teste$Class

table(resultados_vetor)                    # FALSE 3                 TRUE 62
prop.table(table(resultados_vetor))        # FALSE 0.04615385        TRUE 0.95384615

#  -> O modelo que utilizou o dataset com técnica de imputação de valores ausentes MICE teve uma taxa de acerto de
#     aproximadamente 95,38% no conjunto de teste.



#### Método NaiveBayes (utilizanod dataset dados_imputacao_vim)

## Divindo dados em treino e teste
indices <- createDataPartition(dados_imputacao_vim$Class, p = 0.85, list = FALSE)

dados_treino <- dados_imputacao_vim[indices, ]
dados_teste <- dados_imputacao_vim[-indices, ]

# -> Lembrando sempre que: Treinamos o modelo com dados de TREINO e fazemos predições com dados de TESTE


## Aplicando Método
modelo <- naiveBayes(Class ~ ., data = dados_treino)
modelo

## Realizando previsões
previsoes <- predict(modelo, newdata = dados_teste)

## Conferindo as previsões
resultados <- cbind.data.frame(Class_Real = dados_teste$Class, predictions = previsoes)
head(resultados)

# Criando um vetor de TRUE/FALSE indicando previsões CORRETAS/INCORRETAS
resultados_vetor <- resultados$predictions == dados_teste$Class

table(resultados_vetor)                    # FALSE 4                 TRUE 61
prop.table(table(resultados_vetor))        # FALSE 0.06153846        TRUE 0.93846154

#  -> O modelo que utilizou o dataset com técnica de imputação de valores ausentes VIM teve uma taxa de acerto de
#     aproximadamente 93.84% no conjunto de teste.




#### Utilizando randomForest (utilizando dataset dados_imputacao_mice)

## Divindo dados em treino e teste
indices <- createDataPartition(dados_imputacao_mice$Class, p = 0.85, list = FALSE)

dados_treino <- dados_imputacao_mice[indices, ]
dados_teste <- dados_imputacao_mice[-indices, ]

# -> Lembrando sempre que: Treinamos o modelo com dados de TREINO e fazemos predições com dados de TESTE


## Aplicando Método
modelo_rf <- randomForest(Class ~ ., data = dados_treino)

## Realizando previsões
previsoes <- predict(modelo_rf, newdata = dados_teste)

## Conferindo as previsões
resultados <- cbind.data.frame(Class_Real = dados_teste$Class, predictions = previsoes)
head(resultados)

# Criando um vetor de TRUE/FALSE indicando previsões CORRETAS/INCORRETAS
resultados_vetor <- resultados$predictions == dados_teste$Class

table(resultados_vetor)                    # FALSE 1                 TRUE 64
prop.table(table(resultados_vetor))        # FALSE 0.01538462        TRUE 0.98461538

#  -> O modelo que utilizou o dataset com técnica de imputação de valores ausentes MICE teve uma taxa de acerto de
#     aproximadamente 98.46% no conjunto de teste.

