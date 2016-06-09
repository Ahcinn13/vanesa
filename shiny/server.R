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
  tbl.head2head <- tbl(conn, "head2head")


  t <- tbl.statistics %>% select(Name=name, Won = won, Loss = loss, SPW = perc_spw, Aces = aces, DFS = dfs, RPW = perc_rpw, BPOC = perc_bpoc,  Tiebrak_Won = tiebreak_w, 
                                 Tiebreak_Loss = tiebreak_l, Season = season) %>% data.frame()
  
  output$sta <- DT::renderDataTable({
    # Naredimo poizvedbo

      if (input$tenisaci != "All") {
        t <- t %>% filter(Name == input$tenisaci) %>% select( -Name) %>% 
          data.frame()
      }
      if (input$leto != "All") {
        t <- t %>% filter(Season == input$leto) %>% select(- Season) %>% data.frame()
      }
      
      if (input$data != "All") {
        m <- as.data.frame(t(t), stringAsFactors = FALSE)
        stolpci <- row.names(m) == input$data
        t <- t %>% select(stolpci) %>% data.frame()
      }
      

    validate(need(nrow(t) > 0, "No data match the criteria."))
    t
  })

  
  
  output$tenisaci <- renderUI({
    igralci <- data.frame(tbl.player)
    selectInput("tenisaci", "Choose a player:",
                choices = c('All', setNames(igralci$name,
                                            igralci$name)))
  })
  
  output$leto <- renderUI({
    igralci <- data.frame(tbl.statistics)
    selectInput("leto", "Choose a year:",
                choices = c('All', setNames(igralci$season,
                                            igralci$season)))

    
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
  
  
  
  h <- tbl.head2head %>% select(Tournament = tournament, Player=player, Opponent=opponent) %>% data.frame()
    #inner_join(tbl.player, tbl.head2head, by = c("player"="name"))#tbl.head2head %>% select(Tournament = tournament) %>% data.frame()
  
    
    output$head <- DT::renderDataTable({
    #Naredimo poizvedbo
    if (input$turnir != "All"){
      h <- h %>% filter(Tournament == input$turnir) %>% select(-Tournament) %>% data.frame()
    }
    validate(need(nrow(h)>0, "No data match the criteria."))
    h
  })
  
  output$turnir <- renderUI({
    tourn <- data.frame (tbl.head2head)
    selectInput ("turnir", "Choose a tournament:",
                 choices = c("All", setNames(tourn$tournament,
                                             tourn$tournament)))
  })

  
})