############ ORGANIZACAO DOS DADOS ############
############ INFORMACOES BASICAS ############

rm(list = ls())
load("~/Leo/STF/stf20161026_1.RData")

for (i in 1:3){
  info[,i] <- iconv(info[,i])
}

# Origem
origem <- info[info$V1 == "Origem:" & is.na(info$V1) == F, c(1, 3)]
names(origem)[2] <- "origem"
origem <- merge(ids_portal, origem, by = "id", all.x = F, all.y = T)
head(origem)

# Relator atual
relator <- info[info$V1 == "Relator atual" & is.na(info$V1) == F, c(1, 3)]
names(relator)[2] <- "relator"
relator <- merge(ids_portal, relator, by = "id", all.x = F, all.y = T)
head(relator)

# Requerente
requerente <- info[info$V1 == "REQTE.(S)" & is.na(info$V1) == F, c(1, 3)]
names(requerente)[2] <- "requerente"
requerente <- merge(ids_portal, requerente, by = "id", all.x = F, all.y = T)
head(requerente)

# Intimado
intimado <- info[info$V1 == "INTDO.(A/S)" & is.na(info$V1) == F, c(1, 3)]
names(intimado)[2] <- "intimado"
intimado <- merge(ids_portal, intimado, by = "id", all.x = F, all.y = T)
head(intimado)

# Advogado
advogado <- info[info$V1 == "ADV.(A/S)" & is.na(info$V1) == F, c(1, 3)]
names(advogado)[2] <- "advogado"
advogado <- merge(ids_portal, advogado, by = "id", all.x = F, all.y = T)
head(advogado)

# Amicus Curiae
amicus <- info[info$V1 == "AM. CURIAE." & is.na(info$V1) == F, c(1, 3)]
names(amicus)[2] <- "amicus"
amicus <- merge(ids_portal, amicus, by = "id", all.x = F, all.y = T)
head(amicus)

# Apenso principal
apenso.principal <- info[info$V1 == "Apenso principal:" & is.na(info$V1) == F, c(1, 3)]
names(apenso.principal)[2] <- "apenso.principal"
apenso.principal <- merge(ids_portal, apenso.principal, by = "id", all.x = F, all.y = T)
head(apenso.principal)

# Procurador
procurador <- info[info$V1 == "PROC.(A/S)(ES)" & is.na(info$V1) == F, c(1, 3)]
names(procurador)[2] <- "procurador"
procurador <- merge(ids_portal, procurador, by = "id", all.x = F, all.y = T)
head(procurador)

# Procurador
processos.apensados <- info[info$V1 == "Processo(s) apensado(s):" & is.na(info$V1) == F, c(1, 3)]
names(processos.apensados)[2] <- "processos.apensados"
processos.apensados <- merge(ids_portal, processos.apensados, by = "id", all.x = F, all.y = T)
head(processos.apensados)

# Redator
redator <- info[info$V1 == "Redator para acordão" & is.na(info$V1) == F, c(1, 3)]
names(redator)[2] <- "redator"
redator <- merge(ids_portal, redator, by = "id", all.x = F, all.y = T)
head(redator)

############ ORGANIZACAO DOS DADOS ############
############ ASSUNTO ############

assunto.raw <- assunto
for (i in 1:3){
  assunto.raw[,i] <- iconv(assunto.raw[,i])
}

# Assunto
assunto <- assunto.raw[assunto.raw$assunto == "Assunto" & is.na(assunto.raw$assunto) == F, c(1, 3)]
names(assunto)[2] <- "assunto"
assunto <- merge(ids_portal, assunto, by = "id", all.x = F, all.y = T)
tail(assunto)

# Data de Protocolo
data.protocolo <- assunto.raw[assunto.raw$assunto == "Data de Protocolo" & is.na(assunto.raw$assunto) == F, c(1, 3)]
names(data.protocolo)[2] <- "data.protocolo"
data.protocolo <- merge(ids_portal, data.protocolo, by = "id", all.x = F, all.y = T)
head(data.protocolo)

############ ORGANIZACAO DOS DADOS ############
############ ASSUNTO ############

for (i in 1:6){
  andamento[,i] <- iconv(andamento[,i])
}

names(andamento) <- c("id", "data", "andamento", "orgao.julgador", "observacao", "documento")
andamento <- andamento[andamento$andamento != "Andamento", ]
andamento <- merge(ids_portal, andamento, by = "id", all.x = F, all.y = T)
head(andamento)
