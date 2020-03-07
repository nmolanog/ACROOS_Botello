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

###########################
###z0_cl
###########################
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
#summary(z0_cl[,vars_for_sino])
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

###########################
###z0_F1
###########################
F1_info<-data.frame(var=colnames(z0_F1),info=unlist(z0_F1[1,]),row.names = NULL,stringsAsFactors = F)
z0_F1<-z0_F1[-1,]
F1_idvars<-"CODIGO2"
F1_fvars<-setdiff(colnames(z0_F1),c(F1_idvars))

for(i in F1_fvars){
  z0_F1[,i]<-factor(z0_F1[,i])
}

vars_pres_aus<-F1_info[F1_info$info %>% str_detect(fixed("presente", ignore_case=TRUE)),"var"]
#summary(z0_F1[,vars_pres_aus])

for(i in vars_pres_aus){
  z0_F1[,i]<-factor(z0_F1[,i],labels =c("Pos","Neg"))  
}

z0_F1[,"ESTADO"]<-factor(z0_F1[,"ESTADO"],labels =c("CA","CTR"))
z0_F1[,"AOxRadiografiaDedoTotal"]<-factor(z0_F1[,"AOxRadiografiaDedoTotal"],labels =c("Si","No"))
z0_F1[,"ProfundidadENcorteTRANS"]<-factor(z0_F1[,"ProfundidadENcorteTRANS"],labels =c("CA","CTR"))
z0_F1[,"ProfundidadENcorteTRANS"]<-factor(z0_F1[,"ProfundidadENcorteTRANS"],labels =c("[0,0.5]","(0.5,Inf)"))
z0_F1[,"ProfundidadENcortePUNTA"]<-factor(z0_F1[,"ProfundidadENcortePUNTA"],labels =c("[0,0.5]","(0.5,Inf)"))

summary(z0_F1)

###########################
###z0_F2
###########################
F2_info<-data.frame(var=colnames(z0_F2),info=unlist(z0_F2[1,]),row.names = NULL,stringsAsFactors = F)
z0_F2<-z0_F2[-1,]
F2_idvars<-"CÓDIGO2"
F2_fvars<-setdiff(colnames(z0_F2),c(F2_idvars))

for(i in F2_fvars){
  z0_F2[,i]<-factor(z0_F2[,i])
}

vars_pres_aus<-F2_info[F2_info$info %>% str_detect(fixed("presente", ignore_case=TRUE)),"var"]
#summary(z0_F2[,vars_pres_aus])

for(i in vars_pres_aus){
  z0_F2[,i]<-factor(z0_F2[,i],labels =c("Pos","Neg"))  
}

vars_sino<-c(F2_info[F2_info$info %>% str_detect(fixed("Si=1", ignore_case=TRUE)),"var"],F2_info[F2_info$info %>% str_detect(fixed("Si= 1", ignore_case=TRUE)),"var"])
#summary(z0_F2[,vars_sino])

for(i in vars_sino){
  z0_F2[,i]<-factor(z0_F2[,i],labels =c("Si","No"))  
}


z0_F2[,"ESTADO"]<-factor(z0_F2[,"ESTADO"],labels =c("CA","CTR"))
z0_F2[,"AOporRxGRADOclasificacionKOUTAISSOF"]<-factor(z0_F2[,"AOporRxGRADOclasificacionKOUTAISSOF"],labels =c("Norm","Dud","Evi","Sev"))
z0_F2[,"AOporRxGRADOclasificacionKOUTAISSOF"]<-factor(z0_F2[,"AOporRxGRADOclasificacionKOUTAISSOF"],labels =c("Norm","Dud","Evi","Sev"))
z0_F2[,"AOporRxGRADOclasificacionKOUTAISSOF"]<-factor(z0_F2[,"AOporRxGRADOclasificacionKOUTAISSOF"],labels =c("Norm","Dud","Evi","Sev"))

summary(z0_F2)

###########################
###z0_ctr
###########################
ctr_info<-data.frame(var=colnames(z0_ctr),info=unlist(z0_ctr[1,]),row.names = NULL,stringsAsFactors = F)
z0_ctr<-z0_ctr[-1,]
ctr_idvars<-"CódigoA"
ctr_cvars<-c("EDAD.ACTUAL")
ctr_fvars<-setdiff(colnames(z0_ctr),c(ctr_idvars,ctr_cvars))

z0_ctr[,"EDAD.ACTUAL"]<-as.numeric(z0_ctr[,"EDAD.ACTUAL"])

for(i in ctr_fvars){
  z0_ctr[,i]<-factor(z0_ctr[,i])
}

z0_ctr[,"SEXO"]<-factor(z0_ctr[,"SEXO"],labels =c("F","M"))
z0_ctr[,"TABAQUISMO"]<-factor(z0_ctr[,"TABAQUISMO"],labels =c("Act","Ex","Nunca"))

summary(z0_ctr)
###save files as RData
save(z0_cl,z0_F1,z0_F2,z0_ctr,file=paste0("../data/Rdata","/","acroos_dep.RData"))
