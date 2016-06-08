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


  
 
  output$sta <- DT::renderDataTable({
    # Naredimo poizvedbo
    t <- tbl.statistics %>% filter(name == input$tenisaci) %>% select(-player, -name) %>% data.frame()
    
  })
  
  output$tenisaci <- renderUI({
    igralci <- data.frame(tbl.player)
    selectInput("tenisaci", "Choose a player:",
                choices = c('All' = 0, setNames(igralci$name,
                                                igralci$name)))
  })
  
  output$leto <- renderUI({
    #igralci <- data.frame(tbl.stat)
    selectInput("leto", "Choose a year:",
                choices = c('All' = 0, '2014' = 1, '2015' = 2, '2016'=3))
    
  })
  tour <- data.frame(tbl.tournament)
  output$turnir <- renderUI({
    selectInput("turnir", "Choose a tournament:",
                choices = c("All"= 0, setNames(tour$name,
                                            tour$name)))
    
  })
  
  output$leto_t <- renderUI({
    selectInput("leto_t", "Choose a year:",
                choices = c('All', setNames(tour$year, 
                                            tour$year)))
    
  })
  
  
})