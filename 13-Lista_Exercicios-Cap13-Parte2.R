# Lista de Exercício - Parte 2

# Configurando o diretório de trabalho
setwd("~/Desktop/DataScience/CienciaDeDados/1.Big-Data-Analytics-com-R-e-Microsoft-Azure-Machine-Learning/13.Data-Munging-no-Azure-Machine-Learning")
getwd()



#### Exercício 2 ####


## Instalando e importando pacotes
# install.packages("Amelia", dependencies = TRUE)

library(Amelia) # pacote que utiliza funções para definir o volume de dados Missing
library(cluster) # visualização dos clusters
library(ggplot2)
library(caret)     # contém a função createDataPartition para fazer a divisão entre dados de treinos e testes

library(rpart)       # Um dos diversos pacotes para arvores de recisao em R
library(rpart.plot)  # outro pacote para visualizaco ficar mais legivel
library(e1071)       # NaiveBayes e Máquina de Vetores de Suporte (SVM)
library(xgboost)     # Modelo Gradient Boosting
library(neuralnet)   # Rede Neural

set.seed(1234)


# - Para este exemplo, usaremos o dataset Titanic do Kaggle. 
#   https://www.kaggle.com/c/titanic/data

# - Este dataset é famoso e usamos parte dele nas aulas de SQL.
#   Ele normalmente é usado por aqueles que estão começando em Machine Learning.

#  -> Seu objetivo é prever uma classificação - sobreviventes e não sobreviventes




#####################  Resposta Gabarito  #####################


## Carregando o dataset de dados_treino
dados_treino <- read.csv('titanic-train.csv')
View(dados_treino)


## Analise exploratória de dados

# Vamos usar o pacote Amelia e suas funções para definir o volume de dados Missing
# Clique no zoom para visualizar o grafico
# Cerca de 20% dos dados sobre idade estão Missing (faltando)

?missmap
missmap(dados_treino, 
        main = "Titanic Training Data - Mapa de Dados Missing", 
        col = c("yellow", "black"), 
        legend = FALSE)


# Visualizando os dados (gráfico)

ggplot(dados_treino,aes(Survived)) + geom_bar()
ggplot(dados_treino,aes(Pclass)) + geom_bar(aes(fill = factor(Pclass)), alpha = 0.5)
ggplot(dados_treino,aes(Sex)) + geom_bar(aes(fill = factor(Sex)), alpha = 0.5)
ggplot(dados_treino,aes(Age)) + geom_histogram(fill = 'blue', bins = 20, alpha = 0.5)
ggplot(dados_treino,aes(SibSp)) + geom_bar(fill = 'red', alpha = 0.5)
ggplot(dados_treino,aes(Fare)) + geom_histogram(fill = 'green', color = 'black', alpha = 0.5)


## Limpando os dados

# Para tratar os dados missing, usaremos o recurso de imputation.
# Essa técnica visa substituir os valores missing por outros valores,
# que podem ser a média da variável ou qualquer outro valor escolhido pelo Cientista de Dados

# Por exemplo, vamos verificar as idades por classe de passageiro (baixa, média, alta):
pl <- ggplot(dados_treino, aes(Pclass,Age)) + geom_boxplot(aes(group = Pclass, fill = factor(Pclass), alpha = 0.4)) 
pl + scale_y_continuous(breaks = seq(min(0), max(80), by = 2))

# Vimos que os passageiros mais ricos, nas classes mais altas, tendem a ser mais velhos. 
# Usaremos esta média para imputar as idades Missing
impute_age <- function(age, class){
  out <- age
  for (i in 1:length(age)){
    
    if (is.na(age[i])){
      
      if (class[i] == 1){
        out[i] <- 37
        
      }else if (class[i] == 2){
        out[i] <- 29
        
      }else{
        out[i] <- 24
      }
    }else{
      out[i]<-age[i]
    }
  }
  return(out)
}

fixed.ages <- impute_age(dados_treino$Age, dados_treino$Pclass)
dados_treino$Age <- fixed.ages

# Visualizando o mapa de valores missing (nao existem mais dados missing)
missmap(dados_treino, 
        main = "Titanic Training Data - Mapa de Dados Missing", 
        col = c("yellow", "black"), 
        legend = FALSE)


# Exercício 1 - Crie o modelo de classificação e faça as previsões













#####################  Resposta Pessoal  #####################



## Carregando dados

dados <- read.csv('titanic-train.csv')
View(dados)
head(dados)


## Análise Exploratória

# Tipo de dados
str(dados)
summary(dados)
dim(dados)

## Verificando dados ausentes ou ""
any(is.na(dados))
colSums(is.na(dados))
any(dados == "")
colSums(dados == "")


## Verificando dados NA com missmap
missmap(dados, 
        main = "Titanic Training Data - Mapa de Dados Missing", 
        col = c("yellow", "black"), 
        legend = FALSE)


## Tratando valores NA (coluna Age)

# Imputação pela média
dados_media <- dados
mean_age <- mean(dados_media$Age, na.rm = TRUE)
dados_media$Age <- ifelse(is.na(dados_media$Age), mean_age, dados_media$Age)

