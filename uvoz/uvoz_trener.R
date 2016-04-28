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

ustvari_igralci <- function(){
  # Tabela igralcev
  naslov <- 'http://www.tennis.com/rankings/ATP/'
  
  igralci <- readHTMLTable(naslov, which=1, stringsAsFactors = FALSE,
                           colClasses = c('integer', 'integer', 'character', 'character', 'FormattedInteger'))
  igralci <- igralci[, -2]
  igralci <- igralci[1:50, ]
  igralci$Name[grepl('  ', igralci$Name)] <- gsub('  ', ' ', igralci$Name[grepl('  ', igralci$Name)])
  
  return(igralci)
}

trenerji <- ustvari_trenerji()
igralci <- ustvari_igralci()

# Odstranimo vse trenerje, ki ne trenirajo top50 igralcev
trenerji <- trenerji[trenerji$Coaches %in% igralci$Name, ]