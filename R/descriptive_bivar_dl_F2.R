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
load(paste0(path_RData,"/", "acroos_dep_newnames",".RData"))

##########################
###descriptive z0_cl
##########################
z0<-z0_cl
summary(z0)

z0%>%{map_dbl(.,~num.clas(.x))}->numclsz0
numclsz0%>%.[. %in% c("1","0") | is.na(.)]%>%names->constant_vars
colclss_z0<-col_classes(z0)
colclss_z0["Código1"]<-"id"
colclss_z0%>%table
c.vars<-setdiff(colclss_z0%>%{.[. %in% "numeric"]}%>%names,constant_vars)
d.vars<-setdiff(colclss_z0%>%{.[. %in% "factor"]}%>%names,constant_vars)

vdep<-setdiff(c("IC","Gangrena","IC_Gang_any","IC_Gang_num","IC_Gang"),constant_vars)
summary(z0[,c.vars])
summary(z0[,d.vars])
summary(z0[,vdep])

setwd(output_path)
autores(z0,d.vars,c.vars,vdep,xlsxname ="descr_cl",fldr_name="descr_cl")
setwd(ori_dir)

##########################
###descriptive z0_F2
##########################
z0<-z0_F2
summary(z0)

z0%>%{map_dbl(.,~num.clas(.x))}->numclsz0
numclsz0%>%.[. %in% c("1","0") | is.na(.)]%>%names->constant_vars
colclss_z0<-col_classes(z0)
colclss_z0["Código2"]<-"id"
colclss_z0%>%table
c.vars<-NULL
d.vars<-setdiff(colclss_z0%>%{.[. %in% "factor"]}%>%names,constant_vars)

vdep<-setdiff(c("AO.DT_USG","AO.DT_Rx"),constant_vars)
summary(z0[,c.vars])
summary(z0[,d.vars])
summary(z0[,vdep])

setwd(output_path)
autores(z0,d.vars,c.vars,vdep,xlsxname ="descr_F2",fldr_name="descr_F2")
setwd(ori_dir)
