naslov_stat_ser <- 'podatki/stat_serve_2016.html'
naslov_stat_ret <- 'podatki/stat_return_2016.html'
naslov_stat_brk <- 'podatki/stat_break_2016.html'
naslov_stat_mre <- 'podatki/stat_more_2016.html'

stat_ser <- readHTMLTable(naslov_stat_ser, which=1, stringsAsFactors = FALSE,
                          colClasses = c('integer', 'character', 'integer', 'character', 'Percent',
                                         'Percent', 'Percent', 'integer', 'Percent', 'integer',
                                         'Percent', 'Percent', 'Percent', 'Percent', 'Percent',
                                         'Percent', 'Percent', 'numeric', 'numeric'))

stat_ret <- readHTMLTable(naslov_stat_ret, which=1, stringsAsFactors = FALSE,
                          colClasses = c('integer', 'character', 'integer', 'Percent', 'Percent',
                                         'Percent', 'Percent', 'Percent', 'Percent',
                                         'Percent', 'numeric', 'numeric', 'numeric',
                                         'numeric'))

stat_brk <- readHTMLTable(naslov_stat_brk, which=1, stringsAsFactors = FALSE,
                          colClasses = c('integer', 'character', 'integer', 'Percent', 'integer',
                                         'integer', 'numeric', 'numeric', 'numeric', 'numeric',
                                         'numeric', 'Percent', 'integer', 'integer', 'numeric',
                                         'numeric', 'numeric', 'numeric', 'numeric'))

stat_mre <- readHTMLTable(naslov_stat_mre, which=1, stringsAsFactors = FALSE,
                          colClasses = c('integer', 'character', 'integer', 'numeric', 'integer',
                                         'Percent', 'integer', 'character', 'Percent', 'Percent',
                                         'integer', 'character', 'Percent', 'integer', 'character',
                                         'Percent', 'character', 'numeric', 'numeric'))

### POTREBUJEMO
# IZ SERVE: 2, 4, 6, 8, 10
# IZ RETURN: 4
# IZ BREAK: 4
# IZ MORE: 8
### ###########

#################################
# V STATISTIKI MANJKA IGRALEC #39
#################################

stat_2016 <- data.frame(Name = stat_ser[, 2], Won_Loss = stat_ser[, 4], perc_SPW = stat_ser[, 6],
                        Aces = stat_ser[, 8], DFs = stat_ser[, 10], perc_RPW = stat_ret[, 4],
                              perc_BPOC = stat_brk[, 4], Tiebreak_WL = stat_mre[, 8], season = 2016)
stat_2016[is.na(stat_2016)] <- as.numeric(0)
# colnames(stat_2016) <- c('Name', 'Won_Loss', '%_SPW', 'Aces', 'DFs', '%_RPW', '%_BPOC', 'Tiebreak_WL')