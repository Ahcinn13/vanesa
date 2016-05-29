library(XML)




### #######################
### UVOZIMO TABELO IGRALCEV
### #######################

ustvari_igralci <- function(){
  # Tabela igralcev
  naslov <- 'http://www.tennis.com/rankings/ATP/'
  
  igralci <- readHTMLTable(naslov, which=1, stringsAsFactors = FALSE,
                           colClasses = c('integer', 'integer', 'character', 'character', 'FormattedInteger'))
}

igralci <- ustvari_igralci() # Ustvarimo tabelo z igralci




### ########################
### UVOZIMO TABELO TRENERJEV
### ########################

ustvari_trenerji <- function(){
  # Povezava do tabele trenerjev
  naslov <- 'http://www.atpworldtour.com/en/players/coaches'
  trenerji <- readHTMLTable(naslov, which=2, skip.rows = 1, stringsAsFactors = FALSE)
}

trenerji <- ustvari_trenerji() # Ustvarimo tabelo s trenerji




### #########################
### UVOZIMO TABELO STATISTIKE
### #########################

## Uvozimo serve glede na leto
uvozi_serve <- function(leto){
  naslov <- paste('podatki/statistika/stat_serve_', leto, '.html', sep='')
  stat_serve <- readHTMLTable(naslov, which=1, stringsAsFactors = FALSE,
                              colClasses = c('integer', 'character', 'integer', 'character', 'Percent',
                                             'Percent', 'Percent', 'integer', 'Percent', 'integer',
                                             'Percent', 'Percent', 'Percent', 'Percent', 'Percent',
                                             'Percent', 'Percent', 'numeric', 'numeric'))
}

## Uvozimo return glede na leto
uvozi_return <- function(leto){
  naslov <- paste('podatki/statistika/stat_return_', leto, '.html', sep='')
  stat_return <- readHTMLTable(naslov, which=1, stringsAsFactors = FALSE,
                               colClasses = c('integer', 'character', 'integer', 'Percent', 'Percent',
                                              'Percent', 'Percent', 'Percent', 'Percent',
                                              'Percent', 'numeric', 'numeric', 'numeric',
                                              'numeric'))
}

## Uvozimo break glede na leto
uvozi_break <- function(leto){
  naslov <- paste('podatki/statistika/stat_break_', leto, '.html', sep='')
  stat_break <- readHTMLTable(naslov, which=1, stringsAsFactors = FALSE,
                              colClasses = c('integer', 'character', 'integer', 'Percent', 'integer',
                                             'integer', 'numeric', 'numeric', 'numeric', 'numeric',
                                             'numeric', 'Percent', 'integer', 'integer', 'numeric',
                                             'numeric', 'numeric', 'numeric', 'numeric'))
}

## Uvozimo more glede na leto
uvozi_more <- function(leto){
  naslov <- paste('podatki/statistika/stat_more_', leto, '.html', sep='')
  stat_more <- readHTMLTable(naslov, which=1, stringsAsFactors = FALSE,
                             colClasses = c('integer', 'character', 'integer', 'numeric', 'integer',
                                            'Percent', 'integer', 'character', 'Percent', 'Percent',
                                            'integer', 'character', 'Percent', 'integer', 'character',
                                            'Percent', 'character', 'numeric', 'numeric'))
}

## Ustvarimo statistiko iz zgornjih tabel
ustvari_statistiko <- function(leto){
  stat_serve <- uvozi_serve(leto)
  stat_return <- uvozi_return(leto)
  stat_break <- uvozi_break(leto)
  stat_more <- uvozi_more(leto)
  
  ### POTREBUJEMO ##########
  # IZ SERVE: 2, 4, 6, 8, 10
  # IZ RETURN: 4
  # IZ BREAK: 4
  # IZ MORE: 8
  ### ########### ##########
  
  stat <- data.frame(Name = stat_serve[, 2], Won_Loss = stat_serve[, 4], perc_SPW = stat_serve[, 6],
                     Aces = stat_serve[, 8], DFs = stat_serve[, 10], perc_RPW = stat_return[, 4],
                     perc_BPOC = stat_break[, 4], Tiebreak_WL = stat_more[, 8], season = leto,
                     stringsAsFactors = FALSE)
  # Mogoče bi blo bolše pustit NA?? Ampak verjetno ne, ker so prazna polja, kjer je 0% se mi zdi
  stat[is.na(stat)] <- as.numeric(0)
  
  # Odstranimo tage z državami (npr. [SRB])
  stat$Name <- sapply(stat$Name, function(x) substr(x, 1, nchar(x)-6))
  
  # Popravimo imena
  stat$Name[stat$Name == 'Jo Wilfried Tsonga'] <- 'Jo-Wilfried Tsonga'
  stat$Name[stat$Name == 'Guillermo Garcia Lopez'] <- 'Guillermo Garcia-Lopez'
  
  return(stat)
}

# Ustvarimo tabele s statistikami za leta 2014, 2015 in 2016
stat_2016 <- ustvari_statistiko(2016) # Poskrbi, da se naložijo pravi 2016 podatki
stat_2015 <- ustvari_statistiko(2015)
stat_2014 <- ustvari_statistiko(2014)

stat_2016 <- stat_2016[stat_2016$Name %in% igralci$Name,]
stat_2015 <- stat_2015[stat_2015$Name %in% igralci$Name,]
stat_2014 <- stat_2014[stat_2014$Name %in% igralci$Name,]

### STATISTIKE ŠE NE VKLJUČUJEJO VSEH IGRALCEV IZ NAŠEGA SEZNAMA!!!!!

# Združimo v skupno tabelo

stat <- as.data.frame(rbind(as.matrix(stat_2014), as.matrix(stat_2015), as.matrix(stat_2016)), row.names=FALSE)


### #########################
### UVOZIMO TABELO LOKACIJE
### #########################

ustvari_lokacije <- function() {
  return(read.table("podatki/location.csv", sep = ",", skip = 1, as.is = TRUE,
                    row.names = NULL,
                    col.names = c('City', 'Country', 'Continent'),
                    fileEncoding = "Windows-1250"
  ))
}

lokacije <- ustvari_lokacije() # Ustvarimo tabelo z lokacijami