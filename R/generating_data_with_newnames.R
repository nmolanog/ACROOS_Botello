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
load(paste0(path_RData,"/", "new_names",".RData"))

###verify
(new_names_ls$nn_cl$var == colnames(z0_cl)) %>% all
(new_names_ls$nn_F1$var == colnames(z0_F1)) %>% all
(new_names_ls$nn_F2$var == colnames(z0_F2)) %>% all
(new_names_ls$nn_ctr$var == colnames(z0_ctr)) %>% all

###fix new names
new_names_ls$nn_cl$new_names<-new_names_ls$nn_cl$new_names%>%str_replace_all(" ",".")%>%
  str_replace_all("-","_")%>%str_replace_all("\\.\\.",".")
new_names_ls$nn_F1$new_names<-new_names_ls$nn_F1$new_names%>%str_replace_all(" Jhonston","Jhonston")%>%
  str_replace_all(" ",".")%>%str_replace_all("-","_")%>%str_replace_all("\\.\\.",".")
new_names_ls$nn_F2$new_names<-new_names_ls$nn_F2$new_names%>%str_replace_all(" ",".")%>%
  str_replace_all("-","_")
new_names_ls$nn_ctr$new_names<-new_names_ls$nn_ctr$new_names%>%str_replace_all(" ",".")%>%
  str_replace_all("\\.\\.",".")
map(new_names_ls,~.x[,"new_names"])

###assign new names
colnames(z0_cl)<-new_names_ls$nn_cl$new_names
colnames(z0_F1)<-new_names_ls$nn_F1$new_names
colnames(z0_F2)<-new_names_ls$nn_F2$new_names
colnames(z0_ctr)<-new_names_ls$nn_ctr$new_names

###new vars for z0_cl
z0_cl[,c("IC","Gangrena" )]%>%summary
cl_temp<-z0_cl[,c("IC","Gangrena" )]
cl_temp$IC<-factor(cl_temp$IC,labels = 0:1)%>%as.character%>%as.numeric()
cl_temp$Gangrena<-factor(cl_temp$Gangrena,labels = 0:1)%>%as.character%>%as.numeric()
summary(cl_temp)

z0_cl$IC_Gang_any<-z0_cl[,c("IC","Gangrena" )]%>%apply(1,function(x){any(x %in% "Si")})%>%factor(labels =c("No","Si"))
z0_cl$IC_Gang_num<-cl_temp%>%apply(1,sum)%>%factor
z0_cl$IC_Gang<-z0_cl[,c("IC","Gangrena" )]%>%apply(1,function(x){paste(c("IC","G"),x,collapse ="_",sep=":")})%>%factor

# summary(z0_cl)
# summary(z0_F1)
# summary(z0_F2)
# summary(z0_ctr)

save(z0_cl,z0_F1,z0_F2,z0_ctr,file=paste0("../data/Rdata","/","acroos_dep_newnames.RData"))