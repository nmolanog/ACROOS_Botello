#######################
###load data
#######################
rm(list=ls())
options(max.print=999999)
library(pacman)
p_load(here)
p_load(openxlsx)
p_load(tidyverse)
library(bueri)
ori_dir<-getwd()
path_RData<-"../data/Rdata"
output_path<-"../outputs"

if(!output_path %in% list.dirs(path="..")){
  dir.create(output_path)
}

list.files(path = path_RData)%>%str_subset(".RData")
load(paste0(path_RData,"/", "acroos_raw",".RData"))


cl_info<-data.frame(var=colnames(z0_cl),info=unlist(z0_cl[1,]),row.names = NULL,stringsAsFactors = F)
z0_cl<-z0_cl[-1,]

cl_cvars<-c("EDAD.ACTUAL","EDAD.AL.DIAGNÓSTICO","TIEMPO.DESDE.PRIMER.SINTOMA.NO.RAYNAUD","AÑOS.DESDE.EL.DIAGNÓSTICO")
cl_idvars<-"Código1"
cl_fvars<-setdiff(colnames(z0_cl),c(cl_cvars,cl_idvars))

options(warn = 2)
for(i in cl_cvars){
  z0_cl[,i]<-as.numeric(z0_cl[,i])
}
options(warn = 1)

for(i in cl_fvars){
  z0_cl[,i]<-factor(z0_cl[,i])
}

z0_cl[,"SEXO"]<-factor(z0_cl[,"SEXO"],labels =c("M","F"))
z0_cl[,"TABAQUISMO"]<-factor(z0_cl[,"TABAQUISMO"],labels =c("Act","Ex","Nunca"))
z0_cl[,"SUBTIPO.CLÍNICO"]<-factor(z0_cl[,"SUBTIPO.CLÍNICO"],labels =c("Lim","Dif","Sin_Escl"))

vars_for_sino<-c(cl_info[cl_info$info %>% str_detect(fixed("1= si", ignore_case=TRUE)),"var"],cl_info[cl_info$info %>% str_detect(fixed("1=si", ignore_case=TRUE)),"var"])
vars_for_sino<-setdiff(vars_for_sino,c("CUMPLE.CRITERIOS","RNA.POLIII"))
summary(z0_cl[,vars_for_sino])
for(i in vars_for_sino){
  z0_cl[,i]<-factor(z0_cl[,i],labels =c("No","Si"))  
}
###merge "Pos","Pos_eco"
z0_cl[,"HAP"]<-factor(z0_cl[,"HAP"],labels =c("Neg","Pos","Pos_eco"))
z0_cl[,"AAN"]<-factor(z0_cl[,"AAN"],labels =c("[0,80]","1:160",">1:320"))
###NP<-NA
z0_cl[,"CAPILAROSCOPIA"]<-factor(z0_cl[,"CAPILAROSCOPIA"],labels =c("Temp","Act","Tard","Ines","Norm","NP"))
z0_cl[,"TOTAL.GRADO.ACROSTEOLISIS.RX"]<-factor(z0_cl[,"TOTAL.GRADO.ACROSTEOLISIS.RX"],labels =c("Norm","Dud","Evi","Sev"))
z0_cl[,"TOTAL.GRADO.ACROSTEOLISIS.POR.ECO.KOU"]<-factor(z0_cl[,"TOTAL.GRADO.ACROSTEOLISIS.POR.ECO.KOU"],labels =c("Norm","Dud","Evi","Sev"))

summary(z0_cl)
