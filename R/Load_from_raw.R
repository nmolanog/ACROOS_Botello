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
file_nm<-"BASES ANALISIS ENTREGA F. DAB 2 EPA-2 (1)"
###load file
wb <- paste0("../data/raw/",file_nm,".xlsx")
getSheetNames(wb)
####load data
z0_cl<-read.xlsx(wb, sheet =1, colNames = TRUE,na.strings = "NA")
z0_F1<-read.xlsx(wb, sheet =2, colNames = TRUE,na.strings = "NA")
z0_F2<-read.xlsx(wb, sheet =3, colNames = TRUE,na.strings = "NA")
z0_ctr<-read.xlsx(wb, sheet =4, colNames = TRUE,na.strings = "NA")
###remove conection
remove("wb")

###create folder if it is not already created
if(!"../data/Rdata" %in% list.dirs(path="..")){
  dir.create("../data/Rdata")
}

###save files as RData
save(z0_cl,z0_F1,z0_F2,z0_ctr,file=paste0("../data/Rdata","/","acroos_raw.RData"))
setwd(oldir)
