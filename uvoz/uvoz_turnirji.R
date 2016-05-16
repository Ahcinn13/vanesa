library(XML)
library(httr)
library(rvest)
library(dplyr)
library(gsubfn)

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

# t1 <- ustvari_tabelo_turnir('wimbledon')
# t2 <- ustvari_tabelo_turnir('roland_garros')
# t3 <- ustvari_tabelo_turnir('australian_open')
# t4 <- ustvari_tabelo_turnir('us_open')

# ## Ne bo delovalo, če ne popraviš nekaterih imen stolpcev + dodat preostalih tabel
# turnirji <- data.frame(ID=c(t1$ID, t2$ID, t3$ID, t4$ID), Year=c(t1$Year, t2$Year, t3$Year, t4$Year),
#                    Surface=c(t1$Surface, t2$Surface, t3$Surface, t4$Surface),
#                    Category=c(t1$Category, t2$Category, t3$Category, t4$Category),
#                    Aces_Per_Match=c(t1$Aces, t2$Aces, t3$Aces, t4$Aces),
#                    Points_Per_Match=c(t1$Points, t2$Points, t3$Points, t4$Points),
#                    Games_Per_Match=c(t1$Games, t2$Games, t3$Games, t4$Games), stringsAsFactors=FALSE)


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


###################### DRUGI NAČIN

tournament.stats <- function(tournament) {
  link <- "http://www.tennisscores-stats.com/tournament-description.php"
  data <- list(search = "GO!",
               Tournament1 = tournament)
  stran <- POST(link, body = data, encode = "form") %>%
    content("text", encoding = "UTF-8") %>% read_html()
  tabela <- stran %>% html_nodes(xpath="//table[@id='tourcompall1']") %>%
    html_table() %>% .[[1]]
  return(tabela)
}

# Primer za 'Australian Open'
# Tabela še ni urejena (primerjaj z zgoraj uvoženo)
aus_test <- tournament.stats('Australian Open')
