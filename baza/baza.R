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
    del_stat <- dbSendQuery(conn, build_sql('DROP TABLE IF EXISTS statistics'))
    del_h2h <- dbSendQuery(conn, build_sql('DROP TABLE IF EXISTS head2head'))
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
                                          name TEXT PRIMARY KEY,
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
                                          coach TEXT REFERENCES coach(name))'))

    
    
    # Ustvarimo tabelo STATISTICS
    # Še veliko za popravit
    # Mogoče 'season' ne bi bil INTEGER, ampak kaj drugega?
    statistics <- dbSendQuery(conn, build_sql('CREATE TABLE statistics (
                                              name TEXT REFERENCES player(name),
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
                                              PRIMARY KEY (name, season))'))
    
    # Ustvarimo tabelo LOCATION
    location <- dbSendQuery(conn, build_sql('CREATE TABLE location (
                                            city TEXT PRIMARY KEY,
                                            country TEXT NOT NULL,
                                            continent TEXT NOT NULL)'))
    
    # Ustvarimo tabelo TOURNAMENT
    # 'year' kot INTEGER ali kaj drugega?
    # Dodaj še 'location' in 'country' ... mislim da pravilno rešeno?
    tournament <- dbSendQuery(conn, build_sql('CREATE TABLE tournament (
                                              id TEXT,
                                              year INTEGER, 
                                              surface TEXT NOT NULL,
                                              category TEXT NOT NULL,
                                              apm NUMERIC,
                                              ppm NUMERIC,
                                              gpm NUMERIC,
                                              city TEXT REFERENCES location(city),
                                              PRIMARY KEY (id, year))'))
    
    # Ustvarimo tabelo HEAD2HEAD
    # Pri stoplcu 'tournament' kako naret, da nekateri so iz tournament(id), nekateri pa ne????
    # Kaj naret z 'round'????
     h2h <- dbSendQuery(conn, build_sql('CREATE TABLE head2head (
                                        id INTEGER PRIMARY KEY,
                                        year INTEGER NOT NULL,
                                        tournament TEXT,
                                        round TEXT,
                                        player TEXT REFERENCES player(name),
                                        opponent TEXT REFERENCES player(name))'))
    
   
    # Ustvarimo tabelo SETS
    nizi <- dbSendQuery(conn, build_sql('CREATE TABLE sets (
                                        id INTEGER REFERENCES head2head(id),
                                        set INTEGER NOT NULL,
                                        p1_score INTEGER NOT NULL,
                                        p2_score INTEGER NOT NULL,
                                        PRIMARY KEY (id, set))'))
    
    # Ustvarimo relacijo 'is_played_in'
    # Hilfe!
    #ipi <- dbSendQuery(conn, build_sql('CREATE TABLE is_played_in (
                                       #'))
    
    
  }, finally = {
    dbDisconnect(conn)
  })
}

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
