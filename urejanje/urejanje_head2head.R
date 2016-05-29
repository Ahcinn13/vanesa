library(stringr)

#uredimo imena turnirjev
head2head$Tournament <- sub('\\ 1.*', '', head2head$Tournament)

head2head$Tournament[head2head$Tournament == 'Roland Garros'] <- 'French Open'
head2head$Tournament[head2head$Tournament == 'Rome Masters'] <- 'Italian Open'
head2head$Tournament[head2head$Tournament == 'Madrid Masters'] <-'Madrid Open'
head2head$Tournament[head2head$Tournament == 'Miami Masters'] <-'Miami Open'
head2head$Tournament[head2head$Tournament == 'Montreal Masters'] <-'Canadian Open'
head2head$Tournament[head2head$Tournament == 'Toronto Masters'] <-'Canadian Open'