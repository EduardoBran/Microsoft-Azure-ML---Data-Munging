# Instalando Pacotes R no Azure ML

# Configurando o diretório de trabalho
setwd("~/Desktop/DataScience/CienciaDeDados/1.Big-Data-Analytics-com-R-e-Microsoft-Azure-Machine-Learning/13.Data-Munging-no-Azure-Machine-Learning")
getwd()



#### Como Instalar Pacotes R no Azure ML ####

## Acesando site R

# - Para começar, acessar o site https://cran.r-project.org
# - Clicar em "Packages" no menu lateral esquerdo
# - Clicar em "Table of available packages, sorted by name"

# - Pesquisar por "tidyr"
# - Clicar em "tidyr" no menu lateral esquerdo para exibir os detalhes do pacote

# - Agora precisamos realizar o download do pacote clicando em
#   "Windows binaries:	r-devel: tidyr_1.3.0.zip"

# - Para alguns pacotes, precisaremos também das dependências.
# - Para o nosso exemplo, precisaremos das dependências rlang e tibble. 
# - Repetir o processo de download das dependências igual ao pacote tidyr

# - É necessário realizar o download do pacote (e dependências) para instalarmos no ambiente Azure ML


# - Por fim precisamos compactar os 3 arquivos em um único arquivo zip.


## Voltando ao Azure ML

# - Criar um novo experimento.

# - Agora clicar novamente em "new" e no menu lateral esquerdo selecionar "dataset" e carregar o arquivo zip.


## Usando Pacote Carregado

# - Procurar e arrastar o módulo com o arquivo zip carregado "Pacotes.zip"
# - Procurar e arrastar o módulo "Execute R Script"
# - Conectar o módulo "Pacotes.zip" na porta 3 de entrada do módulo "Execute R Script"

# - Copiar código abaixo do arquivo "11-instalaPacotes.R' e colar no módulo "Execute R Script"


# Variável que controla a execução do script
# (Se o valor for FALSE, o codigo sera executado no RStudio.)
Azure <- TRUE

if(Azure){
  # Instala o pacote tidyr e as dependências tibble e rlang a partir do arquivo zip
  install.packages("src/rlang_1.1.2.zip", lib = ".", repos = NULL, verbose = TRUE)
  install.packages("src/tibble_3.2.1.zip", lib = ".", repos = NULL, verbose = TRUE)
  install.packages("src/tidyr_1.3.0.zip", lib = ".", repos = NULL, verbose = TRUE)
  
  require(tibble, lib.loc = ".")
  require(rlang, lib.loc = ".")
  require(tidyr, lib.loc = ".")
}else{
  install.packages("tidyr")
  require(tidyr)
}

# if(Azure) maml.mapOutputPort("dataset")



# - Modificar para CRAN R 3.1.0 e executar.

# - Agora bastaria arrastar outro módulo do "Execute R Script" e carregar o pacote "tidyr" e usá-lo.




