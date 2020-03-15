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
oldir<-getwd()

####see available xlsx files to load
list.files("../data/raw")%>%str_subset(".xlsx")
###asign the apropiate name file. without xlsx extencion
file_nm<-"new_names_filed"
###load file
wb <- paste0("../data/raw/",file_nm,".xlsx")
getSheetNames(wb)
####load data
nn_cl<-read.xlsx(wb, sheet =1, colNames = TRUE,na.strings = "NA")
nn_F1<-read.xlsx(wb, sheet =2, colNames = TRUE,na.strings = "NA")
nn_F2<-read.xlsx(wb, sheet =3, colNames = TRUE,na.strings = "NA")
nn_ctr<-read.xlsx(wb, sheet =4, colNames = TRUE,na.strings = "NA")
###remove conection
remove("wb")
new_names_ls<-list(nn_cl=nn_cl,nn_F1=nn_F1,nn_F2=nn_F2,nn_ctr=nn_ctr)
###create folder if it is not already created
if(!"../data/Rdata" %in% list.dirs(path="..")){
  dir.create("../data/Rdata")
}

###save files as RData
save(new_names_ls,file=paste0("../data/Rdata","/","new_names.RData"))
setwd(oldir)
