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
  # Tabela trenerjev
  naslov <- 'http://www.atpworldtour.com/en/players/coaches'
  
  trenerji <- readHTMLTable(naslov, which=2, skip.rows = 1, stringsAsFactors = FALSE)
  trenerji <- trenerji[, c(2, 4)]
  trenerji <- trenerji[trenerji[, 2] != '', ]
  
  colnames(trenerji) <- c('Name', 'Coaches')
  
  # Od tistih, ki trenirajo več oseb, samo 1 trenira top50 igralca, določimo mu torej tega igralca
  trenerji[trenerji$Name == 'Mantilla, Felix', 2] <- 'Alexandr Dolgopolov'
  
  # Spremenimo iz 'Priimek, Ime' v 'Ime Priimek'
  imena <- strsplit(trenerji$Name, ', ')
  ime_p <- c()
  for(i in 1:length(imena)){
    ime_p[i] <- paste(imena[[i]][2], imena[[i]][1], sep=' ')
  }
  trenerji$Name <- ime_p
  
  # Dodajmo sedaj manjkajoče trenerje in pripadajoče igralce (NI ZA VSE NAPISANO, DA IMAJO 2 TRENERJA)
  rownames(trenerji) <- NULL
  trenerji[length(trenerji$Name)+1, ] <- c('Boris Becker', 'Novak Djokovic')
  trenerji[length(trenerji$Name)+1, ] <- c('Severin Luthi', 'Roger Federer')
  trenerji[length(trenerji$Name)+1, ] <- c('Magnus Norman', 'Stanislas Wawrinka')
  trenerji[length(trenerji$Name)+1, ] <- c('Thierry Ascione', 'Jo-Wilfried Tsonga')
  trenerji[length(trenerji$Name)+1, ] <- c('Francisco Fogues', 'David Ferrer')
  trenerji[length(trenerji$Name)+1, ] <- c('Segi Bruguera', 'Richard Gasquet')
  trenerji[length(trenerji$Name)+1, ] <- c('Riccardo Piatti', 'Milos Raonic')
  trenerji[length(trenerji$Name)+1, ] <- c('Goran Ivanisevic', 'Marin Cilic')
  trenerji[length(trenerji$Name)+1, ] <- c('Thierry Van Cleemput', 'David Goffin')
  trenerji[length(trenerji$Name)+1, ] <- c('Mikael Tillstrom', 'Gael Monfils')
  trenerji[length(trenerji$Name)+1, ] <- c('Justin Gimelstob', 'John Isner')
  trenerji[length(trenerji$Name)+1, ] <- c('Pepe Vendrell', 'Roberto Bautista Agut')
  trenerji[length(trenerji$Name)+1, ] <- c('Lleyton Hewitt', 'Nick Kyrgios') ###### PREVERI, ČE JE RES
  trenerji[length(trenerji$Name)+1, ] <- c('Lionel Zimbler', 'Benoit Paire') 
  trenerji[length(trenerji$Name)+1, ] <- c('John Tomic', 'Bernard Tomic')
  trenerji[length(trenerji$Name)+1, ] <- c('Jack Reader', 'Viktor Troicki')
  trenerji[length(trenerji$Name)+1, ] <- c('Troy Hahn', 'Jack Sock')
  trenerji[length(trenerji$Name)+1, ] <- c('Craig Boynton', 'Steve Johnson')
  trenerji[length(trenerji$Name)+1, ] <- c('Magnus Tideman', 'Jeremy Chardy')
  trenerji[length(trenerji$Name)+1, ] <- c('João Zwestch', 'Thomaz Bellucci') ###### POSEBEN 'a' -> ã
  trenerji[length(trenerji$Name)+1, ] <- c('Craig Boynton', 'Sam Querrey') ###### ISTI TRENER KOT PRI 'Steve Johnson'
  trenerji[length(trenerji$Name)+1, ] <- c('Dejan Vojnovic', 'Marcos Baghdatis')
  trenerji[length(trenerji$Name)+1, ] <- c('Alexander Kuznetsov', 'Andrey Kuznetsov')
  trenerji[length(trenerji$Name)+1, ] <- c('Massimo Sartori', 'Andreas Seppi')
  trenerji[length(trenerji$Name)+1, ] <- c('Alexandre Lisiecki', 'Gilles Muller')
  trenerji[length(trenerji$Name)+1, ] <- c('Gustavo Marcaccio', 'Guido Pella')
  trenerji[length(trenerji$Name)+1, ] <- c('Martin Hromec', 'Martin Klizan')
  trenerji[length(trenerji$Name)+1, ] <- c('Thierry Ascione', 'Nicolas Mahut') ###### IMA 2 TRENERJA + VPISAN TRENER SE PONOVI ŠE PRI 'Jo-Wilfried Tsonga'
  trenerji[length(trenerji$Name)+1, ] <- c('Alexander Zverev Sr.', 'Alexander Zverev')
  trenerji[length(trenerji$Name)+1, ] <- c('Samuel Lopez', 'Pablo Carreno Busta') ###### IMA 2 TRENERJA
  
  return(trenerji)
}

trenerji <- ustvari_trenerji() # Ustvarimo tabelo s trenerji




### #########################
### UVOZIMO TABELO STATISTIKE
### #########################

## Uvozimo serve glede na leto
uvozi_serve <- function(leto){
  naslov <- paste('podatki/stat_serve_', leto, '.html', sep='')
  stat_serve <- readHTMLTable(naslov, which=1, stringsAsFactors = FALSE,
                              colClasses = c('integer', 'character', 'integer', 'character', 'Percent',
                                             'Percent', 'Percent', 'integer', 'Percent', 'integer',
                                             'Percent', 'Percent', 'Percent', 'Percent', 'Percent',
                                             'Percent', 'Percent', 'numeric', 'numeric'))
}

## Uvozimo return glede na leto
uvozi_return <- function(leto){
  naslov <- paste('podatki/stat_return_', leto, '.html', sep='')
  stat_return <- readHTMLTable(naslov, which=1, stringsAsFactors = FALSE,
                               colClasses = c('integer', 'character', 'integer', 'Percent', 'Percent',
                                              'Percent', 'Percent', 'Percent', 'Percent',
                                              'Percent', 'numeric', 'numeric', 'numeric',
                                              'numeric'))
}

## Uvozimo break glede na leto
uvozi_break <- function(leto){
  naslov <- paste('podatki/stat_break_', leto, '.html', sep='')
  stat_break <- readHTMLTable(naslov, which=1, stringsAsFactors = FALSE,
                              colClasses = c('integer', 'character', 'integer', 'Percent', 'integer',
                                             'integer', 'numeric', 'numeric', 'numeric', 'numeric',
                                             'numeric', 'Percent', 'integer', 'integer', 'numeric',
                                             'numeric', 'numeric', 'numeric', 'numeric'))
}

## Uvozimo more glede na leto
uvozi_more <- function(leto){
  naslov <- paste('podatki/stat_more_', leto, '.html', sep='')
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




### #########################
### UVOZIMO TABELO STATISTIKE
### #########################

ustvari_lokacije <- function() {
  return(read.table("podatki/location.csv", sep = ",", skip = 1, as.is = TRUE,
                    row.names = NULL,
                    col.names = c('City', 'Country', 'Continent'),
                    fileEncoding = "Windows-1250"
  ))
}

lokacije <- ustvari_lokacije() # Ustvarimo tabelo z lokacijami