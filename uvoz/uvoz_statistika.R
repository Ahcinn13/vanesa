uvozi_serve <- function(leto){
  naslov <- paste('podatki/stat_serve_', leto, '.html', sep='')
  stat_serve <- readHTMLTable(naslov, which=1, stringsAsFactors = FALSE,
                              colClasses = c('integer', 'character', 'integer', 'character', 'Percent',
                                             'Percent', 'Percent', 'integer', 'Percent', 'integer',
                                             'Percent', 'Percent', 'Percent', 'Percent', 'Percent',
                                             'Percent', 'Percent', 'numeric', 'numeric'))
}

uvozi_return <- function(leto){
  naslov <- paste('podatki/stat_return_', leto, '.html', sep='')
  stat_return <- readHTMLTable(naslov, which=1, stringsAsFactors = FALSE,
                               colClasses = c('integer', 'character', 'integer', 'Percent', 'Percent',
                                              'Percent', 'Percent', 'Percent', 'Percent',
                                              'Percent', 'numeric', 'numeric', 'numeric',
                                              'numeric'))
}

uvozi_break <- function(leto){
  naslov <- paste('podatki/stat_break_', leto, '.html', sep='')
  stat_break <- readHTMLTable(naslov, which=1, stringsAsFactors = FALSE,
                              colClasses = c('integer', 'character', 'integer', 'Percent', 'integer',
                                             'integer', 'numeric', 'numeric', 'numeric', 'numeric',
                                             'numeric', 'Percent', 'integer', 'integer', 'numeric',
                                             'numeric', 'numeric', 'numeric', 'numeric'))
}

uvozi_more <- function(leto){
  naslov <- paste('podatki/stat_more_', leto, '.html', sep='')
  stat_more <- readHTMLTable(naslov, which=1, stringsAsFactors = FALSE,
                colClasses = c('integer', 'character', 'integer', 'numeric', 'integer',
                               'Percent', 'integer', 'character', 'Percent', 'Percent',
                               'integer', 'character', 'Percent', 'integer', 'character',
                               'Percent', 'character', 'numeric', 'numeric'))
}

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

##############################################
# V STATISTIKI ZA LETO 2016 MANJKA IGRALEC #39
##############################################

stat_2016 <- ustvari_statistiko(2016) # Poskrbi, da se naložijo pravi 2016 podatki
stat_2015 <- ustvari_statistiko(2015)
stat_2014 <- ustvari_statistiko(2014)

### LETA 2014 POTREBUJEMO ŠE STATISTIKO ZA:
# Rank 20: Nick Kyrgios
# Rank 21: Benoit Paire
# Rank 38: Marcos Baghdatis
# Rank 39: Andrey Kuznetsov
# Rank 41: Andreas Seppi
# Rank 42: Gilles Muller
# Rank 43: Guido Pella
# Rank 48: Nicolas Mahut
# Rank 50: Pablo Carreno Busta
###########################################

### LETA 2015 POTREBUJEMO ŠE STATISTIKO ZA:
# Rank 39: Andrey Kuznetsov
###########################################

### LETA 2016 POTREBUJEMO ŠE STATISTIKO ZA: (to ni prava 2016 statistika, ampak zadnjih 52 tednov)
### (V pravi 2016 statistiki manjka več kot 10 igralcev, verjetno še niso igrali)
# Rank 39: Andrey Kuznetsov
###########################################