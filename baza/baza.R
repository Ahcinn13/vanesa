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
    del_has_player <- dbSendQuery(conn, build_sql('DROP TABLE IF EXISTS has_player'))
    del_has_coach <- dbSendQuery(conn, build_sql('DROP TABLE IF EXISTS has_coach'))
    del_plays <- dbSendQuery(conn, build_sql('DROP TABLE IF EXISTS plays'))
    del_has_opponent <- dbSendQuery(conn, build_sql('DROP TABLE IF EXISTS has_opponent'))
    del_is_played <- dbSendQuery(conn, build_sql('DROP TABLE IF EXISTS is_played'))
    del_is_played_in <- dbSendQuery(conn, build_sql('DROP TABLE IF EXISTS is_played_in'))
    del_takes_place_in <- dbSendQuery(conn, build_sql('DROP TABLE IF EXISTS takes_place_in'))
    
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
                                          coach TEXT NOT NULL,
                                          player_id SERIAL PRIMARY KEY)'))
    
    
    # Ustvarimo tabelo STATISTICS
    # Še veliko za popravit
    # Mogoče 'season' ne bi bil INTEGER, ampak kaj drugega?
    statistics <- dbSendQuery(conn, build_sql('CREATE TABLE statistics (
                                              name TEXT,
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
                                              stat_id SERIAL PRIMARY KEY)'))
    
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
                                              city TEXT,
                                              tourn_id SERIAL PRIMARY KEY)'))
    
    # Ustvarimo tabelo HEAD2HEAD
    # Pri stoplcu 'tournament' kako naret, da nekateri so iz tournament(id), nekateri pa ne????
    # Kaj naret z 'round'????
    h2h <- dbSendQuery(conn, build_sql('CREATE TABLE head2head (
                                       h2h_id SERIAL PRIMARY KEY,
                                       year INTEGER NOT NULL,
                                       tournament TEXT NOT NULL,
                                       round TEXT,
                                       player TEXT,
                                       opponent TEXT)'))
    
    # Ustvarimo tabelo SETS
    nizi <- dbSendQuery(conn, build_sql('CREATE TABLE sets (
                                        match INTEGER,
                                        set INTEGER NOT NULL,
                                        p1_score INTEGER NOT NULL,
                                        p2_score INTEGER NOT NULL,
                                        sets_id SERIAL PRIMARY KEY)'))
    
    # Ustvarimo relacijo 'has_player'
    # Statistics 'has_player' Player
    has_player <- dbSendQuery(conn, build_sql('CREATE TABLE has_player (
                                              stat INTEGER REFERENCES statistics(stat_id),
                                              player INTEGER REFERENCES player(player_id))'))
    
    # Ustvarimo relacijo 'has_coach'
    # Player 'has_coach' Coach
    has_coach <- dbSendQuery(conn, build_sql('CREATE TABLE has_coach (
                                             coach TEXT REFERENCES coach(name),
                                             player INTEGER REFERENCES player(player_id))'))

    
    # Ustvarimo relacijo 'plays'
    plays <- dbSendQuery(conn, build_sql('CREATE TABLE plays (
                                         match INTEGER REFERENCES head2head(h2h_id),
                                         player INTEGER REFERENCES player(player_id))'))
    
    # Ustvarimo relacijo 'has_opponent'
    has_opponent <- dbSendQuery(conn, build_sql('CREATE TABLE has_opponent (
                                         match INTEGER REFERENCES head2head(h2h_id),
                                         opponent INTEGER REFERENCES player(player_id))'))
    
    # Ustvarimo relacijo 'is_played'
    is_played <- dbSendQuery(conn, build_sql('CREATE TABLE is_played (
                                             set INTEGER REFERENCES sets(sets_id),
                                             match INTEGER REFERENCES head2head(h2h_id))'))
    
    # Ustvarimo relacijo 'is_played_in'
    # Tu še lahko dodamo kar 'round'??
    is_played_in <- dbSendQuery(conn, build_sql('CREATE TABLE is_played_in (
                                                match INTEGER REFERENCES head2head(h2h_id),
                                                tournament INTEGER REFERENCES tournament(tourn_id))'))
    
    # Ustvarimo relacijo 'takes_place_in'
    takes_place_in <- dbSendQuery(conn, build_sql('CREATE TABLE takes_place_in (
                                                  tournament INTEGER REFERENCES tournament(tourn_id),
                                                  city TEXT REFERENCES location(city))'))
    
                                       #'))
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

stat[,12] <- 1:150
colnames(stat) <- c('Name', 'Won', 'Loss', 'perc_SPW', 'Aces', 'DFs', 'perc_RPW', 'perc_BPOC', 'Tiebreak_W', 'Tiebreak_L', 'season','id')

sets[,5] <- 1:9782
colnames(sets) <- c('id', 'Set', 'P1_score', 'P2_score', 'id')

# Vstavimo podatke iz naših tabel
insert_data <- function(){
  # Uporabimo funkcijo tryCatch,
  # da prisilimo prekinitev povezave v primeru napake
  tryCatch({
    # Vzpostavimo povezavo z bazo
    conn <- dbConnect(drv, dbname = db, host = host, user = user, password = password)
    
    vstavi_coach <- dbWriteTable(conn, name='coach', trenerji, append=T, row.names=F)
    
    vstavi_player <- dbWriteTable(conn, name='player', igralci, append=T, row.names=F)
    
    vstavi_statistics <- dbWriteTable(conn, name='statistics', stat, append=T, row.names=F)
    
    vstavi_location <- dbWriteTable(conn, name='location', lokacije, append=T, row.names=F)
    
    vstavi_tournament <- dbWriteTable(conn, name='tournament', turnirji, append=T, row.names=F)
    
    vstavi_h2h <- dbWriteTable(conn, name='head2head', head2head, append=T, row.names=F)
    
    vstavi_sets <- dbWriteTable(conn, name='sets', sets, append=T, row.names=F)
    
    
  }, finally = {
    dbDisconnect(conn)
  })
}

delete_table()
create_table()
insert_data()