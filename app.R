credentials <- data.frame(
  user = c("xqi", "ajo","ero","aca"), # mandatory
  password = c("xqi", "ajo","ero","aca"), # mandatory
  start = c("2019-04-15"), # optinal (all others)
  expire = c(NA, NA, NA, NA),
  admin = c(FALSE, TRUE, FALSE, FALSE),
  comment = "Simple and secure authentification mechanism 
  for single 'Shiny' applications.",
  stringsAsFactors = FALSE
)
library(shinymanager)
library(xts)
source("helpers.R")
library(shinydashboard)


les_mois = c('janvier','fevrier','mars','avril','mai','juin','juillet','aout','septembre','octobre','novembre','decembre')
les_annees = c("2010","2011","2012","2013","2014","2015","2016","2017","2018","2019","2020")



ui <- dashboardPage(
  dashboardHeader(title = "Extraction données climatiques"),
  dashboardSidebar(
    sidebarMenu(
      menuItem("1- Données journalières", tabName = "jour", icon = icon("upload", class = NULL, lib = "font-awesome")),
      menuItem("2- Données mensuelles", tabName = "mois", icon = icon("chart-bar", class = NULL, lib = "font-awesome"))
      
    )
  ),
  dashboardBody(tags$head(tags$style(HTML('
        /* logo */
        .skin-blue .main-header .logo {
                              background-color: 	#006400
                              
                              }

        /* logo when hovered */
        .skin-blue .main-header .logo:hover {
                              background-color: #3fb64b;
                              }

        /* navbar (rest of the header) */
        .skin-blue .main-header .navbar {
                              background-color: #3fb64b;
                              }        

        /* main sidebar */
        .skin-blue .main-sidebar {
                              background-color: #3fb64b
                              }

        /* active selected tab in the sidebarmenu */
        .skin-blue .main-sidebar .sidebar .sidebar-menu .active a{
                              background-color: #3ab450;
                              }

        /* other links in the sidebarmenu */
        .skin-blue .main-sidebar .sidebar .sidebar-menu a{
                              background-color: 	#006400;
                              color: #ffffff;
                              }

        /* other links in the sidebarmenu when hovered */
         .skin-blue .main-sidebar .sidebar .sidebar-menu a:hover{
                              background-color: #3ab450;
                              }
        /* toggle button when hovered  */                    
         .skin-blue .main-header .navbar .sidebar-toggle:hover{
                              background-color: #ee5c22;
                              }
                              
                              
        .content-wrapper, .right-side {
                                background-color: #ffffff;                        
                                
                                
                                '))),
                tabItems(
                  # First tab content
                  tabItem( tabName = "jour",
                           
                           fluidRow(           align = 'center',
                                               
                                               titlePanel('Extraction de de données climatiques mensuelles du site infoclimat.fr'),
                                               p("Cette aplication permet l'extraction sous format", strong(".csv"),"des données climatiques, ",strong("journalières"), "pour 6 sites différents en France, pour une période choisie"),
                                               helpText(tags$u("Note")," : Le nombre total de données manquants étant très négligeable, on a opté pour une interpolation linéaire"),
                                               HTML('<hr width=20% style="border: 1px solid grey;" >'),
                                               selectInput("station", h4("Sélectionner la station"), c("(75) Paris Montsouris" = "paris-montsouris","(91) Orly- Athis-Mons" = "orly-athis-mons","(93) Le Bourget" =  "le-bourget","(44) Nantes-Atlantique" = "nantes-atlantique","(33) Bordeaux-Mérignac" = "bordeaux-merignac", "(37) Tours - Parcay-Meslay" = "tours-parcay-meslay" )),
                                               HTML('<hr width=20% style="border: 1px solid grey;" >'),
                                               h4('Choisir un intervalle'),
                                               div(style="display:inline-block; width: 150px;height: 75px;", dateInput('start','date de début', value = "2020-07-01")),
                                               div(style="display:inline-block; width: 150px;height: 75px;", img(src="arrow.jpg",width = 70,height = 35)),
                                               div(style="display:inline-block; width: 150px;height: 75px;", dateInput('end', 'date de fin', value = '2020-07-31')),
                                               radioButtons('DJ', h4("Obtenir des Degrés de jours"), choices = c("oui" = T ,"non" = F),selected = T),
                                               h4("Cliquer pour télécharger"),
                                               downloadButton("downloadData", "Télecharger"),
                                               HTML('<hr width=20% style="border: 1px solid grey;" >'),
                                               h4("obtenir des",a("données DJ mensuelles",href = "https://ahmedjou.shinyapps.io/Scarp_climat_DJmensuel/")),
                                               HTML('<hr width=20% style="border: 1px solid grey;" >'),
                                               helpText("Téléchargé depuis infoclimat.fr"),
                                               p("voir un",a("exemple",href="https://www.infoclimat.fr/climatologie-mensuelle/07156/juillet/2020/paris-montsouris.html")),
                                               img(src = "cimes.jpg", width = 23),
                                               HTML('<hr width=60% style="border: 1px solid green;" >')
                                               
                                               
                                               
                                               
                           )
                  ),
                  
                  # Second tab content
                  tabItem(tabName = "mois",
                          fluidPage(
                            
                            fluidRow(
                              titlePanel('Extraction de de données climatiques mensuelles du site infoclimat.fr'),
                              p("Cette aplication permet l'extraction sous format", strong(".csv"),"des données de DJ ", strong("mensuelles")," pour 6 sites différents en France, pour une période choisie"),
                              helpText(tags$u("Note")," : Le nombre total de données manquants étant très négligeable, on a opté pour une interpolation linéaire"),
                              HTML('<hr width=20% style="border: 1px solid grey;" >'),
                              align = 'center',
                              selectInput("station2", h4("Sélectionner la station"), c("(75) Paris Montsouris" = "paris-montsouris","(91) Orly- Athis-Mons" = "orly-athis-mons","(93) Le Bourget" =  "le-bourget","(44) Nantes-Atlantique" = "nantes-atlantique","(33) Bordeaux-Mérignac" = "bordeaux-merignac", "(37) Tours - Parcay-Meslay" = "tours-parcay-meslay" )),
                              HTML('<hr width=20% style="border: 1px solid grey;" >'),
                              
                              h4('Choisir un intervalle'),
                              div(style="display:inline-block; width: 150px;height: 75px;", selectInput('s.year','Année de départ', choices = c("2010","2011","2012","2013","2014","2015","2016","2017","2018","2019","2020","2021","2022"), selected = "2020")),
                              div(style="display:inline-block; width: 150px;height: 75px;", selectInput('s.month','mois de départ', choices = c('janvier' = "01",'fevrier' = "02",'mars' = "03",'avril' = "04",'mai' = "05",'juin' = "06",'juillet' = "07",'aout' = "08",'septembre' = "09",'octobre' = "10",'novembre' = "11",'decembre' = "12"), selected = "01")),
                              div(style="display:inline-block; width: 150px;height: 75px;", img(src="arrow.jpg",width = 70,height = 35)),
                              div(style="display:inline-block; width: 150px;height: 75px;", selectInput('e.year','Année de fin', choices = c("2010","2011","2012","2013","2014","2015","2016","2017","2018","2019","2020","2021","2022"), selected = "2020")),
                              div(style="display:inline-block; width: 150px;height: 75px;", selectInput('e.month','mois de fin', choices = c('janvier' = "01",'fevrier' = "02",'mars' = "03",'avril' = "04",'mai' = "05",'juin' = "06",'juillet' = "07",'aout' = "08",'septembre' = "09",'octobre' = "10",'novembre' = "11",'decembre' = "12"), selected = "05")),
                              h4("Cliquer pour télécharger"),
                              downloadButton("downloadData2", "Télecharger"),
                              HTML('<hr width=20% style="border: 1px solid grey;" >'),
                              h4("obtenir des",a("données journalières",href = "https://ahmedjou.shinyapps.io/Scarp_climat_journalieres/")),
                              HTML('<hr width=20% style="border: 1px solid grey;" >'),
                              helpText("Téléchargé depuis infoclimat.fr"),
                              p("voir un",a("exemple",href="https://www.infoclimat.fr/climatologie-mensuelle/07156/juillet/2020/paris-montsouris.html")),
                              
                              img(src = "cimes.jpg", width = 23),
                              HTML('<hr width=60% style="border: 1px solid green;" >')
                              
                              
                              
                              
                            )
                          )
                  )
                )
                
  ),
  
  
)

ui <- secure_app(ui)



server <- function(input, output) {

  res_auth <- secure_server(
    check_credentials = check_credentials(credentials)
  )

  data = readRDS("data/DB-Temperature-2010-2020.Rds")
  data$Date  = as.Date(data$Date,"%Y-%m-%d")

 
  output$downloadData <- downloadHandler(
    
    filename = function(){paste("infoclimat-",input$start,"-",input$end,"-",input$station,".csv",sep ='')
    }, ### WTFFFFF drtha wst fonnction w khdmat ! ?? khass nfhm server d shiny mafahm fih ta qlwa brojola
    
    content = function(file) {
      write.csv2(extraire_intervalle(input$start, input$end, DJ = input$DJ, data, input$station), file, row.names = FALSE, sep = ',')
    }    
    
  )
  
  output$downloadData2 <- downloadHandler(
    
    filename = function(){paste("infoclimat-",input$start,"-",input$end,"-",input$station2,".csv",sep ='')
    }, ### WTFFFFF drtha wst fonnction w khdmat ! ?? khass nfhm server d shiny mafahm fih ta qlwa brojola
    
    content = function(file) {
      write.csv2(Moyennes_mensuelles(input$s.year, input$s.month, input$e.year, input$e.month, data, input$station2), file, row.names = FALSE, sep = ',')
    }    
    
  )
}

shinyApp(ui = ui, server = server)

