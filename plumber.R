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
    nova_linha = data.frame(id = max(dados$id)+1, x, grupo, y, momento_registro = format(lubridate::now(), "%Y-%m-%dT%H:%M:%SZ")) #formatação não está sendo a mesma
    dados_atualizados = rbind(dados, nova_linha)
    readr::write_csv(dados_atualizados, file = "dados_regressao.csv")
    dados <<- read.csv("dados_regressao.csv")
}

###########################################################################################
#* Excluir um dado
#* @param id ID da linha a ser excluída
#* @post /excluiDado
function(id) {
  linha = which(dados$id == id)
  dados_novos = dados[-linha, ]
  readr::write_csv(dados_novos, file = "dados_regressao.csv")
  dados <<- read.csv("dados_regressao.csv")
  dados
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
#* Calcular os resíduos e os valores preditos
#* @serializer json
#* @get /residuosEPreditos
function() {
  residuos = summary(modelo_salvar)$residuals
  preditos = modelo_salvar$fitted.values
  df = data.frame(residuos, preditos)
  return(df)
}

###########################################################################################
#* Gráfico dos Resíduos
#* @serializer png
#* @get /graficosResiduos
graficos_residuos = function(){
  residuos = summary(modelo_salvar)$residuals
  preditos = modelo_salvar$fitted.values

  df = data.frame(residuos, preditos)

  df_combinado = cbind(df, dados)

  graf1 = ggplot(data = df_combinado, aes(x = preditos, y = y)) +
    geom_point() +
    theme_bw() +
    labs(x = "Valores Preditos", y = "Valores observados")

  graf2 = ggplot(data = df_combinado, aes(sample = residuos)) +
    stat_qq(color = "black") +
    stat_qq_line(color = "blue") +
    theme_bw() +
    labs(x = "Quantis teóricos", y = "Quantis amostrais")

  graf3 = ggplot(data = df_combinado, aes(x = preditos, y = residuos)) +
    geom_hline(yintercept = 0, color = "blue") +
    geom_point() +
    theme_bw() +
    labs(x = "Valores Preditos", y = "Resíduos")

  graf4 = ggplot(data = df_combinado, aes(x = residuos)) +
    geom_histogram(aes(y = after_stat(density)), binwidth = 1, fill = "gray", color = "black") +
    geom_density(color = "blue", linewidth = 1) +
    theme_bw() +
    labs(y = "Densidade", x = "Resíduos")

  graf5 = ggplot(data = df_combinado, aes(x = seq_along(y), y = residuos)) +
    geom_hline(yintercept = 0, color = "blue") +
    geom_point() +
    theme_bw() +
    labs(x = "Índice da observação", y = "Resíduos")

  graf6 = ggplot(data = df_combinado, aes(y = residuos)) +
    geom_boxplot(fill = "gray", color = "black") +
    theme_minimal() +
    labs(y = "Resíduos") +
    theme(axis.text.x = element_blank())

  graficos = ggpubr::ggarrange(graf1, graf2, graf3, graf4, graf5, graf6,
                               ncol = 2, nrow = 3)

  print(graficos)
}




