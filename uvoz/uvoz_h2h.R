library(httr)
library(rvest)
library(dplyr)
library(gsubfn)

head2head <- function(player1, player2) {
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

# Potrebno je popraviti nekatera imena, da se ujemajo s tistimi na tennisscores-stats.com
# Pri imena[20] (Nick Kyrgios), imena[25] (Pablo Cuevas), 
# imena[33] (Federico Delbonis), 34, 44 je problem, treba rešit!!! (Za par z Novak Djokovič)
### V RESNICI JE PROBLEM, DA NE DELUJE ZA TISTE, KI NISO ODIGRALI NOBENE MEDSEBOJNE TEKME
imena <- igralci$Name
imena[imena == 'Stanislas Wawrinka'] <- 'Stan Wawrinka'

matrika <- matrix(nrow = 0, ncol = 9)
for(i in 1:50){
  for(j in (i+1):50){ # Ne rabimo if stavka za i+1 = 50, ker imamo pol par (50, 50) in (50, 51) za (i,j) in dobimo prazno tabelo
    matrika <- rbind(matrika, as.matrix(head2head(imena[i], imena[j])))
  }
}

h2h <- as.data.frame(matrika)
colnames(h2h) <- c('Year', 'Tournament', 'Round', 'Player_1', 'Player_2', 'W/L_P1', 'Result', 'Sets_P1', 'Sets_P2')


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
