# ### NASLEDNJA KODA JE NUJNA, ČE POGANJAŠ SAMO TO SKRIPTO
# ### ČE ZAGANJAMO 'projekt.R' LAHKO TO KODO ZAKOMENTIRAMO
# source('uvoz/uvoz.R', encoding='UTF-8')
# ########################################################

trenerji <- trenerji[, c(2, 4)] # Odstranimo neželjene stolpce

colnames(trenerji) <- c('Name', 'Coaches') # Poimenujmo stolpce

# Od tistih, ki trenirajo več oseb, samo 1 trenira top50 igralca, določimo mu torej tega igralca
trenerji[trenerji$Name == 'Mantilla, Felix', 2] <- 'Alexandr Dolgopolov'

# Odstranimo tiste trenerje, ki ne trenirajo koga iz TOP50.
trenerji <- trenerji[trenerji$Coaches %in% igralci$Name, ]

# Spremenimo način zapisa trenerjev iz 'Priimek, Ime' v 'Ime Priimek'
trenerji$Name <- sapply(trenerji$Name, function(x) paste(strsplit(x, ', ')[[1]][2], strsplit(x, ', ')[[1]][1]))

## Dodajmo sedaj manjkajoče trenerje in pripadajoče igralce (NI ZA VSE NAPISANO, DA IMAJO 2 TRENERJA)
## Seznam še MORDA ni popoln
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