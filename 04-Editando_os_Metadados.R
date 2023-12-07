# Metadados

# Configurando o diretório de trabalho
setwd("C:/Users/Julia/Desktop/CienciaDeDados/1.Big-Data-Analytics-com-R-e-Microsoft-Azure-Machine-Learning/13.Data-Munging-no-Azure-Machine-Learning")
getwd()



#### Metadados ####

# -> São os dados sobre os dados.



## Importância dos Metadados

# - A capacidade de editar metadados é valiosa porque garante que o modelo e as análises compreendam corretamente o tipo
#   de dados e suas características.

# - Isso é crucial para a construção de modelos de machine learning precisos e interpretáveis.



## Voltando ao Azure ML

# - Criar um novo experimento.
# - Carregar o Módulo com o dataset "Bike Rental UCI dataset"

# - Ao analisarmos o dataset, podemos ver que cada coluna tem seu resumo estastístico.
# - Além do resumo estatístico podemos ver também o tipo da variável (Feature Type).

# - A informação do tipo da variável represente um metadado, ou seja, um dado sobre o dado.

# - E através do Azure ML conseguimos editar estes metadados.


## Trabalhando com o Módulo Edit Metadata

# - Arrastar e soltar na área de trabalho o módulo "Edit Metadata"

# - Após ligarmos o módulo do dataset ao módulo "Edit Metadata" podemos observar o menu direito suas propriedades.

# - Ainda no menu direito, ao cliclar em "Launch column selector" podemos selecionar a variável para editar seus metadados. 

# - Após selecionarmos a variável a ser editada, basta realizar as alterações tal como em "Data type" onde podemos alterar
#   o tipo da variável (numérica, string, etc...). Podemos também definir se é tipo "categórica" ou não.


## Exemplificando

# - Após escolher a variável "season" para ser editada, voltamos ao dataset original e constatamos que apesar da variável
#   estar configurada como "numérico" ela representa as estações do ano (Primavera, Verão, Outono, Inverno), e mesmo que tenha
#   uma representação numérica (por exemplo, 1, 2, 3, 4), é mais apropriado classificá-la como uma variável categórica.

# - E assim por ter um número, o Azure ML a classificou automaticamente como numérica e cabe a nós Cientista de Dados, analisar
#   e classificar a variável com seu tipo correto.

# - Iremos editar/converter a variável season (que já está selecionada) para o tipo String

# - Agora basta clicar em "run" e conferir na porta de saída do módulo "Edit Metadata" que a variável "season" agora é do 
#   tipo String.








