library(imputeTS)
library(rvest)

source("/srv/shiny-server/Web-Scarping-Donn-es-climatiques/mizajor/helpers.R")
Data = readRDS("/srv/shiny-server/Web-Scarping-Donn-es-climatiques/data/DB-Temperature-2010-2020.Rds")

les_mois = c('janvier','fevrier','mars','avril','mai','juin','juillet','aout','septembre','octobre','novembre','decembre')

Date = as.character(Sys.Date())
year = substr(Date,1,4)
mois = substr(Date,6,7)
Mois = les_mois[as.integer(mois)]
day = substr(Date,9,10)

b = data.frame(Date = c(), Tmin = c(), Tmax = c(), DJC = c(), DJF = c(),station = c())
for(station in c("paris-montsouris","orly-athis-mons","le-bourget","nantes-atlantique","tours-parcay-meslay","bordeaux-merignac")) {
    d = Scrap_T_mois(year,Mois,station)
    print(year)
    print(Mois)
    print(station)
    b = rbind(b,d)
}

b$Date  = as.Date(b$Date,"%Y-%m-%d")
b = b[which(b$Date <= Sys.Date()),]

Data$Date  = as.Date(Data$Date,"%Y-%m-%d")
Data = Data[which(Data$Date < min(b$Date)),]
Data = rbind(Data,b)

append_fct = function(){
  setwd("/srv/shiny-server/Web-Scarping-Donn-es-climatiques/data")
  saveRDS(Data,"DB-Temperature-2010-2020.Rds")
}

append_fct()

