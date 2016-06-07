### DELO Z BAZO

library(dplyr)
library(RPostgreSQL)

source('auth.R', encoding='UTF-8')
source('uvoz/uvoz_csv_tabel.R', encoding='UTF-8')

# Povežemo se z gonilnikom za PostgreSQL
drv <- dbDriver("PostgreSQL")

# Funkcija za brisanje tabel
delete_table <- function(){
  # Uporabimo funkcijo tryCatch,
  # da prisilimo prekinitev povezave v primeru napake
  tryCatch({
    # Vzpostavimo povezavo z bazo
    conn <- dbConnect(drv, dbname = db, host = host, user = user, password = password)
    
    # Če tabela obstaja, jo zbrišemo, ter najprej zbrišemo tiste, 
    # ki se navezujejo na druge
    del_sets <- dbSendQuery(conn, build_sql('DROP TABLE IF EXISTS sets'))
    del_h2h <- dbSendQuery(conn, build_sql('DROP TABLE IF EXISTS head2head'))
    del_stat <- dbSendQuery(conn, build_sql('DROP TABLE IF EXISTS statistics'))
    del_player <- dbSendQuery(conn, build_sql('DROP TABLE IF EXISTS player'))
    del_coach <- dbSendQuery(conn, build_sql('DROP TABLE IF EXISTS coach'))
    del_tourn <- dbSendQuery(conn, build_sql('DROP TABLE IF EXISTS tournament'))
    del_loc <- dbSendQuery(conn, build_sql('DROP TABLE IF EXISTS location'))
    
  }, finally = {
    dbDisconnect(conn)
  })
}


