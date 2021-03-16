library(xts)


extraire_intervalle <- function(start,end, DJ, data, station){
  dates = seq(as.Date(start),as.Date(end),by = "days")
  if(DJ){
    return(data[data$Date %in% dates & data$station == station,-6])
  } else{
    return(data[data$Date %in% dates & data$station == station ,c(1,2,3)])
  }
}

### CAll library f l 'application !
Moyennes_mensuelles <- function(s.year, s.month, e.year, e.month,Data,station){
  
  Data = Data[Data$station == station, ]
  
  
  ### nombre de jours
  if(e.month %in% c('01', '03', '05', '07', '08', '10', '12')){
    N=31
  } else if(e.month %in% c('04', '06', '09', '11')){
    N = 30
  } else if(e.month == '02' & e.year %in% c('2024','2020','2016','2012','2008')){
    N = 29
  } else { N = 28}
  start_date = as.Date(paste(s.year, s.month,'1', sep = '-'))
  end_date = as.Date(paste(e.year, e.month,as.character(N), sep = '-'))
  Date.seq = seq(start_date,end_date,by = "day")
  data = Data[Data$Date %in% Date.seq, ]
  
  DJC =xts(data$DJC, order.by = data$Date)
  DJF =xts(data$DJF, order.by = data$Date)
  
  DJC.month.mean = apply.monthly(DJC, sum)
  dates = as.Date(index(DJC.month.mean))
  DJF.month.mean = apply.monthly(DJF, sum)
  
  csv = data.frame(Dates = dates, DJC.Sum = DJC.month.mean, DJF.Sum = DJF.month.mean)
  
  return(csv)
}