any(is.na(dados_media))
colSums(is.na(dados_media))

# Imputação pela mediana
dados_mediana <- dados
median_age <- median(dados_mediana$Age, na.rm = TRUE)
dados_mediana$Age <- ifelse(is.na(dados_mediana$Age), median_age, dados_mediana$Age)

any(is.na(dados_mediana))
colSums(is.na(dados_mediana))


## Tratando valores ""

# Coluna Embarked
# Verifica quais tipos de valores tem em cada coluna
unique(dados$Embarked)

# Verifica quais tipos de valores tem em cada coluna
table(dados$Embarked)

# Substituindo valores "" pelo valor mais comum
dados_media$Embarked <- ifelse(dados_media$Embarked == "", "S", dados_media$Embarked)
dados_mediana$Embarked <- ifelse(dados_mediana$Embarked == "", "S", dados_mediana$Embarked)

any(dados_media == "")
colSums(dados_media == "")
any(dados_mediana == "")
colSums(dados_mediana == "")


# Coluna Cabin
# Verifica quais tipos de valores tem em cada coluna
unique(dados$Cabin)

# Verifica quais tipos de valores tem em cada coluna
table(dados$Cabin)

# Removendo Coluna Cabin
dados_media <- subset(dados_media, select = -Cabin)
dados_mediana <-subset(dados_mediana, select = -Cabin)


## Modificando colunas para tipo factor

# Lista de colunas a serem modificadas para o tipo fator
colunas_factor <- c("Survived", "Pclass", "Sex", "SibSp", "Parch", "Embarked")

# Aplicar a função factor a cada coluna na lista
dados_media[colunas_factor] <- lapply(dados_media[colunas_factor], as.factor)
dados_mediana[colunas_factor] <- lapply(dados_mediana[colunas_factor], as.factor)

str(dados_media)
str(dados_mediana)



#### Criando modelos de classificação 

## Divindo dados em treino e teste
indices <- createDataPartition(dados_media$Survived, p = 0.85, list = FALSE)
indices2 <- createDataPartition(dados_mediana$Survived, p = 0.85, list = FALSE)

dados_treino_media <- dados_media[indices, ]
dados_teste_media <- dados_media[-indices, ]
dados_treino_mediana <- dados_mediana[indices2, ]
dados_teste_mediana <- dados_mediana[-indices2, ]

# -> Lembrando sempre que: Treinamos o modelo com dados de TREINO e fazemos predições com dados de TESTE



## Criando Modelo Árvore de Decisão

modelo_arvore <- rpart(Survived ~ Pclass + Sex + Age + SibSp + Parch + Fare + Embarked, method = "class", data = dados_treino_media)
modelo_arvore2 <- rpart(Survived ~ Pclass + Sex + Age + SibSp + Parch + Fare + Embarked, method = "class", data = dados_treino_mediana)

modelo_arvore
modelo_arvore2

# Examinando o resultado de uma árvore de decisao
printcp(modelo_arvore)
printcp(modelo_arvore2)

# Visualizando o modelo árvore (execute uma função para o plot e outra para o texto no plot)
plot(modelo_arvore, uniform = TRUE, main = "Árvore de Decisão em R")
text(modelo_arvore, use.n = TRUE, all = TRUE)



## Criando Modelo NaiveBayes 

modelo_naive <- naiveBayes(Survived ~ Pclass + Sex + Age + SibSp + Parch + Fare + Embarked, data = dados_treino_media)
modelo_naive2 <- naiveBayes(Survived ~ Pclass + Sex + Age + SibSp + Parch + Fare + Embarked, data = dados_treino_mediana)



## Criando um Modelo de Regressão Logística

modelo_logistico <- glm(Survived ~ Pclass + Sex + Age + SibSp, family = "binomial", data = dados_treino_media)
modelo_logistico2 <- glm(Survived ~ Pclass + Sex + Age + SibSp, family = "binomial", data = dados_treino_mediana)

summary(modelo_logistico)
summary(modelo_logistico2)



# Criando um Modelo SVM

modelo_svm <- svm(Survived ~ Pclass + Sex + Age + SibSp + Parch + Fare + Embarked, data = dados_treino_media)
modelo_svm2 <- svm(Survived ~ Pclass + Sex + Age + SibSp + Parch + Fare + Embarked, data = dados_treino_mediana)



# Criando um modelo de Redes Neurais
dados_treino_media2 <- dados_treino_media
str(dados_treino_media2)

# Remover colunas não necessárias antes de codificar
dados_treino_media2 <- dados_treino_media2[, c("Survived", "Pclass", "Sex", "Age", "SibSp", "Parch", "Fare", "Embarked")]

# Converter variáveis Survived e Pclass para numérico
dados_treino_media2$Survived <- as.numeric(as.character(dados_treino_media2$Survived))
dados_treino_media2$Pclass <- as.numeric(as.character(dados_treino_media2$Pclass))
dados_treino_media2$SibSp <- as.numeric(as.character(dados_treino_media2$SibSp))
dados_treino_media2$Parch <- as.numeric(as.character(dados_treino_media2$Parch))

