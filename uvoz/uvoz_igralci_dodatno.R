# ### NASLEDNJA KODA JE NUJNA, ČE POGANJAŠ SAMO TO SKRIPTO
# ### ČE ZAGANJAMO 'projekt.R' LAHKO TO KODO ZAKOMENTIRAMO
# source('uvoz/uvoz_igralci.R', encoding='UTF-8') # VSEBUJE TABELO igralci TER 'library(XML)'
# ########################################################

# Dodajmo stolpce v tabelo igralci, ki jih bomo sedaj zapolnili
igralci[, 5:12] <- 0
colnames(igralci) <- c('Rank', 'Name', 'Country', 'Ranking_Points', 'Age', 'Height', 'Weight', 'Plays', 'Backhand', 'Turned_Pro', 'Career_Titles', 'Prize_Money_Earned')

ustvari_tabelo <- function(naslov){
  tabela <- readHTMLTable(naslov, which=1, stringsAsFactors = FALSE,
                          colClasses = c('character', 'character', 'character'))
}

poberi_iz_tabele <- function(naslov){
  tabela <- ustvari_tabelo(naslov)
  
  age <- c(as.numeric(substr(tabela[1,1], 1, 2)), as.numeric(substr(tabela[1,3], 1, 2)))
  height <- c(as.numeric(substr(tabela[4, 1], nchar(tabela[4, 1])-6, nchar(tabela[4, 1])-4)),
              as.numeric(substr(tabela[4, 3], nchar(tabela[4, 3])-6, nchar(tabela[4, 3])-4)))
  weight <- c(as.numeric(substr(tabela[5, 1], nchar(tabela[5, 1])-5, nchar(tabela[5, 1])-4)),
              as.numeric(substr(tabela[5, 3], nchar(tabela[5, 3])-5, nchar(tabela[5, 3])-4)))
  play <- c(tabela[6, 1], tabela[6, 3])
  backhand <- c(tabela[7, 1], tabela[7, 3])
  turned_pro <- c(as.numeric(tabela[8, 1]), as.numeric(tabela[8, 3]))
  titles <- c(as.numeric(tabela[12, 1]), as.numeric(tabela[12, 3]))
  money <- c(as.numeric(gsub(',', '', substr(tabela[13, 1], 2, nchar(tabela[13, 1])))),
             as.numeric(gsub(',', '', substr(tabela[13, 3], 2, nchar(tabela[13, 3])))))
  
  return(c(age, height, weight, play, backhand, turned_pro, titles, money))
}

# Dodajajmo sedaj igralcem manjkajoče vrednosti (dodajamo po parih, npr. 1 in 2)

igralci[c(1, 2), 5:12] <- poberi_iz_tabele('http://www.atpworldtour.com/en/players/fedex-head-2-head/novak-djokovic-vs-andy-murray/D643/MC10')
igralci[c(3, 4), 5:12] <- poberi_iz_tabele('http://www.atpworldtour.com/en/players/fedex-head-2-head/roger-federer-vs-stan-wawrinka/F324/W367')
igralci[c(5, 6), 5:12] <- poberi_iz_tabele('http://www.atpworldtour.com/en/players/fedex-head-2-head/rafael-nadal-vs-kei-nishikori/N409/N552')
igralci[c(7, 8), 5:12] <- poberi_iz_tabele('http://www.atpworldtour.com/en/players/fedex-head-2-head/jo-wilfried-tsonga-vs-tomas-berdych/T786/BA47')
igralci[c(9, 10), 5:12] <- poberi_iz_tabele('http://www.atpworldtour.com/en/players/fedex-head-2-head/david-ferrer-vs-richard-gasquet/F401/G628')
igralci[c(11, 12), 5:12] <- poberi_iz_tabele('http://www.atpworldtour.com/en/players/fedex-head-2-head/milos-raonic-vs-marin-cilic/R975/C977')
igralci[c(13, 14), 5:12] <- poberi_iz_tabele('http://www.atpworldtour.com/en/players/fedex-head-2-head/david-goffin-vs-gael-monfils/GB88/MC65')
igralci[c(15, 16), 5:12] <- poberi_iz_tabele('http://www.atpworldtour.com/en/players/fedex-head-2-head/dominic-thiem-vs-john-isner/TB69/I186')
