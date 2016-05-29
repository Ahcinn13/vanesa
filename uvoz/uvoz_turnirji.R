library(XML)


# Ustvari tabelo za določen turnir
ustvari_tabelo_turnir <- function(ime){
  naslov <- paste('podatki/turnirji/', ime, sep='')
  tabela <- readHTMLTable(naslov, which=1, stringsAsFactors=FALSE)
  tabela <- as.data.frame(t(tabela), stringsAsFactors=FALSE)
  if(ime %in% c('wimbledon.html', 'roland_garros.html', 'australian_open.html', 'us_open.html')){
    kat <- 'Grand Slam'
  }
  else{
    kat <- 'Masters 1000'
  }
  data.frame(ID=ime, Year=2016:2011, Surface=tabela[2:7, 2], Category=kat,
             Aces_Per_Match=tabela[2:7, 4], Points_Per_Match=tabela[2:7, 5],
             Games_Per_Match=tabela[2:7, 7], stringsAsFactors=FALSE)
}



# imena <- c('wimbledon', 'roland_garros', 'australian_open', 'us_open', 'indian_wells')
imena <- list.files('podatki/turnirji')

### PREMISLI, KAKO SE ZNEBIT 'for' ZANKE
matrika <- matrix(nrow=0, ncol=7)
for(i in imena){
  matrika <- rbind(matrika, as.matrix(ustvari_tabelo_turnir(i)))
}

turnirji <- as.data.frame(matrika, stringsAsFactors = FALSE)
turnirji[, 5:7] <- sapply(turnirji[, 5:7], function(x) as.numeric(x))
turnirji[, 2] <- sapply(turnirji[, 2], function(x) as.integer(x))

uredi_ID <- function(ime){
  ime <- gsub('.html', '', ime)
  besede <- strsplit(ime, '_')[[1]]
  paste(toupper(substring(besede, 1, 1)), substring(besede, 2), sep='', collapse=' ')
}

turnirji$ID <- sapply(turnirji$ID, function(x) uredi_ID(x))

