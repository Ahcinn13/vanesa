library(XML)

#Tabel trenerjev
naslov_trenerji <- 'http://www.atpworldtour.com/en/players/coaches'

trenerji <- readHTMLTable(naslov_trenerji, which=2, skip.rows = 1, stringsAsFactors = FALSE)
trenerji <- trenerji[, c(2, 4)]
trenerji <- trenerji[trenerji[, 2] != '', ]

colnames(trenerji) <- c('Name', 'Coaches')

# Izmed trenerjev, ki trenirajo več oseb, samo ena trenira top50 igralca
trenerji[trenerji$Name == 'Mantilla, Felix', 2] <- 'Alexandr Dolgopolov'


# Tabel igralcev
naslov_igralci <- 'http://www.tennis.com/rankings/ATP/'

igralci <- readHTMLTable(naslov_igralci, which=1, stringsAsFactors = FALSE,
                         colClasses = c('integer', 'integer', 'character', 'character', 'FormattedInteger'))
igralci <- igralci[-2]
igralci <- igralci[1:50, ]
igralci$Name[grepl('  ', igralci$Name)] <- gsub('  ', ' ', igralci$Name[grepl('  ', igralci$Name)])

# Odstranimo trenerje, ki ne trenirajo koga iz top50
trenerji <- trenerji[trenerji$Coaches %in% igralci$Name, ]

# Spremenimo iz 'Priimek, Ime' v 'Ime Priimek'
imena <- strsplit(trenerji$Name, ', ')
ime_p <- c()
for(i in 1:20){
  ime_p[i] <- paste(imena[[i]][2], imena[[i]][1], sep=' ')
}
trenerji$Name <- ime_p

##################################################################
# # SPODNJA KODA JE LE ZA PREVERJANJE, KATERIH TRENERJEV ŠE NIMAMO
##################################################################
# # Dodati je potrebno še 30 trenerjev.
# for(i in trenerji$Coaches){
#   igralci[igralci$Name == i, 5] <- trenerji[trenerji$Coaches == i, 1]
# }
# colnames(igralci)[5] <- 'Coach'