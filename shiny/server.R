library(shiny)
library(dplyr)
library(RPostgreSQL)
library(ggplot2)
library(DT)
library(rworldmap)
library(maps)
library(sp)
library(leaflet)
library(gsubfn)
library(RColorBrewer)


if ("server.R" %in% dir()) {
  setwd("..")
}
#source("4.Baza/auth.R")
source("auth_public.R")

#########################################################

shinyServer(function(input, output) {
  #  Vzpostavimo povezavo
  conn <- src_postgres(dbname = db, host = host,
                       user = user, password = password)
  #  Pripravimo tabelo

  tbl.player <- tbl(conn, "player")
  tbl.statistics <- tbl(conn, "statistics") %>% inner_join(tbl.player %>% select(player = id, name))
  tbl.location <- tbl(conn, "location")
  tbl.tournament <- tbl(conn, "tournament") %>% 
    inner_join(tbl.location %>% select(city = city, country, continent))
  
  tbl.head2head <- tbl(conn, "head2head") %>% left_join(tbl.player %>% select(player = id, PLAYER=name)) %>%
     left_join(tbl.tournament %>% select(tournament = tourn_id, YEAR=year)) %>%
     left_join(tbl.tournament %>% select(tournament = tourn_id, TOURNAMENT=name)) %>%
     left_join(tbl.player %>% select(opponent = id, OPPONENT=name))
  #tbl.head2head <- tbl.head2head %>% left_join(tbl.tournament %>% select(tournament = tourn_id, name, year))
  


  t <- tbl.statistics %>% select(Name=name, Won = won, Loss = loss, SPW = perc_spw, Aces = aces, DFS = dfs, RPW = perc_rpw, BPOC = perc_bpoc,  Tiebrak_Won = tiebreak_w, 
                                 Tiebreak_Loss = tiebreak_l, Season = season) #%>% data.frame()

  igralec <- tbl.player %>% select(id, name) %>% data.frame()
  turnirji <- tbl.tournament %>% group_by(name) %>%
    summarise() %>% arrange(name) %>% data.frame()
  sezone <- tbl.tournament %>% group_by(year) %>%
    summarise() %>% arrange(year) %>% data.frame()
  
  values <- reactiveValues(selectedPlayer = NULL,
                           dropdownPlayer = NULL,
                           dropdownOpponent = NULL,
                           dropdownSeason = NULL,
                           dropdownTournament = NULL)
  
  output$sta <- DT::renderDataTable({
    # Naredimo poizvedbo

    stolpci <- input$izberi_stat
    validate(need(!is.null(input$tenisaci) && !is.null(input$leto), ""))
      if (input$tenisaci != "All") {
        t <- t %>% filter(name == input$tenisaci) %>% select( -Name) #%>% data.frame()
      } else {
        stolpci <- c("Name", stolpci)
      }
      if (input$leto != "All") {
        t <- t %>% filter(season == input$leto) %>% select(-Season) #%>% data.frame()
      } else {
        stolpci <- c(stolpci, "Season")
      }
          

    t <- t %>% data.frame()
    validate(need(nrow(t) > 0, "No attacks match the criteria."))
    t[,stolpci]
  })

  
  
  output$tenisaci <- renderUI({
    igralci <- data.frame(tbl.player)
    selectInput("tenisaci", "Choose a player:",
                choices = c('All', setNames(igralci$name,
                                            igralci$name)))
  })
  
  stat <- data.frame(tbl.statistics)
  output$leto <- renderUI({
    selectInput("leto", "Choose a year:",
                choices = c('All', setNames(stat$season,
                                            stat$season)))

    
  })
  
  stat1 <- tbl.statistics %>% select(Name=name, Won = won, Loss = loss, SPW = perc_spw, Aces = aces, DFS = dfs, RPW = perc_rpw, BPOC = perc_bpoc,  Tiebrak_Won = tiebreak_w, 
                                 Tiebreak_Loss = tiebreak_l, Season = season) %>% data.frame()
  output$statistike <- renderUI({
    checkboxGroupInput(inputId='izberi_stat', label='Choose statistics:',
                       choices=colnames(stat1)[!colnames(stat1) %in% c('Season', 'Name', 'Player')],
                       selected=colnames(stat1)[!colnames(stat1) %in% c('Season', 'Name', 'Player')])
  })
  
  
  tur <- tbl.tournament %>% select(Name=name, Year=year, Surface=surface, Category=category, Aces_Per_Match=apm,
                                   Points_Per_Match=ppm, Games_Per_Match=gpm, City=city, Country=country,
                                   Continent=continent) %>% data.frame()
  
  output$sta_tour <- DT::renderDataTable({
    # Naredimo poizvedbo    
          if (input$leto_t != "All") {
            tur <- tur %>% filter(Year == input$leto_t) %>% select(-Year) %>% data.frame()
          }
          if (input$turn != "All") {
            tur <- tur %>% filter(Name == input$turn) %>% select(-Name) %>% data.frame()
          }
          if (input$podlaga !='All') {
            tur <- tur %>% filter(Surface == input$podlaga) %>% select(-Surface) %>% data.frame()
          }
      
    validate(need(nrow(tur) > 0, "No tournaments match the criteria."))
    tur
  })
  
  
  output$turn <- renderUI({
    tour <- data.frame(tbl.tournament)
    selectInput("turn", "Choose a tournament:",
                choices = c("All", setNames(tour$name,
                                               tour$name)))
    
  })
  
  output$leto_t <- renderUI({
    tour <- data.frame(tbl.tournament)
    selectInput("leto_t", "Choose a year:",
                choices = c('All', setNames(tour$year, 
                                            tour$year)))
    
  })
  
  output$podlaga <- renderUI({
    tour <- data.frame(tbl.tournament)
    selectInput("podlaga", "Choose a surface:",
                choices = c("All", setNames(tour$surface,
                                            tour$surface)))
  })
  
  
    #inner_join(tbl.player, tbl.head2head, by = c("player"="name"))#tbl.head2head %>% select(Tournament = tournament) %>% data.frame()
  
    
    output$head <- DT::renderDataTable({
      #Naredimo poizvedbo
      h <- tbl.head2head
      if (!is.null(input$tenisac) && input$tenisac != "All"){
        h <- h %>% filter(player == input$tenisac)
      }
      if (!is.null(input$turnir) && input$turnir != "All"){
        h <- h %>% filter(TOURNAMENT == input$turnir)
      }
      if (!is.null(input$toleto) && input$toleto != "All"){
        h <- h %>% filter(YEAR == input$toleto)
      }
      if (!is.null(input$nasprotnik) && input$nasprotnik != "All"){
        h <- h %>% filter(opponent == input$nasprotnik)
      }
      h <- h %>% data.frame()
      validate(need(nrow(h)>0, "No data match the criteria."))
      data.frame(Tournament = h$TOURNAMENT,
                 Year = h$YEAR,
                 Player = apply(h, 1, . %>%
                                  {actionLink(paste0("player", .["player"]),
                                              .["PLAYER"],
                                              onclick = 'Shiny.onInputChange(\"player_link\",  this.id)')} %>%
                                  as.character()),
                 Opponent = apply(h, 1, . %>%
                                    {actionLink(paste0("player", .["opponent"]),
                                                .["OPPONENT"],
                                                onclick = 'Shiny.onInputChange(\"player_link\",  this.id)')} %>%
                                    as.character()))
  }, escape = FALSE, selection = 'none')
  
  output$tenisac <- renderUI({
    selectInput ("tenisac", "Choose a player:",
                 choices = c("All" = "All", setNames(igralec$id, igralec$name)),
                 selected = values$dropdownPlayer)
  })
  
  output$turnir <- renderUI({
    
    selectInput("turnir", "Choose a tournament:",
                choices = c("All", turnirji),
                selected = values$dropdownTournament)
  })
  
  output$toleto <- renderUI({
    selectInput("toleto", "Choose a year:",
                choices = c("All", sezone),
                selected = values$dropdownSeason)
  })
  
  output$nasprotnik <- renderUI({
    selectInput("nasprotnik", "Choose an opponent:",
                choices = c("All" = "All", setNames(igralec$id, igralec$name)),
                selected = values$dropdownOpponent)
  })
  
  
  #ZEMLJEVID
  output$map <- renderLeaflet({
    HH<- tbl.player %>% select(country, id)
    HH <- HH %>% group_by (id, region=country) %>%
      summarise() %>% group_by(region) %>%
      summarise (stevilo = count(id)) %>% data.frame
    nap <- setNames (HH$stevilo, HH$region) #spravimo st ljudi v poimenovan vektor
    zem <- map("world", regions = HH$region, fill=TRUE, plot=FALSE)
    imena <- zem$names
    igralci <- nap[imena]
    popup <- paste0("<b>", imena, "</b><br /><i> Number of players </i>:", igralci)
    df <- ecdf(nap)
    barve <- brewer.pal(n=9, name="YlOrRd")[8*df(igralci)+1]
    leaflet (data = zem) %>% addTiles() %>%
      addPolygons (fillColor = barve, stroke = FALSE, popup=popup)
    
    
  })

  output$h2hTitle <- renderUI({
    if (is.null(values$selectedPlayer)) {
      name <- "Head To Head Statistics"
    } else {
      name <- tbl.player %>% filter(id == values$selectedPlayer) %>%
        select(name) %>% data.frame() %>% .[1,1]
    }
    h2(name)
  })
  
  output$playerstats <- DT::renderDataTable({
    validate(need(!is.null(values$selectedPlayer), ""))
    tbl.statistics %>% filter(player == values$selectedPlayer) %>% data.frame()
  })
  
  h2hPanel <- sidebarLayout(
    sidebarPanel(
      uiOutput("tenisac"),
      uiOutput("nasprotnik"),
      uiOutput("turnir"),
      uiOutput("toleto")
    ),
    mainPanel(
      DT::dataTableOutput('head')
    )
  )
  
  playerPanel <- mainPanel(
    actionButton("back", "Back"),
    DT::dataTableOutput("playerstats")
    # tukaj dodajte še ostale elemente, ki jih želite prikazati
    )
  
  output$head2head <- renderUI({
    if (is.null(values$selectedPlayer)) {
      out <- h2hPanel
    } else {
      out <- playerPanel
    }
    out
  })
  
  observeEvent(eventExpr = input$player_link,
               handlerExpr = {
                 values$selectedPlayer <- input$player_link %>%
                   strapplyc("([0-9]+)") %>% unlist() %>% as.numeric()
               })
  observeEvent(eventExpr = input$back,
               handlerExpr = {
                 values$selectedPlayer <- NULL
               })
  
  observe({
    values$dropdownPlayer <- input$tenisac
  })
  
  observe({
    values$dropdownOpponent <- input$nasprotnik
  })
  
  observe({
    values$dropdownSeason <- input$toleto
  })
  
  observe({
    values$dropdownTournament <- input$turnir
  })
})