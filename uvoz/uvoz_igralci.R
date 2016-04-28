library(XML)

ustvari_igralci <- function(){
  # Tabela igralcev
  naslov <- 'http://www.tennis.com/rankings/ATP/'
  
  igralci <- readHTMLTable(naslov, which=1, stringsAsFactors = FALSE,
                           colClasses = c('integer', 'integer', 'character', 'character', 'FormattedInteger'))
  igralci <- igralci[, -2]
  igralci <- igralci[1:50, ]
  igralci$Name[grepl('  ', igralci$Name)] <- gsub('  ', ' ', igralci$Name[grepl('  ', igralci$Name)])
  
  return(igralci)
}

igralci <- ustvari_igralci()