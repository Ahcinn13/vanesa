library(httr)
library(rvest)
library(dplyr)
library(gsubfn)
library(stringr)

uvoz_head2head <- function(player1, player2) {
  link <- "http://www.tennisscores-stats.com/headtohead.php"
  data <- list(search = "GO!",
               Player = player1,
               Opponent = player2,
               surface1 = "all",
               fromyear = "all",
               yearto = "all",
               tourcatall = "all")
  stran <- POST(link, body = data, encode = "form") %>%
    content("text", encoding = "UTF-8") %>% read_html()
  tabela <- stran %>% html_nodes(xpath="//table[@class='mecevi']")
  if (length(tabela) > 0) {
    h2h <- tabela[[1]] %>% html_nodes(xpath="tr[@class!='special']") %>%
      sapply(. %>% html_nodes(xpath=".//input[@type='text']") %>%
               sapply(. %>% html_attr("value"))) %>% t() %>% data.frame()
  } else {
    h2h <- data.frame(matrix(ncol=9, nrow=0))
  }
  return(h2h)
}

# h2h <- head2head("Novak Djokovic", "Andy Murray")


imena <- igralci$Name
imena[imena == 'Stanislas Wawrinka'] <- 'Stan Wawrinka'
imena <- sort(imena)

matrika <- matrix(nrow = 0, ncol = 9)
for(i in 1:49){
  for(j in (i+1):50){
    matrika <- rbind(matrika, as.matrix(uvoz_head2head(imena[i], imena[j])))
  }
}

head2head <- as.data.frame(matrika, row.names=1:dim(matrika)[1], stringsAsFactors=F)
colnames(head2head) <- c('Year', 'Tournament', 'Round', 'Player', 'Opponent', 'WL_P1', 'Result', 'Sets_P1', 'Sets_P2')


# ### TUKAJ NAREDIMO RAVNO OBRATNO TABELO ZGORNJE
# matrika1 <- matrix(nrow = 0, ncol = 9)
# for(i in 15:50){
#   for(j in 1:(i-1)){ # Ne rabimo if stavka za i+1 = 50, ker imamo pol par (50, 50) in (50, 51) za (i,j) in dobimo prazno tabelo
#     matrika1 <- rbind(matrika1, as.matrix(head2head(imena[i], imena[j])))
#   }
# }
# 
# h2h2 <- as.data.frame(matrika1, row.names = FALSE)
# colnames(h2h2) <- c('Year', 'Tournament', 'Round', 'Player_1', 'Player_2', 'W/L_P1', 'Result', 'Sets_P1', 'Sets_P2')

# ### TEST, KER 1 VRSTICA V 2. TABELI MANJKA
# ### IZKAŽE SE, DA PRI 'Gilles' - 'Tsonga' manjka 1 tekma, ki je prisotna pri 'Tsonga' - 'Gilles'
# prva <- sapply(imena, function(x) sum(head2head$Player == x))
# druga <- sapply(imena, function(x) sum(head2head$Opponent == x))
# 
# head2head[dim(head2head)[1]+1,] <- c(as.integer(2008), 'Casablanca Masters 250', 'S', 'Gilles Simon', 'Jo-Wilfried Tsonga',
#                           'W', 'WO', as.integer(0), as.integer(0))

# ### Dodajmo manjkajočo tekmo na roke
# m1 <- as.matrix(h2h2)
# m <- rbind(m1[1:1195,],
#            matrix(c(as.integer(2008), 'Casablanca Masters 250', 'S', 'Gilles Simon', 'Jo-Wilfried Tsonga',
#                     'W', 'WO', as.integer(0), as.integer(0)), 1, 9),
#            m1[1196:3903,])
# 
# h2h3 <- as.data.frame(m, row.names = FALSE)

# # Dodaj kasneje
#write.csv(h2h, 'podatki/csv/h2h.csv', row.names = FALSE)
#write.csv(h2h2, 'podatki/csv/h2h2.csv', row.names = FALSE)


#head2head <- as.matrix(h2h3) %>% rbind(as.matrix(h2h)) %>% as.data.frame()
# matrika <- matrix(nrow = 0, ncol = 9)
# for(i in 1:5){
#   if(i == 5){next}
#   for(j in (i+1):5){
#     matrika <- rbind(matrika, as.matrix(head2head(imena[i], imena[j])))
#   }
# }

# test <- matrix(nrow = 0, ncol = 9)
# ime <- 'Novak Djokovic'
# for(i in 2:50){
#   if(i %in% c(20, 25, 33, 34, 44)){next}
#   test <- rbind(test, as.matrix(head2head(ime, imena[i])))
# }


# test <- function(niz){
#   return(as.numeric(strsplit(niz, '-')[[1]][1]) > as.numeric(strsplit(niz, '-')[[1]][2]))
# }
