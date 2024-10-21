
# ME918-T3

Este repositório contém funções de Regressão Linear simples para API e
um banco de dados próprio para regressão. O conjunto de dados contém
três colunas: uma correspondente à variável resposta e duas às
covariáveis (“x” e “grupo”, sendo esta última subdividida em três
categorias: A, B e C).

## Inserir novo dado

Para inserir um novo dado, é necessário acessar o objeto “/insereDado”,
clicar em “Try it out” e preencher os campos das variáveis preditora
(x), resposta (y) e categórica (grupo) com os respectivos valores
desejados. As variáveis preditora e resposta devem ser numéricas, e a
categórica deve ser no formato string. Após clicar em “Execute”, a API
deve retornar o banco de dados atualizado com a nova observação inserida
pelo usuário, assim como a data e o horário em que a informação foi
inserida.

Por exemplo, se os campos indicados forem preenchidos tal que x = 1, y =
2 e grupo = A, a API deve retornar:

\[{banco de dados},{“x”: 1,“grupo”: “A”,“y”: 2,“momento_registro”:
“2024-10-18T17:47:06Z”}\]

É possível inserir um grupo que não existe previamente no conjunto de
dados.

## Excluir um dado

Para excluir um dado, é necessário acessar o objeto /excluiDado, clicar
em “Try it out” e preencher o campo com o id da linha que deseja
excluir. Este ID é referente à identificação do seu dado, não
necessariamente corresponde ao número da linha no qual o dado aparece no
conjunto de dados. A API retornará o banco de dados atualizado com a
observação excluída, sendo que só é possível excluir uma observação por
vez.

## Calcular Parâmetros da Regressão

Os parâmetros da regressão linear são calculados a partir do banco de
dados (já atualizado, caso um novo dado tenha sido inserido). Por isso,
é necessário apenas acessar o objeto “/parametros”, clicar em “Try it
out” e em seguida em “Execute”. A API deve retornar uma lista no formato
JSON dos valores correspondentes aos parâmetros presentes na regressão.

Por exemplo, ao calcular os parâmetros do banco de dados contido neste
repositório, a API retornará como parâmetros:

\[ { “nome”: “(Intercept)”, “valor”: -1.0332 }, { “nome”: “x”, “valor”:
0.0793 }, { “nome”: “grupoB”, “valor”: 1.5209 }, { “nome”: “grupoC”,
“valor”: 2.9136 }, { “nome”: “grupoD”, “valor”: 3.7435 }, { “nome”:
“sigma”, “valor”: 2.2833 }\]

## Calcular Resíduos e Valores Preditos

Para calcular os resíduos e os valores preditos para os dados observados
é necessário acessar a rota /residuosEPreditos, clicar em “Try it out” e
em seguida em “Execute”. A API deve retornar um data frame no formato
JSON com os valores correspondentes aos resíduos e aos valores preditos
do modelo ajustado.

## Predição para novos valores

Para realizar uma predição a partir do banco de dados, é necessário
abrir uma nova janela no R e ter um dataframe salvo dos valores que
deseja inserir para predição. Neste dataframe deve conter uma coluna de
nome “x” com os valores desejados para a variável x e uma coluna de nome
“grupo” com os valores desejados para esta variável, como o exemplo
abaixo:

``` r
body = data.frame(x = c(3,4), grupo = c("A", "B"))
body
#>   x grupo
#> 1 3     A
#> 2 4     B
```

Após rodar a API (e mantê-la aberta) e ter esse dataframe salvo em outra
página do R, rode o seguinte comando na mesma em que tem o objeto
“body”:

``` r
library(httr2)
request("http://127.0.0.1:7593/predicaoBanco") |>
+ req_method("POST") |>
+ req_body_json(data=body, auto_unbox = TRUE) |>
+ req_perform() |>
+ resp_body_string()
```

Você terá como resposta uma lista dos valores preditos na ordem dos
preditores do seu dataframe.

## Gráfico de Regressão

Para gerar um gráfico de pontos com a reta de regressão ajustada para
cada variável categórica presente no banco, é necessário acessar o
objeto “/grafico”. Em seguida, clique em “Try it out” e em “Execute”. A
API deve retornar um gráfico com os dados e as retas coloridos de acordo
com os grupos aos quais pertencem, além da legenda das cores.

Por exemplo, ao gerar um gráfico a partir do banco de dados contido
neste respositório e seus parâmetros, a API retornará a seguinte imagem:

![](README_files/figure-gfm/unnamed-chunk-5-1.png)<!-- -->

## Gráficos de Resíduos

Para obter os gráficos de resíduos é necessário acessar a rota
“/graficosResiduos”, clicar em “Try it out” e em “Execute”. A API deve
retornar uma imagem com 6 gráficos: Valores predidos x Valores
observados; QQplot dos resíduos; Valores preditos x Resíduos; Histograma
dos resíduos; Número da observação x Resíduos; e Boxplot dos resíduos.

Por exemplo, ao gerar os gráficos de resíduos a partir do banco de dados
contido neste respositório, a API retornará a seguinte imagem:

![](README_files/figure-gfm/unnamed-chunk-6-1.png)<!-- -->
