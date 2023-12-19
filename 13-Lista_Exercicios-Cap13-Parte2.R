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






####  PREVISÕES e AVALIAÇÕES

## Previsões 

# Previsões para Árvore de Decisão
previsoes_arvore_media <- predict(modelo_arvore, newdata = dados_teste_media, type = "class")
previsoes_arvore_mediana <- predict(modelo_arvore2, newdata = dados_teste_mediana, type = "class")

# Previsões para Naive Bayes
previsoes_naive_media <- predict(modelo_naive, newdata = dados_teste_media, type = "class")
previsoes_naive_mediana <- predict(modelo_naive2, newdata = dados_teste_mediana, type = "class")

# Previsões para Regressão Logística
previsoes_logistico_media_binario <- as.factor(as.numeric(previsoes_logistico_media > 0.5))
previsoes_logistico_mediana_binario <- as.factor(as.numeric(previsoes_logistico_mediana > 0.5))

# Previsões para SVM
previsoes_svm_media <- predict(modelo_svm, newdata = dados_teste_media)
previsoes_svm_mediana <- predict(modelo_svm2, newdata = dados_teste_mediana)


## Avaliações dos modelos

# Certifique-se de que a coluna "Survived" nos conjuntos de teste seja numérica para métricas de avaliação corretas.

# Exemplo de métricas para a Árvore de Decisão (substitua com as métricas relevantes para cada modelo):
confusionMatrix(previsoes_arvore_media, dados_teste_media$Survived)       # 77%
confusionMatrix(previsoes_arvore_mediana, dados_teste_mediana$Survived)   # 83%

# Exemplo de métricas para Naive Bayes
confusionMatrix(previsoes_naive_media, dados_teste_media$Survived)        # 69%
confusionMatrix(previsoes_naive_mediana, dados_teste_mediana$Survived)    # 72%

# Exemplo de métricas para Regressão Logística
confusionMatrix(previsoes_logistico_media_binario, dados_teste_media$Survived)      # 78%
confusionMatrix(previsoes_logistico_mediana_binario, dados_teste_mediana$Survived)  # 76%

# Exemplo de métricas para SVM
confusionMatrix(previsoes_svm_media, dados_teste_media$Survived)       # 80%
confusionMatrix(previsoes_svm_mediana, dados_teste_mediana$Survived)   # 79%


## Escolha do Melhor Modelo:
  
#  -> O modelo de árvore de decisão com mediana como método de imputação parece ser o melhor em termos de acurácia, sensibilidade e 
#     especificidade.




