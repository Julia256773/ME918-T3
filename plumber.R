library(plumber)
library(ggplot2)
library(jsonlite)
dados = read.csv("dados_regressao.csv")
modelo_salvar = lm(y~x+grupo, data=dados)
saveRDS(modelo_salvar, file = "modelo_regressao.rds")
options("plumber.port" = 7593)



#* @apiTitle API de Regressão Linear
#* @apiDescription Esta API possui funções de Regressão Linear

###########################################################################################
#* Inserir um novo dado
#* @param x Variável numérica preditora
#* @param y Variável numérica resposta
#* @param grupo Variável categórica
#* @post /insereDado
function(x, y, grupo) {
    nova_linha = data.frame(x, grupo, y, momento_registro = format(lubridate::now(), "%Y-%m-%dT%H:%M:%SZ")) #formatação não está sendo a mesma
    dados_atualizados = rbind(dados, nova_linha)
    readr::write_csv(dados_atualizados, file = "dados_regressao.csv")
    dados <<- read.csv("dados_regressao.csv")
}

##########################################################################################
#* Calcular parâmetros da Regressão
#* @serializer json
#* @get /parametros
function() {
    modelo <<- lm(y~x+grupo, data=dados)
    saveRDS(modelo, file = "modelo_regressao.rds")
    coeficientes = modelo$coefficients
    sigma = summary(modelo)$sigma
    nome = append(names(coeficientes), "sigma")
    valor = append(unname(coeficientes), sigma)
    df_final = data.frame(nome, valor)
    return(df_final)
}

###########################################################################################
#* Gráfico de Regressão
#* @serializer png
#* @get /grafico
function() {
  grafico = dados %>%
    ggplot(aes(x=x, y=y, col=grupo))+
    geom_point()+
    geom_smooth(method = "lm", se=F)+
    labs(col = "Grupo")+
    theme_bw()
  print(grafico)
}

###########################################################################################
#* Predição dos dados
#* @parser json
#* @serializer json
#* @post /predicaoBanco

function(req) {
  novos <- req$body
  preditos = predict(modelo_salvar, novos)
  return(preditos)
}

###########################################################################################