# Funkcija, ki ustvari tabele
# Manjka še precej tabel, večina dodanih je še tudi nepopolnih
create_table <- function(){
  # Uporabimo funkcijo tryCatch,
  # da prisilimo prekinitev povezave v primeru napake
  tryCatch({
    # Vzpostavimo povezavo z bazo
    conn <- dbConnect(drv, dbname = db, host = host, user = user, password = password)
    
    # Ustvarimo tabelo COACH
    # Preveri kam daš 'Coaches' (koga trenira)
    coach <- dbSendQuery(conn, build_sql('CREATE TABLE coach (
                                         name TEXT PRIMARY KEY)'))
    
    # Ustvarimo tabelo PLAYER
    # Preveri še kakšen tip bi lahko blo 'turned_pro', ki je leto
    player <- dbSendQuery(conn, build_sql('CREATE TABLE player (
                                          name TEXT,
                                          country TEXT NOT NULL,
                                          ranking_points INTEGER NOT NULL,
                                          age INTEGER NOT NULL,
                                          height INTEGER NOT NULL,
                                          weight INTEGER NOT NULL,
                                          plays TEXT NOT NULL,
                                          backhand TEXT NOT NULL,
                                          turned_pro INTEGER NOT NULL,
                                          career_titles INTEGER NOT NULL,
                                          prize_money_earned INTEGER NOT NULL,
                                          coach TEXT NOT NULL REFERENCES coach(name),
                                          id SERIAL PRIMARY KEY)'))
    
    
    # Ustvarimo tabelo STATISTICS
    # Še veliko za popravit
    # Mogoče 'season' ne bi bil INTEGER, ampak kaj drugega?
    # Popravi še player -> INTEGER REFERENCES player(id)
    statistics <- dbSendQuery(conn, build_sql('CREATE TABLE statistics (
                                              won INTEGER NOT NULL,
                                              loss INTEGER NOT NULL,
                                              perc_spw NUMERIC,
                                              aces INTEGER,
                                              dfs INTEGER,
                                              perc_rpw NUMERIC,
                                              perc_bpoc NUMERIC,
                                              tiebreak_w INTEGER,
                                              tiebreak_l INTEGER,
                                              season INTEGER,
                                              player INTEGER REFERENCES player(id))'))
    
    # Ustvarimo tabelo LOCATION
    location <- dbSendQuery(conn, build_sql('CREATE TABLE location (
                                            city TEXT PRIMARY KEY,
                                            country TEXT NOT NULL,
                                            continent TEXT NOT NULL)'))
    
    # Ustvarimo tabelo TOURNAMENT
    # 'year' kot INTEGER ali kaj drugega?
    # Dodaj še 'location' in 'country' ... mislim da pravilno rešeno?
    # Location popravi za manjkajoče
    tournament <- dbSendQuery(conn, build_sql('CREATE TABLE tournament (
                                              name TEXT,
                                              year INTEGER, 
                                              surface TEXT,
                                              category TEXT,
                                              apm NUMERIC,
                                              ppm NUMERIC,
                                              gpm NUMERIC,
                                              city TEXT REFERENCES location(city),
                                              tourn_id SERIAL PRIMARY KEY)'))
    
    # Ustvarimo tabelo HEAD2HEAD
    # Pri stoplcu 'tournament' kako naret, da nekateri so iz tournament(id), nekateri pa ne????
    # Kaj naret z 'round'????
    h2h <- dbSendQuery(conn, build_sql('CREATE TABLE head2head (
                                       h2h_id SERIAL PRIMARY KEY,
                                       round TEXT,
                                       tournament INTEGER REFERENCES tournament(tourn_id),
                                       player INTEGER REFERENCES player(id),
                                       opponent INTEGER REFERENCES player(id))'))
    
    # Ustvarimo tabelo SETS
    nizi <- dbSendQuery(conn, build_sql('CREATE TABLE sets (
                                        match INTEGER REFERENCES head2head(h2h_id),
                                        set INTEGER NOT NULL,
                                        p1_score INTEGER NOT NULL,
                                        p2_score INTEGER NOT NULL)'))

    pravice <- dbSendQuery(conn, build_sql('GRANT SELECT ON ALL TABLES IN SCHEMA public TO javnost'))
    pravice2 <- dbSendQuery(conn, build_sql('GRANT ALL ON DATABASE sem2016_samom TO valentinag'))                               
    pravice3 <- dbSendQuery(conn, build_sql('GRANT SELECT ON ALL TABLES IN SCHEMA public TO valentinag'))
  }, finally = {
    dbDisconnect(conn)
  })
}

igralci[,13] <- 1:50
colnames(igralci) <- c('Name', 'Country', 'Ranking_Points', 'Age', 'Height', 'Weight', 'Plays', 'Backhand', 'Turned_pro', 'Career_Titles', 'Prize_Money_Earned', 'Coach', 'id')


turnirji[,9] <- 1:592
colnames(turnirji) <- c('Name', 'Year', 'Surface', 'Category', 'Aces_Per_Match', 'Points_Per_Match', 'Games_Per_Match', 'City', 'id')
turnirji$City[592] <- NA

# Vstavimo podatke iz naših tabel
insert_data <- function(){
  # Uporabimo funkcijo tryCatch,
  # da prisilimo prekinitev povezave v primeru napake
  tryCatch({
    # Vzpostavimo povezavo z bazo
    conn <- dbConnect(drv, dbname = db, host = host, user = user, password = password)
    
    vstavi_coach <- dbWriteTable(conn, name='coach', trenerji, append=T, row.names=F)
    
    vstavi_player <- dbWriteTable(conn, name='player', igralci, append=T, row.names=F)
    
    # Uredimo tabelo statistics
    con <- src_postgres(dbname = db, host = host, user = user, password = password)
    
    tbl.player <- tbl(con, 'player')
    data.stat <- stat %>%
      inner_join(tbl.player %>% select(player = id, Name = name),
                 copy = TRUE) %>% select(-Name)
    
    vstavi_statistics <- dbWriteTable(conn, name='statistics', data.stat, append=T, row.names=F)
    #vstavi_statistics <- dbWriteTable(conn, name='statistics', stat, append=T, row.names=F)
    
    vstavi_location <- dbWriteTable(conn, name='location', lokacije, append=T, row.names=F)
    
    vstavi_tournament <- dbWriteTable(conn, name='tournament', turnirji, append=T, row.names=F)
    
    # Uredimo tabelo head2head    
    tbl.tournament <- tbl(con, "tournament")
    data.h2h <- head2head %>%
      inner_join(tbl.tournament %>%
                   select(tournament = tourn_id, Tournament = name, Year = year),
                 copy = TRUE) %>% select(-Year, -Tournament)
    
    data.h2h <- data.h2h %>%
      inner_join(tbl.player %>% select(player = id, Player = name),
                 copy = TRUE) %>% select(-Player)
    
    data.h2h <- data.h2h %>%
      inner_join(tbl.player %>% select(opponent = id, Opponent = name),
                 copy = TRUE) %>% select(-Opponent)
    
    
    vstavi_h2h <- dbWriteTable(conn, name='head2head', data.h2h, append=T, row.names=F)
    #vstavi_h2h <- dbWriteTable(conn, name='head2head', head2head, append=T, row.names=F)
    
    vstavi_sets <- dbWriteTable(conn, name='sets', sets, append=T, row.names=F)
    
    
  }, finally = {
    dbDisconnect(conn)
  })
}

delete_table()
create_table()
insert_data()
