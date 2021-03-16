### Création de grande BDD  de température depuis 2010 ###

library(imputeTS)
library(rvest)

source("C:/Users/Ahmed/Desktop/github/cimes/Projets R/R scarp/montsouris infoclimat/scarp_mois_app/helpers.R")

les_annees = c("2010","2011","2012","2013","2014","2015","2016","2017","2018","2019","2020")
Data = data.frame(Date = c(), Tmin = c(), Tmax = c(), DJC = c(), DJF = c(),station = c())

## Khdem awldl l9hba b Sapply !

## de 2010  a 2019
for(station in c("paris-montsouris","orly-athis-mons","le-bourget","nantes-atlantique","tours-parcay-meslay","bordeaux-merignac")) {

les_mois = c('janvier','fevrier','mars','avril','mai','juin','juillet','aout','septembre','octobre','novembre','decembre')
  

  for (year in les_annees){
    for (month in les_mois){
      d = Scrap_T_mois(year,month,station)
      Data = rbind (Data,d)
      print(year)
      print(month)
      print(station)
      }
  }
}

#
#
#
#
#
#
#

# test :
Data = data.frame(Date = c(), Tmin = c(), Tmax = c(), DJC = c(), DJF = c(),station = c())
for(station in c("paris-montsouris","orly-athis-mons","le-bourget")) {
  
  year = 2021
  les_mois = c('janvier') ## On ajoutera aout quand le site est mis a jorus pour le nouveau moi
  for (month in les_mois){
    d = Scrap_T_mois(year,month,station)
    Data = rbind (Data,d)
    print(year)
    print(month)
  }
}


setwd(choose.dir())
Data$Date = as.Date(Data$Date)
save(file = "DB-Temperature-2010-2020.Rds",Data)

