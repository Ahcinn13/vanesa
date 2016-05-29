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