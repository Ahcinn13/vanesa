library(httr)
library(rvest)
library(dplyr)
library(gsubfn)

head2head <- function(player1, player2) {
  link <- "http://www.tennisscores-stats.com/headtohead.php"
  data <- list(search = "GO!",
               Player = player1,
               Opponent = player2,
               Surface1 = "all",
               fromyear = "all",
               yearto = "all",
               tourcatall = "all")
  stran <- POST(link, body = data, encode = "form") %>%
    content("text", encoding = "UTF-8") %>% read_html()
  tabela <- stran %>% html_node(xpath="//table[@class='mecevi']")
  h2h <- tabela %>% html_nodes(xpath="tr[@class!='special']") %>%
    sapply(. %>% html_nodes(xpath=".//input[@type='text']") %>%
             sapply(. %>% html_attr("value"))) %>% t() %>% data.frame()
  return(h2h)
}