# Codificar variáveis categóricas usando one-hot encoding
dados_treino_media2_dummies <- model.matrix(~ . - 1, data = dados_treino_media2)

# Juntar os resultados
dados_treino_media2 <- cbind(dados_treino_media2, dados_treino_media2_dummies)

# Excluir variáveis categóricas originais
dados_treino_media2 <- dados_treino_media2[, !grepl("Sex|Embarked", colnames(dados_treino_media2))]
str(dados_treino_media2)

# Criar um modelo de Redes Neurais
modelo_rn <- neuralnet(Survived ~ ., data = dados_treino_media2, hidden = c(5, 5), linear.output = TRUE)
modelo_rn

# Plot do modelo
plot(modelo_rn)





## Previsões

previsoes_media_arvore <- predict(modelo_arvore, dados_teste_media, type = "class")
previsoes_mediana_arvore <- predict(modelo_arvore2, dados_teste_mediana, type = "class")

previsoes_media_naive <- predict(modelo_naive, dados_teste_media, type = "class")
previsoes_mediana_naive <- predict(modelo_naive2, dados_teste_mediana, type = "class")

previsoes_media_regressao <- predict(modelo_logistico, dados_teste_media)
previsoes_mediana_regressao <- predict(modelo_logistico2, dados_teste_mediana)

previsoes_media_svm <- predict(modelo_svm, dados_teste_media, type = "class")
previsoes_mediana_svm <- predict(modelo_svm2, dados_teste_mediana, type = "class")

previsoes_media_rn <- predict(modelo_rn, dados_teste_media, type = "class")




## Visualizando perfomance dos modelos

resultados_media_arvore <- cbind.data.frame(Real = dados_teste_media$Survived, predictions = previsoes_media_arvore)
resultados_mediana_arvore <- cbind.data.frame(Real = dados_teste_mediana$Survived, predictions = previsoes_mediana_arvore)

resultados_media_naive <- cbind.data.frame(Real = dados_teste_media$Survived, predictions = previsoes_media_naive)
resultados_mediana_naive <- cbind.data.frame(Real = dados_teste_mediana$Survived, predictions = previsoes_mediana_naive)

resultados_media_regressao <- cbind.data.frame(Real = dados_teste_media$Survived, predictions = as.integer(previsoes_media_regressao))
resultados_mediana_regressao <- cbind.data.frame(Real = dados_teste_mediana$Survived, predictions = as.integer(previsoes_mediana_regressao))

resultados_media_naive <- cbind.data.frame(Real = dados_teste_media$Survived, predictions = previsoes_media_svm)
resultados_mediana_naive <- cbind.data.frame(Real = dados_teste_mediana$Survived, predictions = previsoes_mediana_svm)


## Criando um vetor de TRUE/FALSE indicando previsões CORRETAS/INCORRETAS
vetor_media_arvore <- previsoes_media_arvore == dados_teste_media$Survived
vetor_mediana_arvore <- previsoes_mediana_arvore == dados_teste_mediana$Survived

table(vetor_media_arvore)                      # FALSE 27         TRUE 106
prop.table(table(vetor_media_arvore))          # FALSE 0.2030075  TRUE 0.7969925  

table(vetor_mediana_arvore)                    # FALSE 33            TRUE 100
prop.table(table(vetor_mediana_arvore))        # FALSE 0.2481203     TRUE 0.7518797 


vetor_media_naive <- previsoes_media_naive == dados_teste_media$Survived
vetor_mediana_naive <- previsoes_mediana_naive == dados_teste_mediana$Survived

table(vetor_media_naive)                      # FALSE 40         TRUE 93
prop.table(table(vetor_media_naive))          # FALSE 0.3007519  TRUE 0.6992481  

table(vetor_mediana_naive)                    # FALSE 37            TRUE 96
prop.table(table(vetor_mediana_naive))        # FALSE 0.2781955     TRUE 0.7218045 


vetor_media_regressao <- as.integer(previsoes_media_regressao) == dados_teste_media$Survived
vetor_mediana_regressao <- as.integer(previsoes_mediana_regressao) == dados_teste_mediana$Survived

table(vetor_media_regressao)                      # FALSE 101         TRUE 32
prop.table(table(vetor_media_regressao))          # FALSE 0.7593985   TRUE 0.2406015  

table(vetor_mediana_regressao)                    # FALSE 100            TRUE 33
prop.table(table(vetor_mediana_regressao))        # FALSE 0.7518797      TRUE 0.2481203 


vetor_media_svm <- previsoes_media_svm == dados_teste_media$Survived
vetor_mediana_svm <- previsoes_mediana_svm == dados_teste_mediana$Survived

table(vetor_media_svm)                      # FALSE 26         TRUE 107
prop.table(table(vetor_media_svm))          # FALSE 0.1954887  TRUE 0.8045113  

table(vetor_mediana_svm)                    # FALSE 27            TRUE 106
prop.table(table(vetor_mediana_svm))        # FALSE 0.2030075     TRUE 0.7969925 


