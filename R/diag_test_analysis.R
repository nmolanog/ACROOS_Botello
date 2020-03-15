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
p_load(epiR)
ori_dir<-getwd()
path_RData<-"../data/Rdata"
output_path<-"../outputs"

if(!output_path %in% list.dirs(path="..")){
  dir.create(output_path)
}

list.files(path = path_RData)%>%str_subset(".RData")
load(paste0(path_RData,"/", "acroos_dep_newnames",".RData"))

over_all_table<-z0_F2[,c("AO.DT_Rx","AO.DT_USG")]%>%table
overall_ana<-epi.tests(over_all_table)

nested_ana<-list()
for(i in levels(z0_F2$koutaissof.DT_Rx)){
  temp_table<-z0_F2[z0_F2$koutaissof.DT_Rx %in% i,c("AO.DT_Rx","AO.DT_USG")]%>%table
  nested_ana[[i]]<-epi.tests(temp_table)
}
nested_ana[["all"]]<-overall_ana


