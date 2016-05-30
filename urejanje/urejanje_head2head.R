library(stringr)

head2head <- data.frame(head2head, str_split_fixed(head2head$Result, ", ", 5), stringsAsFactors = FALSE)
head2head$X1 <- sub('\\(.*', '', head2head$X1)
head2head$X2 <- sub('\\(.*', '', head2head$X2)
head2head$X3 <- sub('\\(.*', '', head2head$X3)
head2head$X4 <- sub('\\(.*', '', head2head$X4)
head2head$X5 <- sub('\\(.*', '', head2head$X5)
#potrebno še razmislit kako z nizi 
#odstranit ne potrebne stolpce
head2head <- head2head[,-c(7,8,9)]
colnames(head2head) <- c('Year', 'Tournament', 'Round', 'Player', 'Opponent', 'WL_P1', 'Set_1', 'Set_2', 'Set_3', 'Set_4', 'Set_5')


#uredimo imena turnirjev
head2head$Tournament <- sub('\\ 1.*', '', head2head$Tournament)

head2head$Tournament[head2head$Tournament == 'Roland Garros'] <- 'French Open'
head2head$Tournament[head2head$Tournament == 'Rome Masters'] <- 'Italian Open'
head2head$Tournament[head2head$Tournament == 'Madrid Masters'] <-'Madrid Open'
head2head$Tournament[head2head$Tournament == 'Miami Masters'] <-'Miami Open'
head2head$Tournament[head2head$Tournament == 'Montreal Masters'] <-'Canadian Open'
head2head$Tournament[head2head$Tournament == 'Toronto Masters'] <-'Canadian Open'

head2head$Player[head2head$Player == 'Stan Wawrinka'] <- 'Stanislas Wawrinka'
head2head$Opponent[head2head$Opponent == 'Stan Wawrinka'] <- 'Stanislas Wawrinka'

#head2head <- head2head[-c(484, 515, 645, 1158, 1793, 4655),] # Odpravimo tekmi, ki se ponovita 2-krat

#View(head2head[head2head$Player == 'Andy Murray' & head2head$Opponent == 'Bernard Tomic',])
#View(head2head[head2head$Opponent == 'Andy Murray' & head2head$Player == 'Bernard Tomic',])


a <- c()
for(i in 1:7575){
  if(sum(head2head[i,1:4] == head2head[(i+1),1:4]) == 4){
    a <- c(a, i+1)
  }
}

head2head <- head2head[-a,] # Odstranimo tekme, ki se ponovijo 2-krat
