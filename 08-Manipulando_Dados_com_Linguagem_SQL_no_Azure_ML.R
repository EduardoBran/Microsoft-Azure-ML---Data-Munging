# Manipulação de Dados com Linguagem SQL no Azure ML

# Configurando o diretório de trabalho
setwd("C:/Users/Julia/Desktop/CienciaDeDados/1.Big-Data-Analytics-com-R-e-Microsoft-Azure-Machine-Learning/13.Data-Munging-no-Azure-Machine-Learning")
getwd()



#### Manipulando Dados com Linguagem SQL no Azure ML ####



## Voltando ao Azure ML

# - Criar um novo experimento.
# - Carregar o Módulo com o dataset "Bike Rental UCI dataset"


## Manipulando Dados com SQL

# - Procurar e arrastar para área de trabalho o módulo "Apply SQL Transformation"

# - Sobre o módulo "Apply SQL Transformation" temos:

#  -> 3 portas de entrada, sendo 1ª para tabela, 2ª porta para outra tabela e a 3ª para outra tabela
#  -> 1 porta pra saída com o resultado da tabela


# - Agora vamos arrastar o módulo do dataset até a 1ª porta do módulo "Apply SQL Transformation"

# - Ao clicar no módulo "Apply SQL Transformation", no menu direito temos "linguagem sql"

# - Agora basta modificar o scrip sql no menu direito com o código que quisermos.


## Exemplificando 1

# - Levando em consideração que o dataset conectado no módulo de sql é o Bike, vamos escrever o seguinte código:

# select temp, cnt from t1;

#  -> onde t1 é nossa tabela 1 da 1ª porta de entrada
#  -> e estaremos selecionando para exibição somente as colunas temp e cnt


# - Agora basta clicar em "run" e visualizaremos somente as colunas temp e cnt do dataset.



## Exemplificando 2 (adicionando condição)

# - Vamos agora procurar e arrastar um novo módulo "Apply SQL Transformation" para exibir o seguinte código:

# select temp, cnt
# from t1
# where cnt > 420;

#  -> Desta forma estaremos retornando duas colunas e em uma dessas colunas somente onde o valor é maior que 420



## Exemplificando 3 (agrupamento)

# - Vamos agora procurar e arrastar um novo módulo "Apply SQL Transformation" para exibir o seguinte código:

# select avg(t1.cnt), weekday
# from t1
# group by weekday;

#  -> Desta forma temos a média de bicicletas alugadas por dia da semana




## Até aqui nos 3 exemplos acima foi utlizada apenas uma tabela ?

## E como manipular duas tabelas ?




## Voltando ao Azure ML

# - Criar um novo experimento.
# - Carregar os Módulos de datasets "Restaurant feature data" e "Restaurant ratings"

# - O dataset "Restaurant feature data" contém uma série de informações sobre restaurantes
# - O dataset "Restaurant ratings" contém uma série de avaliações de usuários de restaurantes.


## Manipulando Dados com SQL

# - Procurar e arrastar para área de trabalho o módulo "Apply SQL Transformation"



## Exemplificando 1 (unindo os dois datasets)

# - Iremos juntar os dados das duas tabelas em uma só.

# - Para fazermos isso precisamos de um tipo de ligação, e neste caso ambas as tabelas tem a coluna "placeID"

# - Portanto a query sql fica assim:

# select distinct t1.placeID, t1.name, t2.rating
# from t1, t2
# where t1.placeID = t2.placeID
#   and franchise = 'f'
#   and alcohol != 'No_Alcohol_Served'
#   and t2.rating = 2;

#  -> Desta forma unimos as tabelas e retornamos os valores juntamente com uma série de filtros




## Dica Adicional:

# - Utilize o módulo "Apply SQL Transformation" de maneira flexível para realizar operações mais complexas, como junção
#   de tabelas, agregações, entre outras.

# - Essa abordagem proporciona uma maneira poderosa de manipular e transformar dados usando SQL diretamente no ambiente
#   do Azure ML







