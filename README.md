
# ME918-T3

Este repositório contém funções de Regressão Linear simples para API.

## Inserir novo dado

Para inserir um novo dado, é necessário acessar o objeto "/insereDado", clicar em "Try it out" e preencher os campos das variáveis preditora (x), resposta (y) e categórica (grupo) com os respectivos valores desejados. As variáveis preditora e resposta devem ser numéricas, e a categórica deve ser no formato string.

Exemplo

Após clicar em "Execute", a API deve retornar o banco de dados atualizado com a nova observação inserida pelo usuário. 

## Calcular Parâmetros da Regressão

Os parâmetros da regressão linear são calculados a partir do banco de dados (já atualizado, caso um novo dado tenha sido inserido). Por isso, é necessário apenas acessar o objeto "/parametros", clicar em "Try it out" e em seguida em "Execute". 

Exemplo

A API deve retornar uma lista no formato JSON dos valores correspondentes aos parâmetros presentes na regressão.

## Gráfico de Regressão

Para gerar um gráfico de pontos com a reta de regressão ajustada para cada variável categórica presente no banco, é necessário acessar o objeto "/grafico". Em seguida, clique em "Try it out" e em "Execute". 

Exemplo

A API deve retornar um gráfico com os dados e as retas coloridos de acordo com os grupos aos quais pertencem, além da legenda das cores.

## Predição dos dados

Para realizar uma predição a partir do banco de dados, é necessário acessar o objeto "/predicaoBanco" e clicar em "Try it out". Em seguida, as informações das variáveis preditoras e categórica devem ser inseridas no campo "df" no formato JSON. 

Exemplo com uma, duas e três variáveis; fazer comentarios sobre o formato de escrita JSON

Após clicar em "Execute", a API deve retornar os valores preditos em formato JSON. O resultado será um valor predito para cada grupo de informações inseridas para realizar a predição.
