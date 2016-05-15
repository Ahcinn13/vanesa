### DELO Z BAZO

library(dplyr)
library(RPostgreSQL)

source('auth.R', encoding='UTF-8')

# Povežemo se z gonilnikom za PostgreSQL
drv <- dbDriver("PostgreSQL")

# Funkcija za brisanje tabel (napiši?)
delete_table <- function(){
  # Uporabimo funkcijo tryCatch,
  # da prisilimo prekinitev povezave v primeru napake
  tryCatch({
    # Vzpostavimo povezavo z bazo
    conn <- dbConnect(drv, dbname = db, host = host, user = user, password = password)
    
    # Če tabela obstaja, jo zbrišemo, ter najprej zbrišemo tiste, 
    # ki se navezujejo na druge
    dbSendQuery(conn, build_sql('DROP TABLE IF EXISTS coach'))
    dbSendQuery(conn, build_sql('DROP TABLE IF EXISTS statistics'))
    dbSendQuery(conn, build_sql('DROP TABLE IF EXISTS location'))
    dbSendQuery(conn, build_sql('DROP TABLE IF EXISTS match'))
    dbSendQuery(conn, build_sql('DROP TABLE IF EXISTS player'))
    dbSendQuery(conn, build_sql('DROP TABLE IF EXISTS tournament'))
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
    
    # Ustvarimo tabelo PLAYER
    # Preveri še kakšen tip bi lahko blo 'turned_pro', ki je leto
    player <- dbSendQuery(conn, build_sql('CREATE TABLE player (
                                        rank INTEGER NOT NULL,
                                        name TEXT PRIMARY KEY,
                                        country TEXT,
                                        ranking_points INTEGER NOT NULL,
                                        age INTEGER NOT NULL,
                                        height INTEGER NOT NULL,
                                        weight INTEGER NOT NULL,
                                        plays TEXT NOT NULL,
                                        backhand TEXT NOT NULL,
                                        turned_pro INTEGER NOT NULL,
                                        career_titles INTEGER NOT NULL,
                                        prize_money_earned INTEGER NOT NULL)'))
    
    # Ustvarimo tabelo COACH
    # Preveri kam daš 'Coaches' (koga trenira)
    coach <- dbSendQuery(conn, build_sql('CREATE TABLE coach (
                                         name TEXT PRIMARY KEY,
                                         coaches TEXT REFERENCES player(name))'))
    
    # Ustvarimo tabelo STATISTICS
    # Še veliko za popravit
    statistics <- dbSendQuery(conn, build_sql('CREATE TABLE statistics (
                                              name TEXT REFERENCES player(name),
                                              won_loss TEXT NOT NULL,
                                              perc_spw NUMERIC,
                                              aces INTEGER,
                                              dfs INTEGER,
                                              perc_rpw NUMERIC,
                                              perc_bpoc NUMERIC,
                                              tiebreak_wl TEXT,
                                              season INTEGER)'))
    
    
    
    
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
    
    #dbWriteTable(conn, name="player", igralci, overwrite=T, row.names=FALSE)
    
    
  }, finally = {
    dbDisconnect(conn)
  })
}

delete_table()
create_table()
#insert_data()
