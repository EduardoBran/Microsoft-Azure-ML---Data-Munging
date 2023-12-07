# Tratamento de Dados Duplicados e Missing

# Configurando o diretório de trabalho
setwd("C:/Users/Julia/Desktop/CienciaDeDados/1.Big-Data-Analytics-com-R-e-Microsoft-Azure-Machine-Learning/13.Data-Munging-no-Azure-Machine-Learning")
getwd()



#### Tratamento de Dados Duplicados e Missing ####


## Voltando ao Azure ML

# - Criar um novo experimento.
# - Carregar o Módulo com o dataset "Bike Rental UCI dataset"

# - Ao analisarmos o dataset, ao verificar o resumo de cada variável, podemos ver o campo "Missing Values" que indica se
#   a variável selecionada tem ou não algum valor faltante.


# -> Dica: antes de iniciar o trabalho, registrar se as variáveis possuem valores missing ou duplicados.



## REMOVENDO VALORES MISSING

# - Ao análisar a variável "cnt" podemos constatar que originalmente seu "Missing Values" é zero. 

# - Iremos primeiramente editar esta variável para que ela tenha alguns valores faltantes e na sequência iremos tratar isso.



# - Vamos então arrastar o módulo "Execute R Script" e colocar o código abaixo:


# Map 1-based optional input ports to variables
df <- maml.mapInputPort(1) # class: data.frame

# Provocando valores missing
df$cnt <- ifelse(df$cnt < 20, NA, df$cnt)  # se o valor de cnt for menor que 20, este valor será NA, se não é mantido o valor original

# Select data.frame to be sent to the output Dataset port
maml.mapOutputPort("df")


# - Agora ao clicar em "run", podemos verificar que existem milhares de valores missing na variável "cnt"


# - Agora vamos resolver o problema dos dados missing

# - Vamos utilizar o módulo "Clean Missing Data", vamos arrasta-lo e colar no área de trabalho.

# - Conectar a 1ª porta de saída do módulo "Execute R Script" na 1ª porta de entrada do módulo "Clean Missing Data"

# - Clicar no módulo "Clean Missing Data" e no menu direito selecionar a(s) coluna(s) desejada (neste caso, a coluna "cnt")

# - Ainda no menu direito, após selecionar a variável ou as variáveis podemos dizer se iremos querer limpar todos os valores
#   missing ou somente um valor específico de valores.

# - Poderemos também escolher o que fazer com os valores missing, se iremos querer deleta-los ou substitui-los por outro valor.
#   Para este exemplo escolheremos "Remove entire row" para removermos a linha inteira.





## TRATANDO VALORES DUPLICADOS

# - Assim comos os valores missing/ausentes podem ser um problema, os valores duplicados também podem ser um problema.
#   Afinal durante o treinamento de ML, o mesmo irá detectar muitos valores repetidos e isso ocasionará em problema de generalização.


# - Procurar e arrastar o módulo "Remove Duplicate Rows"
# - Agora vamos conectar o módulo já utilizando anteriormente "Clean Missing Data" ao módulo de tratamento de valores duplicados.

# - Agora no menu direito iremos selecionar a coluna que queremos verificar se tem valores duplicados.

# - Uma boa prática é sempre selecionar a coluna que contém a chave primária, uma espécie de id.

# - Para o nosso exemplo, escolhemos a coluna "dteday" que por ser uma coluna de data, ela PODE significar uma data/registro
#   único de pessoas. Portanto neste caso, dependendo de como a coluna data está definida, ela pode ser o id.


# - Após selecionar a colunada "dteday" , basta clicar em "run" e verificar o resultado.









