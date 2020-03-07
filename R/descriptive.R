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
load(paste0(path_RData,"/", "acroos_dep",".RData"))

data_list<-list(z0_cl,z0_F1,z0_F2,z0_ctr)
names(data_list)<-c("cl","F1","F2","ctr")
wb <- openxlsx::createWorkbook()
wb2<- openxlsx::createWorkbook()
for(i in seq_along(data_list)){
  z0<-data_list[[i]]
  
  clvars<-col_classes(z0)
  
  z0%>%{map_dbl(.,~num.clas(.x))}->numclsz0
  numclsz0%>%.[. %in% c("1","0") | is.na(.)]%>%names->constant_vars
  
  c.vars<-setdiff(names(clvars[clvars%in%c("numeric","integer")]),constant_vars)
  d.vars<-setdiff(names(clvars[clvars%in%"factor"]),constant_vars)
  
  # summary(z0[,c.vars])
  # summary(z0[,d.vars])
  if(length(c.vars)>0){
    namesheta<-paste0(names(data_list)[i],"_cont")
    dscont_temp<-dscr1.cont(z0[,c.vars],desimales=4)
    openxlsx::addWorksheet(wb, sheetName = namesheta)
    openxlsx::freezePane(wb, sheet = namesheta, firstActiveRow = 2, firstActiveCol = 2)
    openxlsx::writeData(wb,x=dscont_temp , sheet = namesheta)
    borders_for_dscr1.cont(wb,sheet_name=namesheta,dscont_temp,borderStyle="thick")
  }
  
  dscat_temp<-dscr1.cat(z0[,d.vars],dec=4)
  nameshetb<-paste0(names(data_list)[i],"_cat")
  openxlsx::addWorksheet(wb, sheetName = nameshetb)
  openxlsx::freezePane(wb, sheet = nameshetb, firstActiveRow = 1, firstActiveCol = 2)
  openxlsx::writeData(wb,x=dscat_temp , sheet = nameshetb,colNames =F)
  borders_for_dscr1.cat(wb,sheet_name=nameshetb,dscat_temp,borderStyle="thick")
  
  openxlsx::addWorksheet(wb2, sheetName = names(data_list)[i])
  openxlsx::freezePane(wb2, sheet = names(data_list)[i], firstActiveRow = 1, firstActiveCol = 2)
  openxlsx::writeData(wb2,x=data.frame(var=colnames(z0),new_names=NA) , sheet = names(data_list)[i],colNames =T)
  
}
openxlsx::saveWorkbook(wb,paste0(output_path,"/","descriptive_v0.xlsx"),TRUE)
openxlsx::saveWorkbook(wb2,paste0(output_path,"/","new_names.xlsx"),TRUE)

