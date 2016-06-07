# Dodajmo mesta za turnirje

turnirji$ID[turnirji$ID == 'Us Open'] <- 'US Open' #hotfix

turnirji$City <- 'Melbourne'
turnirji$City[turnirji$ID == 'Cincinnati Masters'] <- 'Cincinnati'
turnirji$City[turnirji$ID == 'French Open'] <- 'Paris'
turnirji$City[turnirji$ID == 'Indian Wells Masters'] <- 'Indian Wells'
turnirji$City[turnirji$ID == 'Italian Open'] <- 'Rome'
turnirji$City[turnirji$ID == 'Madrid Open'] <- 'Madrid'
turnirji$City[turnirji$ID == 'Miami Open'] <- 'Key Biscayne'
turnirji$City[turnirji$ID == 'Monte Carlo Masters'] <- 'Monte Carlo'
turnirji$City[turnirji$ID == 'Paris Masters'] <- 'Paris'
turnirji$City[turnirji$ID == 'Shanghai Masters'] <- 'Shanghai'
turnirji$City[turnirji$ID == 'US Open'] <- 'New York City'
turnirji$City[turnirji$ID == 'Wimbledon'] <- 'London'

turnirji$City[turnirji$ID == 'Canadian Open' & turnirji$Year %% 2 == 1] <- 'Montreal'
turnirji$City[turnirji$ID == 'Canadian Open' & turnirji$Year %% 2 == 0] <- 'Toronto'

turnirji$City[turnirji$ID == 'ATP WT Finals'] <- 'London'

manjkajoci <- c()
for(i in 1:3759){
  stevec <- 0
  for(j in 1:84){
    if((head2head$Tournament[i] == turnirji$ID[j]) & (head2head$Year[i] == turnirji$Year[j])){
      stevec <- stevec + 1
      break
    }
  }
  if(stevec == 0){
    manjkajoci <- c(manjkajoci, i)
  }
}

turnir <- c('Wimbledon')
leto <- c(2010)
for(i in manjkajoci){
  stevec <- 0
  for(j in 1:length(turnir)){
    if((head2head$Tournament[i] == turnir[j]) & (head2head$Year[i] == leto[j])){
      stevec <- stevec + 1
      break
    }
  }
  if(stevec == 0){
    turnir <- c(turnir, head2head$Tournament[i])
    leto <- c(leto, head2head$Year[i])
  }
}

dodatni_turnirji <- data.frame(ID=turnir, Year=leto, NA, NA, NA, NA, NA, NA)
turnirji <- as.data.frame(rbind(as.matrix(turnirji), as.matrix(dodatni_turnirji)))

# # Popravek za lokacije
#lokacije$Country <- sapply(lokacije$Country, function(x) substr(x, 2, nchar(x)))
#lokacije$Continent <- sapply(lokacije$Continent, function(x) substr(x, 2, nchar(x)))

