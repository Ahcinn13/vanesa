ustvari_tabelo <- function(ime) {
  naslov <- paste('podatki/csv/', ime, '.csv', sep='')
  return(read.table(naslov, sep = ",", skip = 1, as.is = TRUE,
                    row.names = NULL,
                    fileEncoding = "Windows-1250"
  ))
}

igralci <- ustvari_tabelo('igralci')
lokacije <- ustvari_tabelo('lokacije')
stat <- ustvari_tabelo('statistika')
trenerji <- ustvari_tabelo('trenerji')
turnirji <- ustvari_tabelo('turnirji')
head2head <- ustvari_tabelo('head2head')

colnames(igralci) <- c('Name', 'Country', 'Ranking_Points', 'Age', 'Height', 'Weight', 'Plays', 'Backhand', 'Turned_pro', 'Career_Titles', 'Prize_Money_Earned')
colnames(lokacije) <- c('City', 'Country', 'Continent')
colnames(stat) <- c('Name', 'Won', 'Loss', 'perc_SPW', 'Aces', 'DFs', 'perc_RPW', 'perc_BPOC', 'Tiebreak_W', 'Tiebreak_L', 'season')
colnames(trenerji) <- c('Name')
colnames(turnirji) <- c('ID', 'Year', 'Surface', 'Category', 'Aces_Per_Match', 'Points_Per_Match', 'Games_Per_Match', 'City')
colnames(head2head) <- c('Year', 'Tournament', 'Round', 'Player', 'Opponent', 'WL_P1', 'Set_1', 'Set_2', 'Set_3', 'Set_4', 'Set_5')
