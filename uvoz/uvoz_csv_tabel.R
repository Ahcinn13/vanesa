ustvari_tabelo <- function(ime) {
  naslov <- paste('podatki/csv/', ime, '.csv', sep='')
  return(read.table(naslov, sep = ",", skip = 1, as.is = TRUE,
                    row.names = NULL,
                    fileEncoding = "Windows-1250"
  ))
}

igralci <- ustvari_tabelo('igralci')
lokacije <- ustvari_tabelo('lokacije')
stat_2014 <- ustvari_tabelo('stat_2014') # POPRAVI ŠE WON_LOSS (TRENUTNO JE STRING)??
stat_2015 <- ustvari_tabelo('stat_2015')
stat_2016 <- ustvari_tabelo('stat_2016')
trenerji <- ustvari_tabelo('trenerji')
turnirji <- ustvari_tabelo('turnirji')

colnames(igralci) <- c('Rank', 'Name', 'Country', 'Ranking_Points', 'Age', 'Height', 'Weight', 'Plays', 'Backhand', 'Turned_pro', 'Career_Titles', 'Prize_Money_Earned')
colnames(lokacije) <- c('City', 'Country', 'Continent')
colnames(stat_2014) <- c('Name', 'Won_Loss', 'perc_SPW', 'Aces', 'DFs', 'perc_RPW', 'perc_BPOC', 'Tiebreak_WL', 'season')
colnames(stat_2015) <- c('Name', 'Won_Loss', 'perc_SPW', 'Aces', 'DFs', 'perc_RPW', 'perc_BPOC', 'Tiebreak_WL', 'season')
colnames(stat_2016) <- c('Name', 'Won_Loss', 'perc_SPW', 'Aces', 'DFs', 'perc_RPW', 'perc_BPOC', 'Tiebreak_WL', 'season')
colnames(trenerji) <- c('Name', 'Coaches')
colnames(turnirji) <- c('ID', 'Year', 'Surface', 'Category', 'Aces_Per_Match', 'Points_Per_Match', 'Games_Per_Match')
