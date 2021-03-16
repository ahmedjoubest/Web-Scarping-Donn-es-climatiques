## mois : entrer sans accents ! 
library(imputeTS)
library(rvest)

## bourget boulogne 93 62
"paris-montsouris"
"orly-athis-mons"
"le-bourget"

Scrap_T_mois <- function(year,month,station){
  
  ## indicatif dans le lien !
  if (station == "paris-montsouris"){
    indicatif = "07156"
  } else if (station == "le-bourget") {
    indicatif = "07150"
  } else if (station == "orly-athis-mons"){
    indicatif = "07149"
  } else if (station == "nantes-atlantique"){
    indicatif = "07222"
  } else if (station == "tours-parcay-meslay"){
    indicatif = "07240"
  } else if (station == "bordeaux-merignac"){
    indicatif = "07510"
  }
  
  
  ## Test nombre de jours du mois
  if(month %in% c('janvier', 'mars', 'mai', 'juillet', 'aout', 'octobre', 'decembre')){
    N=31
  } else if(month %in% c('avril', 'juin', 'septembre', 'novembre')){
    N = 30
  } else if(month == 'fevrier' & year %in% c('2024','2020','2016','2012','2008')){
    N = 29
  } else { N = 28}
  ## Lecture de la table dans HTML
  URL <- paste("https://www.infoclimat.fr/climatologie-mensuelle/", indicatif, "/" , month,"/",year ,"/", station, ".html", sep = '')
  site <- read_html(URL)
  tbls_ls <- site %>%
    html_nodes("table") %>%
    html_table(fill = TRUE)
  a = tbls_ls[[2]]
  a = a[grepl("date_range", a[,1]),]
  a = a[,c(2,3)]
  a <- as.data.frame(a)
  for(i in 1:nrow(a)){
    for(j in 1:ncol(a)){
      a[i,j] <- as.numeric(unlist(strsplit(as.character(a[i,j]),'\n',fixed = T))[2])
    }
  }
  a = a[!is.na(a[,1]),]
  a## Tmin :
  Temp_min = as.numeric(a[,1])
  Temp_min = na.interpolation(Temp_min)
  ## Tmax :
  Temp_max = as.numeric(a[,2])
  Temp_max = na.interpolation(Temp_max)
  
  ## test validité

  
  ## Dates :
  
  ## numerotation du mois
  les_mois = c('janvier','fevrier','mars','avril','mai','juin','juillet','aout','septembre','octobre','novembre','decembre')
  mois_n = which(les_mois == month)
  ## Vecteur Date :
  Date <- sapply(1:N,function (N) paste(year,mois_n,N,sep='-'))
  Date <- Date[1:nrow(a)]
  
  
  ## Les vecteurs des indices xqi
  #DJC = 
  
  #DJF = 
  
  Data = data.frame(Date = Date, Tmin = as.numeric(Temp_min), Tmax = as.numeric(Temp_max), DJC = numeric(nrow(a)), DJF = numeric(nrow(a)), station = rep(station,nrow(a)))
  S=18
  for(i in 1:nrow(Data)){
    Tn = Data$Tmin[i]
    Tx = Data$Tmax[i]
    if(!(!is.na(Tn)&!is.na(Tx))){
      Data$DJC[i] = NA
      Data$DJF[i] = NA
      next
    }
    Moy = (Tn+Tx)/2
    if(S>Tx){
      Data$DJC[i] = S - Moy
      Data$DJF[i] = 0
    }
    if(S<=Tn){
      Data$DJC[i] = 0
      Data$DJF[i] = Moy - S
    }
    if(S>Tn & S<= Tx){
      Data$DJF[i] = (Tx -S)*(0.08 + 0.42*(Tx-S)/(Tx-Tn))
      Data$DJC[i] = (S-Tn)*(0.08+0.42*(S-Tn)/(Tx-Tn))
    } 
  
  }
    
  return(Data)
}


