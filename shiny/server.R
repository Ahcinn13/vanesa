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
library(plotrix)


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
     left_join(tbl.tournament %>% select(tournament = tourn_id, YEAR=year, TOURNAMENT=name)) %>%
     left_join(tbl.player %>% select(opponent = id, OPPONENT=name))
  #tbl.head2head <- tbl.head2head %>% left_join(tbl.tournament %>% select(tournament = tourn_id, name, year))
  tbl.sets <- tbl(conn, "sets") %>% left_join(tbl.head2head %>% rename (match = h2h_id, ROUND=round))
  


  t <- tbl.statistics %>% select(Name=name, Won = won, Loss = loss, SPW = perc_spw, Aces = aces, DFS = dfs, RPW = perc_rpw, BPOC = perc_bpoc,  Tiebreak_Won = tiebreak_w, 
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
  
  
 output$s <- DT::renderDataTable({
   tbl.player %>% select(-id) %>% data.frame() %>% rename('Name'=name, 'Country'=country,
                                                          'Ranking Points'=ranking_points, 'Age'=age, 'Height'=height,
                                                          'Weight'=weight, 'Plays'=plays, 'Backhand'=backhand, 'Turned Pro'=turned_pro,
                                                          'Career Titles'=career_titles, 'Prize Money Earned'=prize_money_earned, 'Coach'=coach)
 }) 
 
 
  output$sta <- DT::renderDataTable({
    # Naredimo poizvedbo

    stolpci <- c('Name', 'Season', input$izberi_stat)
    validate(need(!is.null(input$tenisaci) && !is.null(input$leto), ""))
      if (input$tenisaci != "All") {
        t <- t %>% filter(Name == input$tenisaci) #%>% select( -Name) #%>% data.frame()
      } #else {
        #stolpci <- c("Name", stolpci)
      #}
      if (input$leto != "All") {
        t <- t %>% filter(Season == input$leto) #%>% select(-Season) #%>% data.frame()
      }# else {
        #stolpci <- c(stolpci, "Season")
      #}

    t <- t %>% data.frame()
    validate(need(nrow(t) > 0, "No data match the criteria."))
    t[,stolpci]
  })

#  output$tekstime <- renderText({
#    if(!is.null(input$tenisaci) && input$tenisaci == 'All'){
#      'Vsi igralci'
#    }
#    else{
#      if(!is.null(input$tenisaci)){
#       input$tenisaci
#      }
#    }
#  })
  
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
  
  stat1 <- tbl.statistics %>% select(Name=name, Won = won, Loss = loss, SPW = perc_spw, Aces = aces, DFS = dfs, RPW = perc_rpw, BPOC = perc_bpoc,  Tiebreak_Won = tiebreak_w, 
                                 Tiebreak_Loss = tiebreak_l, Season = season) %>% data.frame()
  output$statistike <- renderUI({
    checkboxGroupInput(inputId='izberi_stat', label='Choose statistics:',
                       choices=setNames(colnames(stat1)[!colnames(stat1) %in% c('Season', 'Name', 'Player')],
                                        c('Won', 'Loss', '% Service Points Won', 'Aces', 'Double Faults', '% Return Points Won',
                                          '% Break Point Opportunities Converted', 'Tiebreaks Won', 'Tiebreaks Lost')),
                       selected=colnames(stat1)[!colnames(stat1) %in% c('Season', 'Name', 'Player')])
  })
  
  
  tur <- tbl.tournament %>% select(Name=name, Year=year, Surface=surface, Category=category, Aces_per_Match=apm,
                                   Points_per_Match=ppm, Games_per_Match=gpm, City=city, Country=country,
                                   Continent=continent) %>% data.frame()
  
  output$sta_tour <- DT::renderDataTable({
    # Naredimo poizvedbo 
    validate(need(!is.null(input$leto_t) && !is.null(input$turn) && !is.null(input$podlaga), ""))
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
  
#########################################################

    #inner_join(tbl.player, tbl.head2head, by = c("player"="name"))#tbl.head2head %>% select(Tournament = tournament) %>% data.frame()
    
    # Tole potrebujemo pri prikazu igralcev, da nam ne prikaže samo dvobojev za par (tenisac, nasprotnik), kjer je tenisac po abecedi pred nasprotnikom,
    # ker iz nekega razloga uporaba 'ali .. |' v `filter` povzroča same težave in nič več ne deluje pravilno
    h1 <- tbl.player %>% select(name, id) %>% data.frame()
    h1 <- h1[order(h1$name),]
    row.names(h1) <- 1:50   
 
    output$head <- DT::renderDataTable({
      #Naredimo poizvedbo
      h <- tbl.sets
      if (!is.null(input$turnir) && input$turnir != "All"){
        h <- h %>% filter(TOURNAMENT == input$turnir)
      }
#       if (!is.null(input$tenisac) && input$tenisac != "All"){
#         h <- h %>% filter(player == input$tenisac)
#       }
       if (!is.null(input$toleto) && input$toleto != "All"){
         h <- h %>% filter(YEAR == input$toleto)
       }
      if(!is.null(input$runda) && input$runda != 'All'){
        h <- h %>% filter(ROUND == input$runda)
      }
#       if (!is.null(input$nasprotnik) && input$nasprotnik != "All"){
#         h <- h %>% filter(opponent == input$nasprotnik)
#       }
      if(!is.null(input$tenisac) && !is.null(input$nasprotnik)){
        if(input$tenisac == input$nasprotnik){
          #h <- h %>% filter(player==input$tenisac | opponent==input$tenisac)
          st <- as.integer(row.names(h1[h1$id==input$tenisac,]))
          h <- h %>% filter(player %in% h1[1:st,2]) %>% filter(opponent %in% h1[st:50,2]) %>%
            filter(!(opponent != input$tenisac & player != input$tenisac))
          #h <- h %>% filter(opponent %in% h1[st:50,2])
          #h <- h %>% filter(!(opponent != input$tenisac & player != input$tenisac))
        }
        else{
          h2 <- h1[h1$id %in% c(input$tenisac, input$nasprotnik),]
          h <- h %>% filter(player==h2$id[1]) %>% filter(opponent==h2$id[2])
          #h <- h %>% filter((player==input$tenisac & opponent==input$nasprotnik) | (player==input$nasprotnik & opponent==input$tenisac))
        }
      }
      vrstice <- h %>% summarise(n()) %>% data.frame() %>% .[1,1]
      validate(need(vrstice > 0, ''))
      h <- h %>% group_by(match, player, opponent, ROUND, TOURNAMENT, YEAR, PLAYER, OPPONENT) %>%
        summarise(RESULT = string_agg(p1_score %||% '-' %||% p2_score, ', ')) %>% data.frame()
      validate(need(nrow(h)>0, "")) # To zdaj ne vem, če še sploh rabimo?
      h <- h[order(h$match),]
      data.frame(Tournament = h$TOURNAMENT,
                 Year = h$YEAR,
                 #Set = h$set,
                 #Match = h$match,
                 Round = h$ROUND,
                 Result = h$RESULT,
                 #P1_score = h$p1_score,
                 #P2_score = h$p2_score,
                 
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
  
  output$mini <- DT::renderDataTable({
    mn <- tbl.sets
    imena_v <- c()
    if (!is.null(input$turnir) && input$turnir != "All"){
      mn <- mn %>% filter(TOURNAMENT == input$turnir)
    }
    if (!is.null(input$toleto) && input$toleto != "All"){
      mn <- mn %>% filter(YEAR == input$toleto)
    }
    if(!is.null(input$runda) && input$runda != 'All'){
      mn <- mn %>% filter(ROUND == input$runda)
    }
    if (!is.null(input$tenisac) && !is.null(input$nasprotnik)){
      if (input$tenisac == input$nasprotnik){
        st <- as.integer(row.names(h1[h1$id==input$tenisac,]))
        mn <- mn %>% filter(player %in% h1[1:st,2]) %>% filter(opponent %in% h1[st:50,2]) %>%
          filter(!(opponent != input$tenisac & player != input$tenisac)) %>% mutate(grupiraj=1)
        
        igre_set <- mn %>% group_by(grupiraj) %>%
          summarise(st1=SUM(if(player==input$tenisac){p1_score} else{p2_score}),
                    st2=SUM(if(player==input$tenisac){p2_score} else{p1_score}), sts=COUNT(set)) %>%
          summarise(p1g=sum(st1)/sum(sts), p2g=sum(st2)/sum(sts), skupaj=(sum(st1)+sum(st2))/sum(sts)) %>%
          data.frame() %>% t()
        
        set_match <- mn %>% group_by(grupiraj) %>%
          summarise(st1=SUM(if(player==input$tenisac){if(p1_score>p2_score){1} else{0}} else{if(p1_score<p2_score){1} else{0}}),
                    st2=SUM(if(player==input$tenisac){if(p1_score<p2_score){1} else{0}} else{if(p1_score>p2_score){1} else{0}}),
                    sts=n_distinct(match)) %>%
          summarise(p1g=sum(st1)/sum(sts), p2g=sum(st2)/sum(sts), skupaj=(sum(st1)+sum(st2))/sum(sts)) %>%
          data.frame() %>% t()
        
        krog <- mn %>% group_by(ROUND) %>% summarise(st=count(ROUND)) %>% arrange(desc(st)) %>% data.frame() %>% .[1,1]
        imena_v <- c(h1$name[h1$id==input$tenisac], 'Ostali', 'Skupaj')
      }
      else{
        h4 <- h1[h1$id %in% c(input$tenisac, input$nasprotnik),]
        mn <- mn %>% filter(player==h4$id[1]) %>% filter(opponent==h4$id[2])
        
        vrstice <- mn %>% summarise(n()) %>% data.frame() %>% .[1,1]
        validate(need(vrstice > 0, ''))
        
        igre_set <- mn %>% group_by(player) %>% summarise(st1=sum(p1_score), st2=sum(p2_score), sts=count(set)) %>%
          summarise(p1g=sum(st1)/sum(sts), p2g=sum(st2)/sum(sts), skupaj=(sum(st1)+sum(st2))/sum(sts)) %>%
          data.frame() %>% t()
        
        set_match <- mn %>% group_by(player) %>%
          summarise(st1=SUM(if(p1_score>p2_score){1} else{0}), st2=SUM(if(p1_score<p2_score){1} else{0}), sts=n_distinct(match)) %>%
          summarise(p1g=sum(st1)/sum(sts), p2g=sum(st2)/sum(sts), skupaj=(sum(st1)+sum(st2))/sum(sts)) %>%
          data.frame() %>% t()
        
        krog <- mn %>% group_by(ROUND) %>% summarise(st=count(ROUND)) %>% arrange(desc(st)) %>% data.frame() %>% .[1,1]
        imena_v <- c(h4$name[1], h4$name[2], 'Skupaj')
      }
    }
    validate(need(length(imena_v)==3, ''))
    tabela <- data.frame(imena_v, igre=igre_set[,1], seti=set_match[,1], krog)
    row.names(tabela) <- NULL
    colnames(tabela) <- c('', 'Games Won per Set', 'Sets Won per Match', 'Most Common Round')
    validate(need(nrow(tabela)>0, ""))
    tabela
  })

  output$zmage <- renderPlot({
    s <- tbl.sets
    validate(need(!is.null(input$tenisac) && !is.null(input$turnir) && !is.null(input$toleto) &&!is.null(input$nasprotnik), ""))
    if (!is.null(input$turnir) && input$turnir != "All"){
      s <- s %>% filter(TOURNAMENT == input$turnir)
    }
    
    if (!is.null(input$toleto) && input$toleto != "All"){
      s <- s %>% filter(YEAR == input$toleto)
    }
    
    if(!is.null(input$runda) && input$runda != 'All'){
      s <- s %>% filter(ROUND == input$runda)
    }
    if(!is.null(input$tenisac) && !is.null(input$nasprotnik)){
      if(input$tenisac == input$nasprotnik){
        st <- as.integer(row.names(h1[h1$id==input$tenisac,]))
        s <- s %>% filter(player %in% h1[1:st,2]) %>% filter(opponent %in% h1[st:50,2]) %>%
          filter(!(opponent != input$tenisac & player != input$tenisac))
        
        s <- s %>% group_by(match, player, opponent) %>%
          summarise(st_setov=COUNT(match), st_prvi=SUM( if(player==input$tenisac){if(p1_score>p2_score){1} else{0}} else{if(p1_score<p2_score){1} else{0}} ))
        wins <- s %>% mutate(zmaga=if(st_prvi>st_setov/2){1} else{0}, grupiranje=10) %>% group_by(grupiranje) %>%
          summarise(vict=SUM(zmaga), iger=COUNT(zmaga)) %>% select(vict, iger) %>% data.frame()
        vr <- c(wins$vict, wins$iger-wins$vict)
        imena <- c(h1$name[st], 'Ostali')
        imena <- paste(imena, vr, sep=', ')
      }
      else{
        h3 <- h1[h1$id %in% c(input$tenisac, input$nasprotnik),]
        s <- s %>% filter(player==h3$id[1]) %>% filter(opponent==h3$id[2])
        s <- s %>% group_by(match, player, opponent) %>% summarise(st_setov=COUNT(match), st_prvi=SUM( if(p1_score>p2_score){1} else{0} ))
        wins <- s %>% group_by(player) %>%
          summarise(vict=SUM( if(st_prvi>st_setov/2){1} else{0} ), iger=COUNT(player)) %>% select(vict, iger) %>% data.frame()
        vr <- c(wins$vict, wins$iger-wins$vict)
        imena <- c(h3$name[1], h3$name[2])
        imena <- paste(imena, vr, sep=', ')
      }
    }
    validate(need(vr[1]>=0 && vr[2]>=0, "No data match the criteria."))
    vr[vr==0] <- 1/10000
    #pie(vr, imena, col=rainbow(length(imena)))
    par(bg="transparent")
    pie3D(vr, labels=imena, explode=0)
  })

  output$tenisac <- renderUI({
    selectInput ("tenisac", "Choose a player:",
                 choices = c(setNames(igralec$id, igralec$name)), # Odstranil '"All" = "All"'
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
                choices = c(setNames(igralec$id, igralec$name)), # Odstranil '"All" = "All"'
                selected = values$dropdownOpponent)
  })

  output$runda <- renderUI({
    selectInput('runda', 'Choose a round:',
                choices = setNames(c('All', 'F', 'S', 'Q', 'R16', 'R32', 'R64', 'R128', 'RR'),
                                   c('All','Final', 'Semi-Finals', 'Quarter-Finals', 'Round of 16', 'Round of 32',
                                     'Round of 64', 'Round of 128', 'Round-Robin')),
                selected = values$dropdownRound)
  })
  
  #Probavam sete
#  s <- tbl.sets %>% select(Player=pLAYER, Opponent=oPPONENT, Match=match, Round=ROUND,
#                           Tournament=tOURNAMENT, Year=yEAR,
#                           Set=set, P1_score=p1_score, P2_score=p2_score) %>%
#    data.frame()
  
#  output$set <- DT::renderDataTable({
    #naredimo poizvedbo
#    if (input$kje != "All"){
#      s <- s %>% filter(Tournament == input$kje) %>%
#        select(-Tournament) %>% data.frame()
#    }
#    if (input$eden != "All"){
#      s <- s %>% filter(Player == input$eden) %>%
#        data.frame()
#    }
#    validate(need(nrow(s)>0, "No data matches the criteria."))
#    s
    
#  })
  
#  output$kje <- renderUI({
#    turnik <- data.frame(tbl.tournament)
#    selectInput("turnik", "Choose a tournament:",
#    choices = c("All", setNames(turnik$name, turnik$name)))
    
#  })
#  output$eden <- renderUI({
#    clovek1 <- data.frame(tbl.player)
#    selectInput("clovek1", "Choose a player:",
#                choices = c("All", setNames(clovek1$name, clovek1$name)))
#  })
  

  
  
  #ZEMLJEVID
  output$map <- renderLeaflet({
    HH <- tbl.player %>% group_by(country) %>% summarise(stevilo = count(id)) %>% rename(region=country) %>% data.frame()
    HH$region[5] <- "UK"
    nap <- setNames (HH$stevilo, HH$region) #spravimo st ljudi v poimenovan vektor
    zem <- map("world", regions = HH$region, fill=TRUE, plot=FALSE)
    imena <- zem$names
    imena <- zem$names %>% strapplyc("^([^:]+)") %>% unlist()
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

  output$playerinfo <- DT::renderDataTable({
    validate(need(!is.null(values$selectedPlayer), ""))
    tbl.player %>% filter(id == values$selectedPlayer) %>% select(-name) %>% data.frame() %>%
      select('Rank'=id, 'Ranking Points'=ranking_points, 'Country'=country, 'Age'=age, 'Height'=height, 'Plays'=plays,
             'Backhand'=backhand, 'Turned Pro'=turned_pro, 'Career Titles'=career_titles, 'Prize Money Earned'=prize_money_earned, 'Coach'=coach)
  })
  
  output$playerstats <- DT::renderDataTable({
    validate(need(!is.null(values$selectedPlayer), ""))
    tbl.statistics %>% filter(player == values$selectedPlayer) %>% select(-c(player, name)) %>% data.frame() %>%
      select('Won'=won, 'Lost'=loss, '% SPW'=perc_spw, 'Aces'=aces, 'Double Faults'=dfs, '% RPW'=perc_rpw, '% BPOC'=perc_bpoc,
             'Tiebreaks Won'=tiebreak_w, 'Tiebreaks Lost'=tiebreak_l, 'Season'=season)
  })
  
  h2hPanel <- sidebarLayout(
    sidebarPanel(
      uiOutput("tenisac"),
      uiOutput("nasprotnik"),
      uiOutput("turnir"),
      uiOutput("toleto"),
      uiOutput("runda")
    ),
    mainPanel(
      fluidRow(
        column(6, plotOutput('zmage')),
        column(6, DT::dataTableOutput('mini'))
      ),
      fluidRow(
        DT::dataTableOutput('head')
      )
    )
  )

  
  playerPanel <- mainPanel(
    actionButton("back", "Back"),
    DT::dataTableOutput("playerinfo"),
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
                   strapplyc('([0-9]+)') %>% unlist() %>% as.numeric()
                 values$dropdownPlayer <- input$tenisac
                 values$dropdownOpponent <- input$nasprotnik
                 values$dropdownSeason <- input$toleto
                 values$dropdownTournament <- input$turnir
                 values$dropdownRound <- input$runda
               })

  observeEvent(eventExpr = input$back,
               handlerExpr = {
                 values$selectedPlayer <- NULL
               })




output$trleto <- renderUI({
  selectInput("trleto", "Choose a year:",
              choices=tur$Year,
              selected=tur$Year %in% c("2016"))
  
})

#   tourstat <- tbl.tournament %>% select(c(6,7,8)) %>% data.frame()
#   output$stati <- renderUI({
#     selectInput('stati', label='Choose statistics:',
#                        choices= c(setNames(row.names(t(tourstat)), row.names(t(tourstat)))))
#   })
#   stat1 <- tbl.statistics %>% select(Name=name, Won = won, Loss = loss, SPW = perc_spw, Aces = aces, DFS = dfs, RPW = perc_rpw, BPOC = perc_bpoc,  Tiebrak_Won = tiebreak_w, 

stat11 <- tbl.statistics %>% select(Name=name, Won = won, Loss = loss, Percentage_of_service_points_won = perc_spw, Aces = aces, Double_faults = dfs, 
                                   Percentage_of_return_points_won = perc_rpw, Percentage_of_break_point_opportunities_converted = perc_bpoc,  Tiebreaks_Won = tiebreak_w, 
                                   Tiebreaks_Lost = tiebreak_l, Season = season) %>% data.frame()
output$stati <- renderUI({
  selectInput(inputId='stati', label='Choose statistics:',
              choices=setNames(colnames(stat11)[colnames(stat11) %in% c('Aces', "Won", "Loss", "Percentage_of_service_points_won", "Double_faults", "Percentage_of_return_points_won", 
                                                               "Percentage_of_break_point_opportunities_converted", "Tiebreaks_Won", "Tiebreaks_Lost" )],
                               c('Won', 'Loss', '% Service Points Won', 'Aces', 'Double Faults', '% Return Points Won',
                                 '% Break Point Opportunities Converted', 'Tiebreaks Won', 'Tiebreaks Lost')),
              selected=colnames(stat11)[colnames(stat11) %in% c('Aces')]
  )
})


output$st <- renderUI({
  selectInput(inputId='st', label='Choose statistics:',
              choices=setNames(colnames(tur)[colnames(tur) %in% c('Aces_per_Match',
                                                         'Points_per_Match','Games_per_Match')],
                               c('Aces per Match',
                                 'Points per Match','Games per Match')),
                               
              selected=colnames(tur)[colnames(tur) %in% c('Aces_Per_Match')]
  )
})
output$statr <- renderPlot({
  # Naredimo poizvedbo
  

  validate(need(!is.null(input$trleto), ""))
  if (input$trleto != "All") {
    tur <- tur %>% filter(Year == input$trleto)
    # } else {
    #stolpci <- c("Name", "Year", stolpci)
  }
  
  
  ggplot(data.frame(tur), aes_string(x = "Name", y=input$st, color ="Name", fill= "Name"))+ geom_bar(stat = "identity", colour = "black")+theme(
    axis.text.x = element_blank()) + ylab("") + ggtitle(gsub("_", " ", input$st)) +xlab("Tournaments")
})

igralci <- data.frame(tbl.player)
output$ten <- renderUI({
  selectInput("ten", "Choose a player:",
              choices = c(igralci$name),
              selected = igralci$Name %in% c("Novak Djokovic"))
})
output$company <- renderPlot({
  #tab <- tbl.company
  validate(need(!is.null(input$ten), ""))
  if (input$ten != "All") {
    stat11 <- stat11 %>% filter(Name == input$ten)
  }

  ggplot(data.frame(stat11), aes_string(x = "Season", y =input$stati)) +geom_bar(stat = "identity", 
                                                                                 fill=c("midnightblue", "royalblue", "lightskyblue1"), colour="black") + theme_minimal()+ ggtitle(gsub("_", " ", input$stati)) +ylab("")
  })



})
# output$sta <- DT::renderDataTable({
#   # Naredimo poizvedbo
#   
#   stolpci <- input$izberi_stat
#   validate(need(!is.null(input$tenisaci) && !is.null(input$leto), ""))
#   if (input$tenisaci != "All") {
#     t <- t %>% filter(name == input$tenisaci) %>% select( -Name) #%>% data.frame()
#   } else {
#     stolpci <- c("Name", stolpci)
#   }
#   if (input$leto != "All") {
#     t <- t %>% filter(season == input$leto) %>% select(-Season) #%>% data.frame()
#   } else {
#     stolpci <- c(stolpci, "Season")
#   }
#   
#   
#   t <- t %>% data.frame()
#   validate(need(nrow(t) > 0, "No attacks match the criteria."))
#   t[,stolpci]
# })
