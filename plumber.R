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
    modelo = lm(y~x+grupo, data=dados)
    saveRDS(modelo, file = "modelo_regressao.rds")
    coeficientes = modelo$coefficients
    sigma = summary(modelo)$sigma
    valores = list(b0 = unname(coeficientes[1]), b1 = unname(coeficientes[2]),
                   b2 = unname(coeficientes[3]), b3 = unname(coeficientes[4]),
                   sigma = sigma)
    return(data.frame(valores))
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
#* @get /predicaoBanco
function(df) { #[{"x":10,"grupo":"A"},{"x":20,"grupo":"B"}]
  novos = fromJSON(df)
  predict(modelo, novos)
}

###########################################################################################





