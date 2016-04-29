library(XML)

# Ustvari tabelo za določen turnir
ustvari_tabelo_turnir <- function(ime){
  naslov <- paste('podatki/turnirji/', ime, '.html', sep='')
  tabela <- readHTMLTable(naslov, which=1, stringsAsFactors=FALSE)
  tabela <- as.data.frame(t(tabela), stringsAsFactors=FALSE)
  if(ime %in% c('wimbledon', 'roland_garros', 'australian_open', 'us_open')){
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


imena <- c('wimbledon', 'roland_garros', 'australian_open', 'us_open', 'indian_wells')

### PREMISLI, KAKO SE ZNEBIT 'for' ZANKE
matrika <- rbind(as.matrix(ustvari_tabelo_turnir(imena[1])), as.matrix(ustvari_tabelo_turnir(imena[2])))
for(i in imena[3:length(imena)]){
  matrika <- rbind(matrika, as.matrix(ustvari_tabelo_turnir(i)))
}

turnirji <- as.data.frame(matrika)

