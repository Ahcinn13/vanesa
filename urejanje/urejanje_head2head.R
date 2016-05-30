library(stringr)

head2head <- data.frame(head2head, str_split_fixed(head2head$Result, ", ", 5), row.names=1:dim(matrika)[1], stringsAsFactors = FALSE)
head2head$X1 <- sub('\\(.*', '', head2head$X1)
head2head$X2 <- sub('\\(.*', '', head2head$X2)
head2head$X3 <- sub('\\(.*', '', head2head$X3)
head2head$X4 <- sub('\\(.*', '', head2head$X4)
head2head$X5 <- sub('\\(.*', '', head2head$X5)
#potrebno še razmislit kako z nizi 
#odstranit ne potrebne stolpce
head2head <- head2head[,-c(8,9,10)]
colnames(head2head) <- c('id', 'Year', 'Tournament', 'Round', 'Player', 'Opponent', 'WL_P1', 'Set_1', 'Set_2', 'Set_3', 'Set_4', 'Set_5')


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
for(i in 1:3786){
  if(sum(head2head[i,-1] == head2head[(i+1),-1]) == 11){
    a <- c(a, i+1)
  }
}

head2head <- head2head[-a,] # Odstranimo tekme, ki se ponovijo 2-krat

for(i in 1:3759){
  if(head2head[i,8] == 'WO'){
    if(head2head[i,7] == 'W'){
      head2head[i,8] <- '1-0'
    }
    else{
      head2head[i,8] <- '0-1'
    }
  }
}

rownames(head2head) <- 1:3759
head2head$id <- rownames(head2head)

seti <- c()
did <- c()
p1_score <- c()
p2_score <- c()
for(i in 1:dim(head2head)[1]){
  for(j in 1:5){
    if(head2head[i,7+j] == ''){
      break
    }
    else{
      did <- c(did, rownames(head2head)[i])
      seti <- c(seti, j)
      p1_score <- c(p1_score, strsplit(head2head[i,7+j], '-')[[1]][1])
      p2_score <- c(p2_score, strsplit(head2head[i,7+j], '-')[[1]][2])
    }
  }
}

sets <- data.frame(id=did, set=seti, P1_score=p1_score, P2_score=p2_score, stringsAsFactors=F)
sets$P1_score <- sub('\\ R.*', '', sets$P1_score)
sets$P2_score <- sub('\\ R.*', '', sets$P2_score)

sets[,c(3,4)] <- sapply(sets[,c(3,4)], function(x) as.integer(x))

head2head <- head2head[, 1:6]
