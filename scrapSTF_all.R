#rm(list=ls())
library(RSelenium)
library(XML)
library(plyr)

setwd("/home/acsa/Leo/STF")

# 200, 445
############## FUNCOES AUXILIARES ##############

readHTMLTableChecked <- function(url){
  tabela <- try(readHTMLTable(url, header = F, stringsAsFactors = F))
  if (!('try-error' %in% class(tabela))) {
    return(tabela)
  } else {
    print("retry url")
    readHTMLTableChecked(url)
  }
}

############## DATA FRAMES VAZIOS ##############

ids_portal <- data.frame()
info <- data.frame()
andamento <- data.frame()
assunto <- data.frame()
erros <- data.frame()
arquivos <- data.frame()
dir.create("/home/acsa/Leo/STF/arquivos")

############## ID INICIAL E FINAL ##############

fisrtADI <- 2103
lastADI <- 5616

############## INICIAR SELENIUM ##############

checkForServer()
startServer()
remDrv <- remoteDriver(browserName = 'phantomjs')

############## INICIAR CAPTURA ##############

remDrv$open()
remDrv$navigate('http://www.stf.jus.br/portal/processo/listarProcesso.asp')

for (adi in fisrtADI:lastADI){
  
  id <- NA
  
  # Enquanto id e NA...
  while(is.na(id) == T){
    
    print(adi)
    
    # Navega para pesquisa para ADI de numero 'adi'  
    remDrv$findElement(using = "xpath", "//input[@id = 'numero']")$sendKeysToElement(list(as.character(adi)))
    remDrv$findElement(using = "xpath", "//input[@onclick = 'validarFormulario();']")$clickElement()
    doc <- htmlParse(remDrv$getPageSource()[[1]])
    
    # Extrai id do portal para a ADI
    posicao <- grep("ADI", unlist(xpathApply(doc, "//table[@class = 'resultadoLista']//a", xmlValue)))
    incidente <- unlist(xpathApply(doc, "//table[@class = 'resultadoLista']//a", xmlGetAttr, name = "href"))[posicao]
    link <- unique(paste("http://www.stf.jus.br/portal/processo/", substr(incidente, regexpr("verProcessoAndamento", incidente), nchar(incidente)), sep = ""))[1]
    id <- as.numeric(as.character(substr(link,nchar(link) - 6, nchar(link))))
  }
  
  # Armazena IDs
  ids_portal <- rbind(ids_portal, data.frame(adi, id))
  
  # Armazena Info Basica
  url_id <- paste0("http://www.stf.jus.br/portal/processo/verProcessoAndamento.asp?incidente=", id)
  tabela <- readHTMLTableChecked(url_id)
  
  if (length(tabela) > 0){
    info <- rbind(info, data.frame(id, tabela[[1]]))
    andamento <- rbind(andamento, data.frame(id, tabela[[2]]))
    
  } else {
    erros <- rbind(erros, data.frame(problema = "info basica", id))
    erros <- rbind(erros, data.frame(problema = "andamento", id))
  } 
  
  # id = 1494693
  # id = 1494727
  # Armazena Assunto
  url_id <- paste0("http://www.stf.jus.br/portal/processo/verProcessoDetalhe.asp?incidente=", id)
  tabela <- readHTMLTableChecked(url_id)
  tabela <- tabela[[4]]
  
  if (length(tabela) > 1){
    tabela <- data.frame(id, (tabela)[3,2])
    names(tabela) <- c("id", "assunto")
    assunto <- rbind(assunto, tabela)
  } else {
    erros <- rbind(erros, data.frame(problema = "assunto", id))  
  }
#  arquivos <- rbind(arquivos, downloadJurisprudencia("/home/acsa/Leo/STF/arquivos", id))
}

remDrv$closeWindow()
remDrv$quit()
remDrv$closeServer()

save.image("STF_All.RData")
#24 77 130 183 236 262 315
#2102